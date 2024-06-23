FROM rayen231/data:latest as dataset
FROM suhothayan/hadoop-spark-pig-hive:2.9.2

ENV HADOOP_HOME=/usr/local/hadoop-2.9.2

RUN apt-get update && apt-get install -y nano wget && rm -rf /var/lib/apt/lists/*


COPY mapred-site.xml $HADOOP_HOME/etc/hadoop/
COPY hive-site.xml /usr/local/apache-hive-2.3.5-bin/conf/hive-site.xml
RUN mkdir -p /usr/local/hive/metastore_db && rm -rf /usr/local/hive/metastore_db


COPY script1.pig /media
COPY script2.pig /media
COPY hive.sql /media
COPY prueba.csv /media

COPY --from=dataset /data/data.csv /media
COPY --from=dataset /data/data2.csv /media
COPY --from=dataset /data/data3.csv /media


# Copiar y dar permisos al script de entrada
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh


# Definir el punto de entrada
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

