#!/bin/bash

. /vagrant/lib/utils.sh

ADDRESS=$1

BDP_VERSION=1.0.0
SPARK_VERSION=1.4.1
# FIXME change 1.1.0 or later after its release
CONNECTOR_VERSION=ad9e0d760c1ce34f4a705f3c3984aa67b78fdd08
CONNECTOR_NAME=spark-riak-connector-examples-1.1.0-SNAPSHOT

install_packages() {
  apt-get install -y --no-install-recommends python-software-properties curl
}


install_bdp() {
  echo "Installing Basho Data Platform..."
  curl -s https://packagecloud.io/install/repositories/basho/bdp/script.deb.sh | bash
  apt-get install -y data-platform=${BDP_VERSION}-1
}

install_spark() {
  echo "Installing Spark..."
  download http://ftp.riken.jp/net/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz
  tar zxfv spark-${SPARK_VERSION}-bin-hadoop2.6.tgz
  mv spark-${SPARK_VERSION}-bin-hadoop2.6 /opt/
  ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop2.6 /opt/spark
  echo 'export PATH=$PATH:/opt/spark/bin:/opt/spark/sbin' > /etc/profile.d/spark.sh
}

install_riak_spark_connector() {
  echo "Installing riak-spark-connector..."
  apt-get install -y git maven
  git clone https://github.com/basho/spark-riak-connector.git
  pushd spark-riak-connector
  git checkout ${CONNECTOR_VERSION}
  mvn -DskipTests package
  unzip examples/target/${CONNECTOR_NAME}-REPL.zip -d /opt
  ln -s /opt/${CONNECTOR_NAME} /opt/spark-riak-connector-examples
  popd
  echo 'export PATH=$PATH:/opt/spark-riak-connector-examples/bin' > /etc/profile.d/spark-riak-connector.sh
}

setup_bdp() {
  echo "Updating riak.conf for sandbox..."
  #sed -i.back 's/storage_backend = bitcask/storage_backend = leveldb/' /etc/riak/riak.conf
  sed -i.back 's/leveldb.maximum_memory.percent = 70/leveldb.maximum_memory.percent = 30/' /etc/riak/riak.conf
  sed -i.back 's/## ring_size = 64/ring_size = 16/' /etc/riak/riak.conf
  sed -i.back 's/127.0.0.1:8098/0.0.0.0:8098/' /etc/riak/riak.conf
  sed -i.back 's/127.0.0.1:8087/0.0.0.0:8087/' /etc/riak/riak.conf
  sed -i.back "s/riak@127.0.0.1/riak@$ADDRESS/" /etc/riak/riak.conf
  service riak start
}

increase_open_files
install_packages
install_open_jdk
install_bdp
install_spark
install_riak_spark_connector
setup_bdp
