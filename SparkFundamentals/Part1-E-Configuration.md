
Spark configuration, monitoring and tuning.
===============================================================

Objectives:
After completing this lesson, you should be able to: 
* Describe the cluster overview. 
* Configure Spark by modifying Spark
properties, environmental variables or logging properties. 
* Monitor Spark and its applications using the Web UIs,
metrics and various other external tools. 
* Performance tuning considerations.

### Components of a Spark Cluster

There are three main components of a Spark cluster. 

- 1. Driver
- 2. Cluster Manager
- 3. Worker Nodes

You have the driver, where the SparkContext is located within the
main program. To run on a cluster, you would need some sort of cluster manager. This could be either Spark’s
standalone cluster manager, Mesos or Yarn. Then you have your worker nodes where the executor resides. The
executors are the processes that run computations and store the data for the application. The SparkContext sends the
application, defined as JAR or Python files to each executor. Finally, it sends the tasks for each executor to run.

#### Executors

Several things to understand about this architecture.
Each application gets its own executor. The executor stays up for the entire duration of the application. The benefit of
this is that the applications are isolated from each other, on the scheduling side and running on different JVMs.
However, this means that you cannot share data across applications. You would need to externalize the data if you wish
to share data between thedifferent applications.

Spark applications don’t care about the underlying cluster manager. As long as it can acquire executors and
communicate with each other, it can run on any cluster manager.

Because the driver program schedules tasks on the cluster, it should run close to the worker nodes on the same local
network. If you like to send remote requests to the cluster, it is better to use a RPC and have it submit operations from
nearby.

There are currently three supported cluster managers that we have mentioned before.
 
1. Sparks comes with a standalone manager that you can use to get up and running. 
2. You can use Apache Mesos, a general cluster manager that can run and service Hadoop jobs.
3. You can also use Hadoop YARN, the resource manager in Hadoop 2. 

*In the lab bexercise, you will be using BigInsights with Yarn to run your Spark applications.*

---------------------------------------------------------------------------------------

#### Spark configuration.

There are three main locations for Spark configuration. You have the Spark properties, where the application
parameters can be set using the SparkConf object or through Java system properties.
Then you have the environment variables, which can be used to set per machine settings such as IP address. This is
done through the ``conf/spark-env.sh`` script on each node.

Finally, you also have your logging properties, which can be configured through log4j.properties. You can choose to
override the default configuration directory, which is currently under the ``SPARK_HOME/conf`` directory. Set the
``SPARK_CONF_DIR`` environment variable and provide your custom configuration files under that directory.

In the lab exercise, the Spark shell can be verbose, so if you wish, change it from INFO to ERROR in the
log4j.properties to reduce all the information being printed on the console.

------------------------------------------------------------------------------------------------
### Setting Spark Properties
There are two methods of setting Spark properties. The first method is by passing application properties via the
SparkConf object. As you know, the SparkConf variable is used to create the SparkContext object. In the example
shown on this slide, you set the master node as local, the appName as "CountingSheep", and you allow 1GB for each
of the executor processes.
The second method is to dynamically set the Spark properties. Spark allows you to pass in an empty SparkConf when
creating the SparkContext as shown on the slide.

You can then either supply the values during runtime by using the command line options --master or the --conf. You
can see the list of options using the --help when executing the spark-submit script.
On the slide here, you give the app name of My App and telling it to run on the local system with four cores. You set
the ``spark.shuffle.spill`` to false and the various java options at the end. Finally you supply the application JAR file after
all the properties have been specified.
You can find a list of all the properties on the spark.apache.org website.

Another way to set Spark properties is to provide your settings inside the ``spark-defaults.conf`` file. The spark-submit
script will read in the configurations from this file. You can view the Spark properties on the application web UI at the
port 4040 by default.
Properties set directly on the SparkConf take highest precedence, then flags passed to sparksubmit
or spark-shell is second and finally options in the spark-defaults.conf file is the lowest priority.

