package com.abc;

import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;
import org.apache.hadoop.hbase.spark.HBaseContext;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
public class SparkHbase{
 public static void main(String[] args) {
   Configuration conf = HBaseConfiguration.create();
   conf.set("hbase.zookeeper.quorum", "127.0.0.1:2181");
   conf.addResource(new Path("/workspace/hadoop/spark-3.3.0-bin-hadoop3/conf/hbase-site.xml"));
    SparkSession spark = SparkSession
    .builder()
    .appName("Java Spark SQL basic example")
    .config("spark.some.config.option", "some-value")
    .getOrCreate(); 
    Configuration conf2 =spark.sparkContext().hadoopConfiguration();
    conf2.addResource(new Path("/workspace/hadoop/spark-3.3.0-bin-hadoop3/conf/hbase-site.xml"));
    conf2.set("hbase.zookeeper.quorum", "127.0.0.1:2181");
    new HBaseContext(spark.sparkContext(), conf, null);
    // new HBaseContext(spark.sparkContext(), conf);
    Dataset<Row> df =(spark.read().format("org.apache.hadoop.hbase.spark")
    .option("hbase.columns.mapping","rowKey STRING :key," +"firstName STRING Name:First, lastName STRING Name:Last," +
    "country STRING Address:Country, state STRING Address:State").option("hbase.table", "Person")).load();
    // df.schema();
    df.show();
 }
}