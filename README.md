# Spark Riak Connector Sandbox on Vagrant

This vagrant project is to play Spark Riak Connector on interactive shell easily. After running `vagrant up`, the vagrant-box is installed with Riak KV of Basho Data Platform, Spark and Spark Riak Connector.

## Getting Started

```
vagrant plugin install vagrant-cachier
vagrant up
vagrant ssh
```

It works without vagrant-cachier but I strongly recommend to use vagrant-cachier for caching downloaded files including maven local repository.

### Start spark-shell with spark-riak-connector

```
rspark-shell
```

### Run spark-riak-connector's example

```
run-example SimpleScalaRiakExample
```

```
run-example demos.ofac.OFACDemo
```

```
cd ~/spark-riak-connector/examples
run-example dataframes.SimpleScalaRiakDataframesExample
```

_SimpleScalaRiakDataframesExample requires to run at `examples` directory._

All examples is located in /home/vagrant/spark-riak-connector/examples