----------------------------------------------------------------------------------------------------
There are three ways to monitor Spark applications. The first way is the Web UI. The default port is 4040. The port in
the lab environment is 8088. The information on this UI is available for the duration of the application. If you want to
see the information after the fact, set the spark.eventLog.enabled to true before starting the application. The
information will then be persisted to storage as well.

Metrics is another way to monitor Spark applications. The metric system is based on the Coda Hale Metrics Library.
You can customize it so that it reports to a variety of sinks such as CSV. You can configure the metrics system in the
metrics.properties file under the conf directory.
Finally, you can also use external instrumentations to monitor Spark. Gangalia is used to view overall cluster
utilization and resource bottlenecks. Various OS profiling tools and JVM utilities can also be used for monitoring
Spark.

#### Web UI
The Web UI is found on port 4040, by default, and shows the information for the current application while it is
running.

* The Web UI contains the following information.
* A list of scheduler stages and tasks.
* A summary of RDD sizes and memory usage.
* Environmental information and information about the running executors.

To view the history of an application after it has ran, you can start up the history server. The history server can be
configured on the amount of memory allocated for it, the various JVM options, the public address for the server, and a
number of properties.

-----------------------------------------------------------------------------------------------
#### Serialization 

* Kyro Serialization 
* Java serialization

Spark programs can be bottlenecked by any resource in the cluster. Due to Spark’s nature of the in-memory
computations, data serialization and memory tuning are two areas that will improve performance. Data serialization is
crucial for network performance and to reduce memory use. It is often the first thing you should look at when tuning
Spark applications. Spark provides two serialization libraries. ***Java serialization*** provides a lot more flexibility, but it is
quiet slow and leads to large serialized objects. 

This is the default library that Spark uses to serialize objects. Kyro
serialization is much quicker than Java, but does not support all Serializable types. It would require you to register
these types in advance for best performance. To use Kyro serialization, you can set it using the SparkConf object.
With memory tuning, you have to consider three things. The amount of memory used by the objects (whether or not
you want the entire object to fit in memory). 

The cost of accessing those objects and the overhead garbage collection.
You can determine how much memory your dataset requires by creating a RDD, put it into cache, and look at the
SparkContext log on your driver program. Examining that log will show you how much memory your dataset uses.
Few tips to reduce the amount of memory used by each object. Try to avoid Java features that add overhead such as
pointer based data structures and wrapper objects. If possible go with arrays or primitive types and try to avoid nested
structures.

Serialized storage can also help to reduce memory usage. The downside would be that it will take longer to access the
object because you have to deserialized it before you can use it.
You can collect statistics on the garbage collection to see how frequently it occurs and the amount of time spent on it.
To do so, add the line to the SPARK_JAVA_OPTS environment variable.

### Parallelism
The level of parallelism should be considered in order to fully utilize your cluster. It is automatically set to the file size
of the task, but you can configure this through optional parameters such as in the ``SparkContext.textFile``. You can also
set the default level in the spark.default.parallelism config property. Generally, it is recommended to set 2-3 tasks per
CPU core in the cluster.

Sometimes when your RDD does not fit in memory, you will get an OutOfMemoryError. In cases like this, often by
increasing the level of parallelism will resolve this issue. By increasing the level, each set of task input will be smaller,
so it can fit in memory.

Using Spark’s capability to broadcast large variables greatly reduces the size of the serialized object. A good example
would be if you have some type of static lookup table. Consider turning that into a broadcast variable so it does not
need to be passed on to each of the worker nodes.

Spark prints the serialized size of each tasks in the master. Check that out to examine if any tasks are too large. If you
see some tasks larger than 20KB, it’s worth taking a look to see if you can optimize it further, such as creating
broadcast variables.

Having completed this lesson, you should be able to describe the cluster overview. You should also know where and
how to set Spark configuration properties. You also saw how to monitor Spark using the UI, metrics or various
external tools. Finally, you should understand some performance tuning considerations.

Next steps. Complete lab exercise #5 and then, congratulations, you have completed this course.
