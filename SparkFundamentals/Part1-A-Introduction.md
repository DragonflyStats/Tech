Introduction to Spark.
================================
Objectives:
After completing this lesson, you should be able to explain the purpose of Spark and understand why and when you
would use Spark. You should be able to list and describe the components of the Spark unified stack. You will be able
to understand the basics of the Resilent Distributed Dataset, Spark's primary data abstraction. Then you will see how to
download and install Spark standalone to test it out yourself. You will get an overview of Scala and Python to prepare
for using the two Spark shells.

-------------------------------------------------------------------------------
There is an explosion of data. No matter where you look, data is everywhere. You get data from social media such as
Twitter feeds, Facebook posts, SMS, and a variety of others. The need to be able to process those data as quickly as
possible becomes more important than ever. How can you find out what your customers want and be able to offer it to
them right away? You do not want to wait hours for a batch job to complete. You need to have it in minutes or less.
MapReduce has been useful, but the amount of time it takes for the jobs to run is no longer acceptable in most
situations. The learning curve to writing a MapReduce job is also difficult as it takes specific programming knowledge
and the know-how. Also, MapReduce jobs only work for a specific set of use cases. You need something that works
for a wider set of use cases.

Apache Spark was designed as a computing platform to be fast, general-purpose, and easy to use. It extends the
MapReduce model and takes it to a whole other level.

The speed comes from the in-memory computations. Applications running in memory allows for a much faster
processing and response. Spark is even faster than MapReduce for complex applications on disks.

This generality covers a wide range of workloads under one system. You can run batch application such as
MapReduce types jobs or iterative algorithms that builds upon each other. You can also run interactive queries and
process streaming data with your application. In a later slide, you’ll see that there are a number of libraries which you
can easily use to expand beyond the basic Spark capabilities.

The ease of use with Spark enables you to quickly pick it up using simple APIs for Scala, Python and Java. As
mentioned, there are additional libraries which you can use for SQL, machine learning, streaming, and graph
processing. Spark runs on Hadoop clusters such as Hadoop YARN or Apache Mesos, or even as a standalone with its
own scheduler.

### Spark and MapReduce
Spark is related to MapReduce in a sense that it expands on its capabilities.
Like MapReduce, Spark provides parallel distributed processing, fault tolerance on commodity hardware, scalability,
etc. Spark adds to the concept with aggressively cached in-memory distributed computing, low latency, high level
APIs and stack of high level tools described on the next slide. This saves time and money.

### Data Scientists and Data Engineers

Data scientist are those who need to analyze and model the data to obtain insight. They would have techniques to transform
the data into something they can use for data analysis. They will use Spark for its ad-hoc analysis to run interactive
queries that will give them results immediately. Data scientists may also have experience using SQL, statistics,
machine learning and some programming, usually in Python, MatLab or R. 

Once the data scientists have obtained insights on the data and later someone determines that there’s a need develop a production data processing application, a web application, or some system to act upon the insight, the person called upon to work on it would be the engineers. Engineers would use Spark’s programming API to develop a system that implement business use cases. Spark
parallelize these applications across the clusters while hiding the complexities of distributed systems programming and
fault tolerance. Engineers can use Spark to monitor, inspect and tune applications.

For everyone else, Spark is easy to use with a wide range of functionality. The product is mature and reliable.

-------------------------------------------------------------------------------

### The Spark unified stack. 

* The ***Spark core*** is at the center of it all. The Spark core is a general-purpose system providing scheduling, distributing, and monitoring of the applications across a cluster. Then you have the components on top of the core that are designed to interoperate closely, letting the users
combine them, just like they would any libraries in a software project. The benefit of such a stack is that all the higher
layer components will inherit the improvements made at the lower layers. 

Example: Optimization to the Spark Core
will speed up the SQL, the streaming, the machine learning and the graph processing libraries as well. The Spark core
is designed to scale up from one to thousands of nodes. It can run over a variety of cluster managers including Hadoop
YARN and Apache Mesos. Or simply, it can even run as a standalone with its own built-in scheduler.


* ***Spark SQL*** is designed to work with the Spark via SQL and HiveQL (a Hive variant of SQL). Spark SQL allows
developers to intermix SQL with Spark’s programming language supported by Python, Scala, and Java.

* ***Spark Streaming*** provides processing of live streams of data. The Spark Streaming API closely matches that of the
Sparks Core’s API, making it easy for developers to move between applications that processes data stored in memory
vs arriving in real-time. It also provides the same degree of fault tolerance, throughput, and scalability that the Spark
Core provides.

* ***Machine learning, MLlib*** is the machine learning library that provides multiple types of machine learning algorithms.
All of these algorithms are designed to scale out across the cluster as well.

* ***GraphX*** is a graph processing library with APIs to manipulate graphs and performing graph-parallel computations.

-----------------------------------------------------------------------------

### A Brief History of Spark. 

MapReduce started out over a decade ago. MapReduce
was designed as a fault tolerant framework that ran on commodity systems. Spark comes out about a decade later with
the similar framework to run data processing on commodity systems also using a fault tolerant framework. MapReduce
started off as a general batch processing system, but there are two major limitations. 
1) Difficulty in programming directly in MR and 
2) Batch jobs do not fit many use cases. 

So this spawned specialized systems to handle other use
cases. When you try to combine these third party systems in your applications, there are a lot of overhead.
Taking a looking at the code size of some applications on the graph on this slide, you can see that Spark requires a
considerable amount less. Even with Spark’s libraries, it only adds a small amount of code due to how tightly
everything is integrated with very little overhead. There is great value to be able to express a wide variety of use cases
with few lines of code.

