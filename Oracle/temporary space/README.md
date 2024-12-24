# 1.sql
The SQL query  is designed to retrieve detailed information about active sessions using temporary space, their associated SQL queries, and various metrics such as the amount of temporary space allocated and the percentage of temporary space used.

### 1.Inner Query(Column selected):
 - ### It retrieves the following columns
   - `sample_time:` Time of the sample when the session activity was recorded.
   - `PARSING_SCHEMA_NAME:` The schema in which the SQL is parsed.
   - `sql_id:` Identifier for the SQL query being executed.
   - `sql_child:` The child number of the SQL query.
   - `temp_used:` The temporary space used, formatted as GB.
   - `temp_pct:` The percentage of the total temporary space used by this session.
   - `program:` The program that initiated the session.
   - `module:` The module name associated with the session.
   - `SQL_TEXT:` The actual SQL query being executed.
   - `session_id:` The identifier of the session.
### 2. Conditions in the WHERE Clause:
 - The `sample_time` must fall between two specific date and time values (represented by the placeholders '日期').
 - The temp_space_allocated column must not be null, ensuring only sessions with temporary space usage are selected.
 - The sql_id from the active session history is matched with the SQL_ID from the v$sql view.
### 3. Calculation and Formatting:
 - The `temp_used` is calculated by converting the `temp_space_allocated` from bytes to gigabytes (GB), rounded to two decimal places, and then concatenated with ' G' for clarity.
 - The `temp_pct` represents the percentage of total temporary space used by the session. The query calculates the total maximum space for temporary files by summing up the `maxbytes` or bytes (depending on whether the file is autoextensible), then dividing the session's temporary space usage by this value and multiplying by 100. It is formatted as a percentage (with ' %' appended).
### 4. Ordering:
 - The data is ordered by `temp_space_allocated` in descending order, meaning the sessions using the most temporary space will appear first.
 - In the outer query, the result is limited to the top 50 rows using `rownum < 50`, and it is then ordered by the formatted `temp_used` in descending order

## Notes:
 - Replace the `'日期'` placeholders with actual date values in the format `yyyy-mm-dd hh24:mi:ss` (e.g., `'2024-12-24 14:00:00'`).
 - The query assumes that `v$active_session_history` and `v$sql` are available in your Oracle environment and that the appropriate privileges are granted.