Spark application Programming.
=====================================
Objectives:
After completing this lesson, you should be able to understand the purpose and usage of the SparkContext.This lesson
will show you how to can get started by programming your own Spark application. 

* First you will see how to link to Spark. 
* Next you will see how to run some Spark examples. You should also be able to understand how to pass
functions to Spark and be able to create and run a Spark standalone application. 
* Finally, you should be able to submit applications to the Spark cluster.

### The SparkContext
The SparkContext is the main entry point to everything Spark. It can be used to create RDDs and shared variables on
the cluster. When you start up the Spark Shell, the SparkContext is automatically initialized for you with the variable
sc. For a Spark application, you must first import some classes and implicit conversions and then create the
SparkContext object. The three import statements for Scala are shown on the slide here.

-----------------------------------------

Each Spark application you create requires certain dependencies. The next three slides will show you how to link to
those dependencies depending on which programming language you decide to use.
To link with Spark using Scala, you must have a compatible version of Scala with the Spark you choose to use. For
example, Spark 1.1.1 uses Scala 2.10, so make sure that you have Scala 2.10 if you wish to write applications for Spark
1.1.1.
To write a Spark application, you must add a Maven dependency on Spark. The information is shown on the slide
here. If you wish to access a Hadoop cluster, you need to add a dependency to that as well.
In the lab environment, this is already set up for you. The information on this page shows how you would set up for
your own Spark cluster.
Slide 5:
Spark 1.1.1 works with Python 2.6 or higher, but not Python 3. It uses the standard CPython interpreter, so C libraries
like NumPy can be used.
To run Spark applications in Python, use the bin/spark-submit script located in the Spark's home directory. This script
will load the Spark’s Java/Scala libraries and allow you to submit applications to a cluster. If you wish to use HDFS,
you will have to link to it as well. In the lab environment, you will not need to do this as Spark is bundled with it. You
also need to import some Spark classes shown here.

Spark 1.1.1 works with Java 6 and higher. If you are using Java 8, Spark supports lambda expressions for concisely
writing functions. Otherwise, you can use the org.apache.spark.api.java.function package with older Java versions.
As with Scala, you need to a dependency on Spark, which is available through Maven Central. If you wish to access an
HDFS cluster, you must add the dependency there as well. Last, but not least, you need to import some Spark classes.

Once you have the dependencies established, the first thing is to do in your Spark application before you can initialize
Spark is to build a SparkConf object. This object contains information about your application. 
<pre><code>
val conf = new SparkConf().setAppName(appName).setMaster(master).
</code></pre>
You set the application name and tell it which is the master node. The master parameter can be a standalone Spark
distribution, Mesos, or a YARN cluster URL. You can also decide to use the local keyword string to run it in local
mode. In fact, you can run local[16] to specify the number of cores to allocate for that particular job or Spark shell as
16.
For production mode, you would not want to hardcode the master path in your program. Instead, launch it as an
argument to the spark-submit command.

----------------------------------------------------------------------------------
Once you have the SparkConf all set up, you pass it as a parameter to the SparkContext constructor to create the
SparkContext
Here's the information for Python. It is pretty much the same information as Scala. The syntax here is slightly
different, otherwise, you are required to set up a SparkConf object to pass as a parameter to the SparkContext object.
You are also recommended to pass the master parameter as an argument to the spark-submit operation.

Here's the same information for Java. Same idea, you need to create the SparkConf object and pass that to the
SparkContext, which in this case, would be a JavaSparkContext. Remember, when you imported statements in the
program, you imported the JavaSparkContext libraries. 

----------------------------------------------------------------------------------------------
### Passing functions to Spark. 
The design of Spark’s API relies heavily on passing functions in the driver program to run on the cluster. When a job
is executed, the Spark driver needs to tell its worker how to process the data.

There are three methods that you can use to pass functions.
* The first method to do this is using an ***anonymous function*** syntax. You saw briefly what an anonymous function is in
the first lesson. This is useful for short pieces of code. For example, here we define the anonymous function that takes
in a particular parameter x of type Int and add one to it. Essentially, anonymous functions are useful for one-time use
of the function. In other words, you don't need to explicitly define the function to use it. You define it as you go.
Again, the left side of the => are the parameters or the arguments. The right side of the => is the body of the function.

* Another method to pass functions around Spark is to use static methods in a global singleton object. This means that
you can create a global object, in the example, it is the object MyFunctions. Inside that object, you basically define the
function func1. When the driver requires that function, it only needs to send out the object – the worker will be able to
access it. In this case, when the driver sends out the instructions to the worker, it just has to send out the singleton
object.
It is possible to pass reference to a method in a class instance, as opposed to a singleton object. This would require
sending the object that contains the class along with the method. To avoid this consider copying it to a local variable
within the function instead of accessing it externally.
Example, say you have a field with the string Hello. You want to avoid calling that directly inside a function as shown
on the slide as x => field + x.
Instead, assign it to a local variable so that only the reference is passed along and not the entire object shown val field_
= this.field.
For an example such as this, it may seem trivial, but imagine if the field object is not a simple text Hello, but is
something much larger, say a large log file. In that case, passing by reference will have greater value by saving a lot of
storage by not having to pass the entire file.

