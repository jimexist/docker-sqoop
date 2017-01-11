FROM sequenceiq/hadoop-docker:2.7.1

MAINTAINER Jiayu Liu <etareduce@gmail.com>

ENV SQOOP_HOME=/usr/lib/sqoop \
    SQOOP_VERSION=1.99.7 \
    HADOOP_HOME=/usr/local/hadoop \
    HADOOP_COMMON_HOME=$HADOOP_HOME/share/hadoop/common \
    HADOOP_HDFS_HOME=$HADOOP_HOME/share/hadoop/hdfs \
    HADOOP_MAPRED_HOME=$HADOOP_HOME/share/hadoop/mapreduce \
    HADOOP_YARN_HOME=$HADOOP_HOME/share/hadoop/yarn

# choose a closer mirror
RUN mkdir -p $SQOOP_HOME \
    && curl -o /tmp/sqoop-$SQOOP_VERSION-bin-hadoop200.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/sqoop/$SQOOP_VERSION/sqoop-$SQOOP_VERSION-bin-hadoop200.tar.gz \
    && tar -xvf /tmp/sqoop-$SQOOP_VERSION-bin-hadoop200.tar.gz -C $SQOOP_HOME --strip-components=1 \
    && rm /tmp/sqoop-$SQOOP_VERSION-bin-hadoop200.tar.gz

# override the core-site
ADD core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
ADD sqoop.properties $SQOOP_HOME/conf/

ENV PATH $SQOOP_HOME/bin:$PATH

WORKDIR $SQOOP_HOME

RUN sqoop2-tool upgrade \
    && sqoop2-tool verify

EXPOSE 12000

CMD sqoop2-server start && tail -f $SQOOP_HOME/@LOGDIR@/sqoop.log
