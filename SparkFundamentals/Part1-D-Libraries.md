Introduction to the Spark libraries.
=========================================================
Objectives:
After completing this lesson, you should be able to understand and use the various Spark libraries including

Spark comes with libraries that you can utilize for specific use cases. These libraries are an extension of the Spark
Core API. Any improvements made to the core will automatically take effect with these libraries. One of the big
benefits of Spark is that there is little overhead to use these libraries with Spark as they are tightly integrated. The rest
of this lesson will cover on a high level, each of these libraries and their capabilities. The main focus will be on Scala
with specific callouts to Java or Python if there are major differences.

* ***The four libraries are Spark SQL, Spark Streaming, MLlib, and GraphX.***

----------------------------------------------------------
## Spark SQL
* Spark SQL allows you to write relational queries that are expressed in either SQL, HiveQL, or Scala to be executed
using Spark. 
* Spark SQL has a new RDD called the SchemaRDD. The SchemaRDD consists of rows objects and a
schema that describes the type of data in each column in the row. You can think of this as a table in a traditional
relational database.
* You create a SchemaRDD from existing RDDs, a Parquet file, a JSON dataset, or using HiveQL to query against the
data stored in Hive.
* You can write Spark SQL application using Scala, Java or Python.

----------------------------------------------------------

### The SQLContext

The SQLContext is created from the SparkContext. You can see here that in Scala, the sqlContext is created from the
SparkContext. In Java, you create the JavaSQLContext from the JavaSparkContext. In Python, you also do the same.

There is a new RDD, called the SchemaRDD that you use with Spark SQL. In Scala only, you have to import a library
to convert an existing RDD to a SchemaRDD. For the others, you do not need to import a library to work with the
Schema RDD.

### Creating SchemaRDDs
So how do these SchemaRDDs get created? There are two ways you can do this.
The first method uses reflection to infer the schema of the RDD. This leads to a more concise code and works well
when you already know the schema while writing your Spark application. The second method uses a programmatic
interface to construct a schema and then apply that to an existing RDD. This method gives you more control when you
don’t know the schema of the RDD until runtime. The next two slides will cover these two methods in more detail.

#### Reflection
The first of the two methods used to determine the schema of the RDD is to use reflection. In this scenario, use the
case class in Scala to define the schema of the table. The arguments of the case class are read using reflection and
becomes the names of the columns.

Let’s go over the code shown on the slide. First thing is to create the RDD of the person object.
* You load the text file in using the textFile method. Then you invoke the map transformation to split the elements on a
comma to get the individual columns of name and age. The final transformation creates the Person object based on the
elements. 
* Next you register the people RDD that you just created by loading in the text file and performing the transformation as
a table.
* Once the RDD is a table, you use the sql method provided by SQLContext to run SQL statements. The example here
selects from the people table, the schemaRDD.
* Finally, the results that comes out from the select statement is also a SchemaRDD.
That RDD, teenagers on our slide, can run normal RDD operations.

The programmatic interface is used when cannot define the case classes ahead of time. For example, when the structure
of records is encoded in a string or a text dataset will be parsed and fields will be projected different for different
users.

### schemaRDD
A schemaRDD is created with three steps.
* The first is to create an RDD of Rows from the original RDD. In the example, we create a schemaString of name and
age.
* The second step is to create the schema using the RDD from step one. The schema is represented by a StructType that
takes the schemaString from the first step and splits it up into StructFields. In the example, the schema is created using
the StructType by splitting the name and age schemaString and mapping it to the StructFields, name and age.
* The third step convert records of the RDD of people to Row objects. Then you apply the schema to the row RDD.

Once you have your SchemaRDD, you register that RDD as a table and then you run sql statements against it using the
sql method.

The results are returned as the SchemaRDD and you can run any normal RDD operation on it. In the example, we
select the name from the people table, which is the SchemaRDD. Then we print it out on the console.

### Spark Streaming

Spark streaming gives you the capability to process live streaming data in small batches. Utilizing Spark's core, Spark
Streaming is scalable, high-throughput and fault-tolerant. 

You write Stream programs with DStreams, which is a sequence of RDDs from a stream of data. There are various data sources that Spark Streaming receives from including,Kafka, Flume, HDFS, Kinesis, or Twitter. 

It pushes data out to HDFS, databases, or some sort of dashboard.
Spark Streaming supports Scala, Java and Python. Python was actually introduced with Spark 1.2. Python has all the
transformations that Scala and Java have with DStreams, but it can only support text data types. Support for other
sources such as Kafka and Flume will be available in future releases for Python.

Here’s a quick view of how Spark Streaming works. First the input stream comes in to Spark Streaming. Then that
data stream is broken up into batches of data that is fed into the Spark engine for processing. Once the data has been
processed, it is sent out in batches.

### Spark Stream
Spark Stream support sliding window operations. In a windowed computation, every time the window slides over a
source of DStream, the source RDDs that falls within the window are combined and operated upon to produce the
resulting RDD.

There are two parameters for a sliding window. The window length is the duration of the window and the sliding
interval is the interval in which the window operation is performed. Both of these must be in multiples of the batch
interval of the source DStream.

In the diagram, the window length is 3 and the sliding interval is 2. To put it in a different perspective, say you wanted
to generate word counts over last 30 seconds of data, every 10 seconds. To do this, you would apply the
reduceByKeyAndWindow operation on the pairs of DStream of (Word,1) pairs over the last 30 seconds of data.

Here we a have a simple example. We want to count the number of words coming in from the TCP socket. First and
foremost, you must import the appropriate libraries. 

Then, you would create the StreamingContext object. In it, you specify to use two threads with the batch interval of 1 second. Next, you create the DStream, which is a sequence of RDDs, that listens to the TCP socket on the given hostname and port. Each record of the DStream is a line of text. You split up the lines into individual words using the flatMap function. 

The flatMap function is a one-to-many DStream operation that takes one line and creates a new DStream by generating multiple records (in our case, that would be the words on the line). Finally, with the words DStream, you can count the words using the map and reduce model. Then you print out the results to the console.

One thing to note is that when each element of the application is executed, the real processing doesn’t actually happen
yet. You have to explicitly tell it to start. Once the application begins, it will continue running until the computation
terminates. The code snippets that you see here is from a full sample found in the NetworkWordCount. To run the full
example, you must first start up netcat, which is a small utility found in most Unix-like systems. This will act as a data
source to give the application streams of data to work with. Then, on a different terminal window, run the application
using the command shown here.