-----------------------------------------------------------------------------


Now let’s get into the core of Spark. Spark’s primary core abstraction is called Resilient Distributed Dataset or RDD.
Essentially it is just a distributed collection of elements that is parallelized across the cluster. You can have two types
of RDD operations. Transformations and Actions. Transformations are those that do not return a value. In fact, nothing
is evaluated during the definition of these transformation statements. Spark just creates these Direct Acyclic Graphs or
DAG, which will only be evaluated at runtime. We call this lazy evaluation.
The fault tolerance aspect of RDDs allows Spark to reconstruct the transformations used to build the lineage to get
back the lost data.
Actions are when the transformations get evaluted along with the action that is called for that RDD. Actions return
values. For example, you can do a count on a RDD, to get the number of elements within and that value is returned.
So you have an image of a base RDD shown here on the slide. The first step is loading the dataset from Hadoop. Then
uou apply successive transformations on it such as filter, map, or reduce. Nothing actually happens until an action is 
called. The DAG is just updated each time until an action is called. This provides fault tolerance. For example, let’s
say a node goes offline. All it needs to do when it comes back online is to re-evaluate the graph to where it left off.
Caching is provided with Spark to enable the processing to happen in memory. If it does not fit in memory, it will spill
to disk.

-----------------------------------------------------------------------------
### Running Spark
Spark runs on Windows or Unix-like systems. The lab exercises that are part of this course will be running with IBM
BigInsights. The information on this slide shows you how you can install the standalone version yourself with all the
default values that come along with it.

To install Spark, simply download the pre-built version of Spark and place a compiled version of Spark on each node
of your cluster. Then you can manually start the cluster by executing ./sbin/start-master.sh . In the lab, the start script is
different, and you will see this in the lab exercise guide.
Again, the default URL to the master UI is on port 8080. The lab exercise environment will be different and you will
see this in the guide as well.


-----------------------------------------------------------------------------

Spark jobs can be written in Scala, Python or Java. Spark shells are available for Scala or Python. This course will not
teach how to program in each specific language, but will cover how to use them within the context of Spark. It is
recommended that you have at least some programming background to understand how to code in any of these.
-----------------------------------------------------------------------------

If you are setting up the Spark cluster yourself, you will have to make sure that you have a compatible version of the
programming language you choose to use. This information can be found on Spark’s website. In the lab environment,
everything has been set up for you – all you do is launch up the shell and you are ready to go.
Spark itself is written in the Scala language, so it is natural to use Scala to write Spark applications. This course will
cover code examples from by Scala, Python, and Java. Java 8 actually supports the functional programming style to
include lambdas, which concisely captures the functionality that are executed by the Spark engine. This bridges the
gap between Java and Scala for developing applications on Spark. Java 6 and 7 is supported, but would require more
work and an additional library to get the same amount of functionality as you would using Scala or Python.

-----------------------------------------------------------------------------

Here we have a brief overview of Scala. Everything in Scala is an object. The primitive types that is defined by Java
such as int or boolean are objects in Scala. Functions are objects in Scala and will play an important role in how
applications are written for Spark.
Numbers are objects. This means that in an expression that you see here: 1 + 2 * 3 / 4 actually means that the
individual numbers invoke the various identifiers +,-,*,/ with the other numbers passed in as arguments using the dot
notation.
Functions are objects. You can pass functions as arguments into another function. You can store them as variables.
You can return them from other functions. The function declaration is the function name followed by the list of
parameters and then the return type.
This slide and the next is just to serve as a very brief overview of Scala. If you wish to learn more about Scala, check
out its website for tutorials and guide. 

-----------------------------------------------------------------------------

### Anonymous Functions
Anonymous functions are very common in Spark applications. Essentially, if the function you need is only going to be
required once, there is really no value in naming it. Just use it anonymously on the go and forget about it. For example,
suppose you have a timeFlies function and it in, you just print a statement to the console. In another function,
oncePerSecond, you need to call this timeFlies function. 

Without anonymous functions, you would code it like the top 
example be defining the timeFlies function. Using the anonymous function capability, you just provide the function
with arguments, the right arrow, and the body of the function after the right arrow as in the bottom example. Because
this is the only place you will be using this function, you do not need to name the function.

-----------------------------------------------------------------------------

### The Spark Shell
The Spark shell provides a simple way to learn Spark’s API. It is also a powerful tool to analyze data interactively. The
Shell is available in either Scala, which runs on the Java VM, or Python. To start up Scala, execute the command
spark-shell from within the Spark’s bin directory. To create a RDD from a text file, invoke the textFile method with
the sc object, which is the SparkContext. We’ll talk more about these functions in a later lesson.

To start up the shell for Python, you would execute the pyspark command from the same bin directory. Then, invoking
the textFile command will also create a RDD for that text file.

In the lab exercise, you will start up either of the shells and run a series of RDD transformations and actions to get a
feel of how to work with Spark. In a later lesson and exercise, you will get to dive deeper into RDDs.

-----------------------------------------------------------------------------
### Summary
Having completed this lesson, you should now understand what Spark is all about and why you would want to use it.
You should be able to list and describe the components in the Spark stack as well as understand the basics of Spark's
primary abstraction, the RDDs. You also saw how to download and install Spark's standalone if you wish to, or you
can use the provided lab environment. You got a brief overview of Scala and saw how to launch and use the two Spark
Shells.

