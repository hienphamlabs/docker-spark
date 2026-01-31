ARG SPARK_VERSION=4.0.1
ARG SCALA=2.13
FROM docker.io/apache/spark:${SPARK_VERSION}-scala${SCALA}-java21-ubuntu

USER root
RUN apt-get update && \
    apt-get install -y netcat-traditional procps curl && \
    apt-get autoremove -y && \
    apt-get clean

ARG SPARK_VERSION
ARG SCALA

RUN set -ex \
  && export HADOOP_VERSION="$(ls $SPARK_HOME/jars/hadoop-client-runtime*.jar | grep -Eo '[0-9]\.[0-9]\.[0-9]' )" SPARK_SHORT="$(echo ${SPARK_VERSION} | grep -Eo '^[0-9]\.[0-9]')" \
  && cd $SPARK_HOME/jars/ \
  && export AWS_VERSION=2.41.18 \
  && curl -LO https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar \
  && curl -Lo awssdk-${AWS_VERSION} https://repo1.maven.org/maven2/software/amazon/awssdk/bundle/${AWS_VERSION}/bundle-${AWS_VERSION}.jar

USER spark
