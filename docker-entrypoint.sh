#!/bin/bash

$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode
$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode


until hdfs dfsadmin -safemode get | grep "OFF"; do
    echo "HDFS todavía está en modo seguro, esperando..."
    sleep 5
done


$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver



hdfs dfs -mkdir -p /user/data
hdfs dfs -mkdir -p /user/data/data1

hdfs dfs -put /media/prueba.csv /user/data 
hdfs dfs -put /media/data.csv /user/data/data1
hdfs dfs -put /media/data2.csv /user/data 
hdfs dfs -put /media/data3.csv /user/data && rm /media/data*.csv

if [ ! -d "/usr/local/hive/metastore_db" ]; then
    echo "Initializing Hive Metastore"
    schematool -initSchema -dbType derby -config /usr/local/apache-hive-2.3.5-bin/conf/hive-site.xml
fi

rm /usr/local/apache-hive-2.3.5-bin/lib/log4j-slf4j-impl-2.6.2.jar


tail -f /dev/null
