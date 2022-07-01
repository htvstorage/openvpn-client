package com.abc;

import org.apache.spark.sql.SparkSession;
import org.apache.spark.sql.Dataset;
import org.apache.spark.sql.Row;

public class SparkLoad{
 public static void main(String[] args) {
    SparkSession spark = SparkSession
    .builder()
    .appName("Java Spark SQL basic example")
    .config("spark.some.config.option", "some-value")
    .getOrCreate(); 
    Dataset<Row> df = spark.read().json("/workspace/hadoop/people.json");
    df.show();
 }
}