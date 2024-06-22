#!/bin/bash


$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode
$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode


until hdfs dfsadmin -safemode get | grep "OFF"; do
    echo "HDFS todavía está en modo seguro, esperando..."
    sleep 5
done


$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver


echo "Creando directorios en HDFS..."
hdfs dfs -mkdir -p /user/data



#hdfs dfs -put /media/data.csv /user/data
hdfs dfs -put /media/data2.csv /user/data




tail -f /dev/null
