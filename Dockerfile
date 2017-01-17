FROM sequenceiq/hadoop-docker:2.7.1

MAINTAINER Jiayu Liu <etareduce@gmail.com>

ENV SQOOP_HOME=/usr/lib/sqoop
ENV SQOOP_VERSION=1.99.7
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_COMMON_HOME=$HADOOP_HOME/share/hadoop/common
ENV HADOOP_HDFS_HOME=$HADOOP_HOME/share/hadoop/hdfs
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME/share/hadoop/mapreduce
ENV HADOOP_YARN_HOME=$HADOOP_HOME/share/hadoop/yarn
ENV MYSQL_JAR_VERSION=5.1.40

RUN mkdir -p $SQOOP_HOME \
    && curl -o /tmp/sqoop-$SQOOP_VERSION-bin-hadoop200.tar.gz https://mirrors.tuna.tsinghua.edu.cn/apache/sqoop/$SQOOP_VERSION/sqoop-$SQOOP_VERSION-bin-hadoop200.tar.gz \
    && tar -xvf /tmp/sqoop-$SQOOP_VERSION-bin-hadoop200.tar.gz -C $SQOOP_HOME --strip-components=1 \
    && rm /tmp/sqoop-$SQOOP_VERSION-bin-hadoop200.tar.gz \
    && mkdir -p /tmp/jdbc \
    && curl -Lo /tmp/mysql-connector-java-$MYSQL_JAR_VERSION.tar.gz https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_JAR_VERSION.tar.gz \
    && tar -xvf /tmp/mysql-connector-java-$MYSQL_JAR_VERSION.tar.gz -C /tmp/jdbc \
    && rm /tmp/mysql-connector-java-$MYSQL_JAR_VERSION.tar.gz \
    && mv /tmp/jdbc/mysql-connector-java-$MYSQL_JAR_VERSION/mysql-connector-java-$MYSQL_JAR_VERSION-bin.jar $SQOOP_HOME/server/lib/ \
    && rm -rf /tmp/mysql-connector-java-$MYSQL_JAR_VERSION/

# override the core-site

ADD core-site.xml.template $HADOOP_HOME/etc/hadoop/core-site.xml.template
ADD sqoop.properties $SQOOP_HOME/conf/

ENV PATH $SQOOP_HOME/bin:$PATH

WORKDIR $SQOOP_HOME

RUN sqoop2-tool upgrade \
    && sqoop2-tool verify

ADD entrypoint.sh $SQOOP_HOME/

EXPOSE 12000 9000

ENTRYPOINT "./entrypoint.sh"