#### Link Dependencies
Back to our regularly scheduled program.
At this point, you should know how to link dependencies with Spark and also know how to initialize the SparkContext.
You can create an application using a simple, but effective example which demonstrates Spark's capabilities.

#### Creating A SparkContext object
Once you have the beginning of your application ready by creating the SparkContext object, you can start to program
in the business logic using Spark's API available in Scala, Java, or Python. You create the RDD from an external
dataset or from an existing RDD. You use transformations and actions to compute the business logic. You can take
advantage of RDD persistence, broadcast variables and/or accumulators to improve the performance of your jobs.

### Scala Application
Here's a sample Scala application. You have your import statement. After the beginning of the object, you see that the SparkConf is created with the application name. Then a SparkContext is created. The several lines of code after is
creating the RDD from a text file and then performing the Hdfs test on it to see how long the iteration through the file 
takes. Finally, at the end, you stop the SparkContext by calling the stop() function.
Again, just a simple example to show how you would create a Spark application. You will get to practice this in the
lab exercise.

#### Examples 

There are examples available which shows the various usage of Spark. Depending on your
programming language preference, there are examples in all three languages that work with Spark. You can view the
source code of the examples on the Spark website or within the Spark distribution itself. 

To run Scala or Java examples, you would execute the runexample script under the Spark's home/bin directory. So for example, to run the SparkPi application, execute ``runexample SparkPi``, where SparkPi would be the name of the application. Substitute that with a different application name to run that other application.

To run the sample Python applications, use the spark-submit command and provide the path to the application. 

-------------------------------------------------------------------------

In the next three slides, you will see another example of creating a Spark application. First you will see how to do this
in Scala. The next following sets of slides will show Python and Java.
The application shown here counts the number of lines with ‘a’ and the number of lines with ‘b’. You will need to
replace the YOUR_SPARK_HOME with the directory where Spark is installed, if you wish to code this application.

Unlike the Spark shell, you have to initialize the SparkContext in a program. First you must create a SparkConf to set
up your application’s name. Then you create the SparkContext by passing in the SparkConf object. Next, you create
the RDD by loading in the textFile, and then caching the RDD. Since we will be applying a couple of transformations
on it, caching will help speed up the process, especially if the logData RDD is large. Finally, you get the values of the
RDD by executing the count action on it. End the program by printing it out onto the console.

In Python, this application does the exact same thing, that is, count the number of lines with ‘a’ in it, and the number
of lines with ‘b’ in it. You use a SparkContext object to create the RDDs and cache it. Then you run the
transformations and actions, follow by a print to the console. Nothing entirely new here, just a difference in syntax.
#### JavaSparkContext
Similar to Scala and Python, in Java you need to get a JavaSparkContext. RDDs are represented by JavaRDD. Then
you run the transformations and actions on them. The lambda expressions of Java 8 allows you to concisely write
functions. Otherwise, you can use the classes in the org.apache.spark.api.java.function package for older versions of
java. The business logic is the same as the previous two examples to count the number of a's and b's from the Readme
file. Just a matter of difference in the syntax and library names.
Slide 16:
Up until this point, you should know how to create a Spark application using any of the supported programming
languages. Now you get to see how to run the application. You will need to first define the dependencies. Then you
have to package the application together using system build tools such as Ant, sbt, or Maven. The examples here show
how you would do it using the various tools. You can use any tool for any of the programming languages. For Scala,
the example is shown using sbt, so you would have a simple.sbt file. In Java, the example shows using Maven so you
would have the pom.xml file. In Python, if you need to have dependencies that requires third party libraries, then you
can use the –py-files argument to handle that.
Again, shown here are examples of what a typical directory structure would look like for the tool that you choose.
Finally, once you have the JAR packaged created, run the spark-submit to execute the application.
In the lab exercise, you will get to practice this.

In short, you package up your application into a JAR for Scala or Java or a set of .py or .zip files for Python.
To submit your application to the Spark cluster, you use spark-submit command, which is located under the
``$SPARK_HOME/bin`` directory.
The options shown on the slide are the commonly used options. To see other options, just invoke spark-submit with
the help argument. 

Let's briefly go over what each of these options mean.

* The class option is the main entry point to your class. If it is under a package name, you must provide the fully
qualified name. The master URL is where your cluster is located. Remember that it is recommended approach to
provide the master URL here, instead of hardcoding it in your application code.
* The ***deploy-mode*** is whether you want to deploy your driver on the worker nodes (cluster) or locally as an external
client (client). The default deploy-mode is client.
* The ***conf*** option is any configuration property you wish to set in key=value format.
The application jar is the file that you packaged up using one of the build tools.

Finally, if the application has any arguments, you would supply it after the jar file.
Here's an actual example of running a Spark application locally on 8 cores. The class is the
org.apache.spark.examples.SparkPi. local[8] is saying to run it locally on 8 cores. The examples.jar is located on the
given path with the argument 100 to be passed into the SparkPi application.

#### Summary
Having completed this lesson, you should now know how to create a standalone Spark application and run it by
submitting it to the Spark Cluster. You saw briefly on the different methods on how to pass functions in Spark. All
three programming languages were shown in this lesson.
