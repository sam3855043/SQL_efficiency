
# 1. SQL Query Breakdown: Tablespace Usage in Oracle Database (1.sql)

This SQL query provides detailed information about the usage of tablespace in an Oracle database, focusing on free space, used space, total allocated space, and maximum available space. It also calculates percentages of space usage based on current and maximum space.

## Main Query:

The main query selects several columns related to tablespace metrics:

### Columns Selected:
- **`tablespace_name`**: The name of the tablespace, converted to uppercase using `UPPER()`.
- **`used(G)`**: The used space in the tablespace, calculated as:
  - `(D.TOT_GROOTTE_MB - F.TOTAL_BYTES)` (difference between total space and free space),
  - Converted to gigabytes (GB).
- **`free(G)`**: The free space in the tablespace, calculated from `F.TOTAL_BYTES` and converted to GB.
- **`allocation(G)`**: The total allocated space in the tablespace, calculated from `D.TOT_GROOTTE_MB` and converted to GB.
- **`free_max(G)`**: The maximum possible free space, calculated by subtracting the used space from `ddf.MAX_BYTES`, and converted to GB.
- **`max(G)`**: The maximum capacity of the tablespace, based on `ddf.MAX_BYTES`.
- **`now_per`**: The current percentage of space used, calculated as:
  - `((D.TOT_GROOTTE_MB - F.TOTAL_BYTES) * 100) / D.TOT_GROOTTE_MB`.
- **`max_per`**: The percentage of space used relative to the maximum space available, calculated as:
  - `((D.TOT_GROOTTE_MB - F.TOTAL_BYTES) * 100) / ddf.max_bytes`.

### Subqueries:
The query uses three subqueries to gather data from various views:

1. **Subquery 1 (F)**: 
   - Calculates the total free space for each tablespace by summing the `BYTES` from the `DBA_FREE_SPACE` view.
   - Groups the data by `TABLESPACE_NAME`.

2. **Subquery 2 (D)**:
   - Calculates the total allocated space for each tablespace by summing the `BYTES` from the `DBA_DATA_FILES` view.
   - Groups the data by `TABLESPACE_NAME`.

3. **Subquery 3 (ddf)**:
   - Calculates the maximum space available for each tablespace, considering whether the data files are auto-extendable. If `MAX_BYTES != 0`, it uses `MAX_BYTES`, otherwise `BYTES`.

### Join Conditions:
The query joins the three subqueries on the `TABLESPACE_NAME` column to match free space, allocated space, and maximum space for each tablespace.

### Ordering:
- The query orders the results by the ratio of used space to the maximum space available:
  - `(D.TOT_GROOTTE_MB - F.TOTAL_BYTES) / ddf.max_bytes`.
- The result is ordered in descending order, meaning tablespaces with the highest usage percentage are listed first.

### Comments in the Query:
- The query contains some commented-out parts:
  - **Estimation of required files**: The part calculating the number of files needed to accommodate the required space is commented out.
  - **Excluding undo tablespaces**: The filter to exclude tablespaces associated with undo extents is also commented out. If enabled, it would exclude certain tablespaces from the results.

## Notes:
1. **Typo in `TOT_GROOTTE_MB`**: There seems to be a typo in the alias name (`TOT_GROOTTE_MB`), which should be corrected to something like `TOT_SIZE_MB` or `TOTAL_SIZE_MB`.
2. **Percentage Calculations**: The columns `now_per` and `max_per` help identify the tablespaces that are approaching full capacity, which is useful for monitoring and management.
3. **Performance Considerations**: 
   - If the database is large, the `DBA_FREE_SPACE` and `DBA_DATA_FILES` tables can contain significant amounts of data, which could impact query performance.

Feel free to modify the query further or ask for more specific adjustments if needed!

<div style="height:50px;"></div>

# 2. SQL Query Breakdown: SYSAUX Occupants Space Usage (2.sql)

