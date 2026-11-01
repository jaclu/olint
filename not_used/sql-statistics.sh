#!/usr/bin/env bash
#
#  Part of https://github.com/jaclu/olint
#
#  Copyright (c) 2024-2025: Jacob.Lundqvist@gmail.com
#
#  License: MIT
#
#  Not yet implemented future feature
#

#  -----   sqlite3   -----

f_sqlite_db="$HOME/tmp/foo/olint_stats.sqlite"
f_sqlite_error="$HOME/tmp/foo/olint_stats.err"
db_version=1
b_log_sql=false


#---------------------------------------------------------------
#
#   SQL tasks
#
#---------------------------------------------------------------

sqlite_err_handling() {
    #
    #  If SQLITE_BUSY is detected, two more attempt is done after a sleep
    #  other error handling should be done by the caller
    #
    #  Loggs sqlite errors to $f_sqlite_error
    #
    #  Variables provided:
    #    sqlite_result    - Output from query
    #
    local sql="$1"
    local sqlite_exit_code

    log_it "sqlite_err_handling([$sql])" 1
    [[ -z "$sql" ]] && error_msg "sqlite_err_handling() - no param"

    # log_it "sqlite_err_handling()" -1

    if $b_log_sql; then # set to true to log sql queries
        # this does some filtering to give a more meaningful summary
        local sql_filtered
        sql_filtered="$(echo "$sql" \
            | sed 's/BEGIN TRANSACTION; -- Start the transaction//' \
            | tr -d '\n' | tr -s ' ' | sed 's/^ //' | sed 's/ ;/;/g' \
            | sed 's/; /;/g' | cut -c 1-50)"
        log_it "SQL:$sql_filtered" -1
    fi

    # shellcheck disable=SC2034
    sqlite_result="$(sqlite3 "$f_sqlite_db" "$sql" 2>"$f_sqlite_error")"
    sqlite_exit_code=$?

    case "$sqlite_exit_code" in
        0)
            [[ -f "$f_sqlite_error" ]] && {
                log_it "><> present: $f_sqlite_error"
            }
            ;; # no error
        *)
            #  log error but leave handling error up to caller
            local e_msg
            e_msg="sqlite_err_handling()\n$sql\nerror code: $sqlite_exit_code\n"
            e_msg+="error msg:  $(cat "$f_sqlite_error")"
            error_msg "$e_msg" -1

            [[ ! -s "$f_sqlite_db" ]] && [[ -f "$f_sqlite_db" ]] && {
                #
                #  If DB was removed, then a sql action would fail but lead
                #  to an empty DB. By removing such, next call to
                #  display_losses will recreate it and restart monitoring
                #
                error_msg "DB empty, terminating"
            }
            ;;
    esac

    return "$sqlite_exit_code"
}

sqlite_transaction() {
    local sql_original="$1"
    local sql

    log_it "sqlite_transaction($sql_original)" -1
    sql="
        BEGIN TRANSACTION; -- Start the transaction

        $sql_original ;

        COMMIT; -- Commit the transaction
        "
    sqlite_err_handling "$sql"

    #
    #  this will exit true if $sqlite_err_handling is 0
    #  caller should check sqlite_exit_code or $? depending how this was
    #  called
    #
    return
}

sql_create_db() {
    local sql

    log_it "sql_create_db()" -1

    # [[ -f "$f_sqlite_db" ]] && {
    #     rm -f "$f_sqlite_db"
    #     log_it "old_db removed" -1
    # }
    #
    #  t_loss is limited to $cfg_history_size records, in order to make
    #  statistics consistent
    #
    sql="
    CREATE TABLE lint_stats (
        time_stamp TIMESTAMP DEFAULT (datetime('now')) NOT NULL,
        linter CHAR,
        fname CHAR,
        duration INT
    );

    PRAGMA journal_mode = WAL;
    PRAGMA user_version = $db_version;  -- replace DB if out of date
    "
    log_it "  - sql defined" -1
    sqlite_err_handling "$sql" || {
        _m="sqlite3 exited with: $sqlite_exit_code \n"
        _m="$_m when creating the DB"
        error_msg "$_m"
    }
    log_it "Created DB - user_version: $db_version" -1
}

sql_init() {
    log_it "sql_init($f_sqlite_db)" -1
    rm -rf "$f_sqlite_error"
    [[ ! -f "$f_sqlite_db" ]] && sql_create_db
}

sql_drop() {
    [[ -f "$f_sqlite_db" ]] && {
        echo "Removing: $f_sqlite_db"
        rm "$f_sqlite_db"
    }
}

# sql_cmd() {
#     # runs an sql cmd at existing db
#     local sql="$1"
#     [[ -z "$sql" ]] && error_msg "sql_cmd() - no param"
#     sqlite_err_handling "$sql"
# }

sql_log_lint_stats() {
    local linter="$1"
    local fname="$2"
    local duration="$3"
    local sql=
    sql="INSERT INTO lint_stats (linter, fname, duration) "
    sql+="values( '$linter', '$fname', $duration)"
    sqlite_err_handling "$sql"
}

