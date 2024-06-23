CREATE database IF NOT EXISTS hive_data;

USE hive_data;
 CREATE TABLE IF NOT EXISTS branch(
    branch_addr STRING,
    branch_type STRING,
    taken INT,
    target STRING
 )
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION 'hdfs://localhost:9000/user/data/data1/'
    TBLPROPERTIES ("skip.header.line.count"="1");