This SQL query retrieves the space usage information of various occupants in the `SYSAUX` tablespace of an Oracle database. The query specifically focuses on listing the name and description of each occupant, along with the amount of space they are using.



## Query Explanation:

### Columns Selected:
- **`occupant_name`**: The name of the occupant in the `SYSAUX` tablespace.
- **`occupant_desc`**: A description of the occupant, providing further context about its function or purpose in the `SYSAUX` tablespace.
- **`GB`**: The space usage of each occupant, which is calculated as follows:
  - **`space_usage_kbytes`**: The space used by the occupant in kilobytes (KB).
  - The value is converted from kilobytes to gigabytes (GB) by dividing by `1024` (to convert KB to MB), and then dividing again by `1024` (to convert MB to GB).
  - The result is rounded to two decimal places for better readability.

### Ordering:
- The query orders the results by the converted space usage in gigabytes (`GB`), in descending order. This ensures that the occupant using the most space appears first.

### Summary of Result:
The result will display each occupant of the `SYSAUX` tablespace, along with a description and the amount of space they are using (in GB), ordered from the largest space user to the smallest.

## Notes:
- The space usage is measured in kilobytes but displayed in gigabytes (GB) for easier understanding of larger storage sizes.
- `v$sysaux_occupants` is a dynamic performance view in Oracle that provides information about the various components (occupants) that are using space in the `SYSAUX` tablespace.

Feel free to adjust the query or ask for further clarifications if needed!


<div style="height:50px;"></div>

# 3.SQL Query Breakdown: Large Segments in SYSAUX Tablespace

This SQL query retrieves information about the segments in the `SYSAUX` tablespace of an Oracle database that use more than 10 MB of space. It provides details such as the owner, segment name, space usage, and segment type.

## Query Explanation:

### Columns Selected:
- **`owner`**: The schema owner of the segment (i.e., the user or schema in which the segment resides).
- **`segment_name`**: The name of the segment in the `SYSAUX` tablespace.
- **`bytes/1024/1024`**: The space usage of the segment, calculated in megabytes (MB):
  - **`bytes`**: The space used by the segment in bytes.
  - The query divides the byte value by `1024` twice (to convert from bytes to kilobytes, then to megabytes).
- **`segment_type`**: The type of the segment (e.g., TABLE, INDEX, CLUSTER, etc.).

### WHERE Clause:
- **`tablespace_name='SYSAUX'`**: Filters the segments to include only those within the `SYSAUX` tablespace.
- **`bytes>1024*1024*10`**: Filters the segments to include only those that use more than 10 MB of space (the condition `bytes > 1024 * 1024 * 10` checks for segments larger than 10 MB).

### Ordering:
- The results are ordered by the space usage (in MB) in descending order (`order by 3 desc`). This ensures that the largest segments (by space usage) appear first in the result.

## Summary of Result:
The result will display:
1. The schema owner of each segment in the `SYSAUX` tablespace.
2. The segment name.
3. The space used by the segment (in MB).
4. The type of the segment.

All segments listed will be larger than 10 MB in space usage, and they will be ordered from the largest to the smallest.

## Notes:
- The `dba_segments` view is a data dictionary view that contains information about all segments (tables, indexes, etc.) in the database.
- The `SYSAUX` tablespace is used for auxiliary storage, containing non-user-specific objects like system components and statistics.

Feel free to adjust the query or ask for further clarifications if needed!


<div style="height:50px;"></div>

# 4.SQL Query Breakdown: Partition Information for a Specific Table (4.sql)

This SQL query retrieves partition-related information for the table `AUD$UNIFIED` from the `dba_tab_partitions` view in an Oracle database. It provides details about the partitions of the specified table, including partition names, space usage, and statistics.

## Query Explanation:

