#!/bin/bash

$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode
$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode


until hdfs dfsadmin -safemode get | grep "OFF"; do
    echo "HDFS todavía está en modo seguro, esperando..."
    sleep 5
done


$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver



hdfs dfs -mkdir -p /user/data


hdfs dfs -put /media/prueba.csv /user/data 
hdfs dfs -put /media/data.csv /user/data
hdfs dfs -put /media/data2.csv /user/data 
hdfs dfs -put /media/data3.csv /user/data 



tail -f /dev/null