### Columns Selected:
- **`table_owner`**: The owner (schema) of the table.
- **`table_name`**: The name of the table. In this case, it’s filtered to the table `AUD$UNIFIED`.
- **`partition_name`**: The name of each partition of the table.
- **`INTERVAL`**: The interval for the partition if the partitioning method is interval-based.
- **`HIGH_VALUE`**: The high value for the partition, indicating the upper bound for the partition’s range.
- **`HIGH_VALUE_LENGTH`**: The length of the `HIGH_VALUE` in bytes.
- **`num_rows`**: The number of rows in the partition.
- **`blocks*8/1024 MB`**: The space used by the partition in megabytes (MB), calculated by multiplying the number of blocks (`blocks`) by 8 KB (since each block is 8 KB), then converting it to MB by dividing by 1024.
- **`last_analyzed`**: The date and time when the partition’s statistics were last analyzed.

### WHERE Clause:
- **`table_name = 'AUD$UNIFIED'`**: Filters the results to show only partitions for the `AUD$UNIFIED` table.

## Summary of Result:
The query will return information about all partitions of the `AUD$UNIFIED` table, including:
1. The table's owner.
2. The partition name.
3. The partitioning interval (if applicable).
4. The high value and length of the partition.
5. The number of rows in the partition.
6. The space used by the partition in MB.
7. The last time the partition’s statistics were analyzed.

## Notes:
- **`dba_tab_partitions`**: This view contains information about all partitions for tables in the database, providing details such as partition names, sizes, and other attributes.
- The table `AUD$UNIFIED` is often related to auditing or unified auditing in Oracle, but this query specifically focuses on its partition information.

Feel free to modify the query or ask for further clarifications if needed!



# SQL Query Breakdown: TRUNCATE Table

This SQL query is used to **truncate** the `AUD$UNIFIED` table in the `AUDSYS` schema, which is typically used for auditing purposes in Oracle databases. The `TRUNCATE` statement is used to remove all rows from a table quickly and efficiently.

## Query Explanation:

### Query:
```sql
TRUNCATE TABLE audsys.aud$unified;
```

#
# PL/SQL Block Breakdown: Altering Audit Partition Interval

This PL/SQL block is used to modify the partition interval for Oracle's Unified Auditing. Specifically, it uses the `DBMS_AUDIT_MGMT` package to adjust the partition interval frequency.

## Query Explanation:

### PL/SQL Block:

```sql
BEGIN
  DBMS_AUDIT_MGMT.ALTER_PARTITION_INTERVAL(
    interval_number       => 1,
    interval_frequency    => 'DAY');
END;
```
# Explanation of PL/SQL Block: Setting Last Archive Timestamp

This PL/SQL block is used to set the last archive timestamp for the unified audit trail in Oracle. It helps in managing the retention and cleanup of audit data by defining when the last set of audit records were archived.

## PL/SQL Block:

```sql
BEGIN
  DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(
    AUDIT_TRAIL_TYPE     =>  DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
    LAST_ARCHIVE_TIME    =>  SYSDATE-10 );
END;
/
```

# Explanation of PL/SQL Block: Cleaning the Unified Audit Trail

This PL/SQL block is used to clean (delete) old audit records from the unified audit trail. It helps in managing the storage and performance of the system by removing unnecessary audit data.

## PL/SQL Block:

```sql
BEGIN
  DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
    audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_UNIFIED,
    container => DBMS_AUDIT_MGMT.CONTAINER_CURRENT,
    use_last_arch_timestamp => FALSE);
END;
/
```

# Explanation of PL/SQL Block: Cleaning the Standard Audit Trail

This PL/SQL block is used to clean (delete) old records from the standard audit trail in Oracle. It removes audit records based on the last archive timestamp, helping to manage storage and optimize system performance.

## PL/SQL Block:

```sql
BEGIN
  DBMS_AUDIT_MGMT.CLEAN_AUDIT_TRAIL(
    AUDIT_TRAIL_TYPE => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,
    USE_LAST_ARCH_TIMESTAMP => TRUE);
END;
/
