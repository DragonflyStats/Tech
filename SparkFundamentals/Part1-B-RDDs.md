Resilient Distributed Dataset (RDD)
=======================================

#### Objectives:
*  After completing this lesson, you should be able to understand and describe Spark's primary data abstraction, the RDD.
* You should know how to create parallelized collections from internal and external datasets. 
* You should be able to use RDD opeartions such as Transformations and Actions. 
* Finally, I will also show you how to take advantage of Spark's shared variables and key-value pairs.

----------------------------------------------------------------------------------------------

* Resilient Distributed Dataset (RDD) is Spark’s primary abstraction. 
* RDD is a fault tolerant collection of elements that can be parallelized. 
* In other words, they can be made to be operated on in parallel. They are also immutable. These are
the fundamental primary units of data in Spark.

### Direct Acyclic Graphs
When RDDs are created, a direct acyclic graph (DAG) is created. This type of operation is called transformations.
Transformations makes updates to that graph, but nothing actually happens until some action is called. Actions are
another type of operations. We'll talk more about this shortly. 

Graphs can be replayed on nodes that need to get back to the state it was before it went offline – thus providing fault tolerance. The elements of the RDD can be operated on in parallel across the cluster. Remember, transformations return a pointer to the RDD
created and actions return values that comes from the action.

### Methods for Creating RDDs
There are three methods for creating a RDD. 

* You can parallelize an existing collection. This means that the data
already resides within Spark and can now be operated on in parallel. As an example, if you have an array of data, you
can create a RDD out of it by calling the parallelized method. This method returns a pointer to the RDD. So this new
distributed dataset can now be operated upon in parallel throughout the cluster.

* The second method to create a RDD, is to reference a dataset. This dataset can come from any storage source
supported by Hadoop such as HDFS, Cassandra, HBase, Amazon S3, etc.

* The third method to create a RDD is from transforming an existing RDD to create a new RDD. In other words, let's
say you have the array of data that you parallelized earlier. Now you want to filter out strings that are shorter than 20
characters. A new RDD is created using the filter method.

A final point on this slide. Spark supports text files, SequenceFiles and any other Hadoop InputFormat.

---------------------------------------------------------------------------

Here is a quick example of how to create an RDD from an existing collection of data. In the examples throughout the
course, unless otherwise indicated, we’re going to be using Scala to show how Spark works. In the lab exercises, you
will get to work with Python and Java as well. So the first thing is to launch the Spark shell. This command is located
under the ``$SPARK_HOME/bin directory``. In the lab environment, ``SPARK_HOME`` is the path to where Spark was
installed.

### SparkContext
Once the shell is up, create some data with values from 1 to 10,000. Then, create an RDD from that data using the
parallelize method from the SparkContext, shown as sc on the slide. This means that the data can now be operated on
in parallel.

We will cover more on the SparkContext, the sc object that is invoking the parallelized function, in our programming
lesson, so for now, just know that when you initialize a shell, the SparkContext, sc, is initialized for you to use.

The parallelize method returns a pointer to the RDD. Remember, transformations operations such as parallelize, only
returns a pointer to the RDD. It actually won't create that RDD until some action is invoked on it. With this new RDD,
you can perform additional transformations or actions on it such as the filter transformation.

Another way to create a RDD is from an external dataset. In the example here, we are creating a RDD from a text file 
using the textFile method of the SparkContext object. You will see plenty more examples of how to create RDD
throughout this course.

---------------------------------------------------------------------------

Here we go over some basic operations. You have seen how to load a file from an external dataset. This time,
however, we are loading a file from the hdfs. Loading the file creates a RDD, which is only a pointer to the file. The
dataset is not loaded into memory yet. Nothing will happen until some action is called. The transformation basically
updates the direct acyclic graph (DAG).

So the transformation here is saying map each line s, to the length of that line. Then, the action operation is reducing it
to get the total length of all the lines. When the action is called, Spark goes through the DAG and applies all the
transformation up until that point, followed by the action and then a value is returned back to the caller.

A common example is a MapReduce word count. You first split up the file by words and then map each word into a
key value pair with the word as the key, and the value of 1. Then you reduce by the key, which adds up all the value of
the same key, effectively, counting the number of occurrences of that key. Finally, you call the ``collect()`` function,
which is an action, to have it print out all the words and its occurrences.
Again, you will get to work with this in the lab exercises.

--------------------------------------------------------------------------

#### More on DAGs

A DAG is essentially a graph of the business logic and does not get executed until an action is called
– often called lazy evaluation.

To view the DAG of a RDD after a series of transformation, use the ``toDebugString`` method as you see here on the
slide. It will display the series of transformation that Spark will go through once an action is called. You read it from
the bottom up. In the sample DAG shown on the slide, you can see that it starts as a textFile and goes through a series
of transformation such as map and filter, followed by more map operations. Remember, that it is this behavior that
allows for fault tolerance. If a node goes offline and comes back on, all it has to do is just grab a copy of this from a
neighboring node and rebuild the graph back to where it was before it went offline.


In the next several slides, you will see at a high level what happens when an action is executed.
Let’s look at the code first. The goal here is to analyze some log files. The first line you load the log from the hadoop
file system. The next two lines you filter out the messages within the log errors. Before you invoke some action on it,
you tell it to cache the filtered dataset – it doesn't actually cache it yet as nothing has been done up until this point.
Then you do more filters to get specific error messages relating to mysql and php followed by the count action to find
out how many errors were related to each of those filters.

Now let's walk through each of the steps. The first thing that happens when you load in the text file is the data is
partitioned into different blocks across the cluster.

Then the driver sends the code to be executed on each block. In the example, it would be the various transformations
and actions that will be sent out to the workers. Actually, it is the executor on each workers that is going to be
performing the work on each block. You will see a bit more on executors in a later lesson.

* Then the executors read the HDFS blocks to prepare the data for the operations in parallel.
* After a series of transformations, you want to cache the results up until that point into memory. A cache is created.
* After the first action completes, the results are sent back to the driver. In this case, we're looking for messages that
relate to mysql. This is then returned back to the driver.
* To process the second action, Spark will use the data on the cache -- it doesn’t need to go to the HDFS data again. It
just reads it from the cache and processes the data from there.
* Finally the results go back to the driver and we have completed a full cycle.

So a quick recap. This is a subset of some of the transformations available. The full list of them can be found on
Spark's website. 

Remember that Transformations are essentially lazy evaluations. Nothing is executed until an action is called. Each
transformation function basically updates the graph and when an action is called, the graph is executed.
Transformation returns a pointer to the new RDD.

#### The flatMap Function 
The flatMap function is similar to map, but each input can be mapped to 0 or more output items. What this means is
that the returned pointer of the func method, should return a sequence of objects, rather than a single item. It would
mean that the flatMap would flatten a list of lists for the operations that follows. Basically this would be used for
MapReduce operations where you might have a text file and each time a line is read in, you split that line up by spaces
to get individual keywords. Each of those lines ultimately is flatten so that you can perform the map operation on it to
map each keyword to the value of one.

#### The join Function
The join function combines two sets of key value pairs and return a set of keys to a pair of values from the two initial
set. For example, you have a K,V pair and a K,W pair. When you join them together, you will get a K, (V,W) set.

The reduceByKey function aggregates on each key by using the given reduce function. This is something you would
use in a WordCount to sum up the values for each word to count its occurrences.

--------------------------------------------------------------------------------------------

Action returns values. Again, you can find more information on Spark's website. This is just a subset.
The collect function returns all the elements of the dataset as an array of the driver program. This is usually useful
after a filter or another operation that returns a significantly small subset of data to make sure your filter function
works correctly.

The count function returns the number of elements in a dataset and can also be used to check and test transformations.

The take(n) function returns an array with the first n elements. Note that this is currently not executed in parallel. The
driver computes all the elements.
The foreach(func) function run a function func on each element of the dataset.

### RDD persistence
Now I want to get a bit into RDD persistence. You have seen this used already. That is the cache function. The cache
function is actually the default of the persist function with the ``MEMORY_ONLY`` storage.

One of the key capability of Spark is its speed through persisting or caching. Each node stores any partitions of the
cache and computes it in memory. When a subsequent action is called on the same dataset, or a derived dataset, it uses
it from memory instead of having to retrieve it again. Future actions in such cases are often 10 times faster. The first
time a RDD is persisted, it is kept in memory on the node. Caching is fault tolerant because if it any of the partition is
lost, it will automatically be recomputed using the transformations that originally created it.

#### ``persist()`` and ``cache()``
There are two methods to invoke RDD persistence. persist() and cache(). The persist() method allows you to specify a
different storage level of caching. For example, you can choose to persist the data set on disk, persist it in memory but
as serialized objects to save space, etc. Again the cache() method is just the default way of using persistence by storing
deserialized objects in memory.

The table here shows the storage levels and what it means. Basically, you can choose to store in memory or memory
and disk. If a partition does not fit in the specified cache location, then it will be recomputed on the fly. You can also
decide to serialized the objects before storing this. This is space efficient, but will require the RDD to deserialized
before it can be read, so it takes up more CPU workload. There’s also the option to replicate each partition on two
cluster nodes. Finally, there is an experimental storage level storing the serialized object in Tachyon. This level
reduces garbage collection overhead and allows the executors to be smaller and to share a pool of memory. You can
read more about this on Spark’s website.

A lot of text on this page, but don't worry. It can be used as a reference when you have to decide the type of storage
level.

There are tradeoffs between the different storage levels. You should analyze your current situation to decide which
level works best. You can find this information here on Spark’s website.

Basically if your RDD fits within the default storage level, by all means, use that.

It is the fastest option to fully take advantage of Spark’s design. If not, you can serialized the RDD and use the
``MEMORY_ONLY_SER`` level. Just be sure to choose a fast serialization library to make the objects more space
efficient and still reasonably fast to access.

Don’t spill to disk unless the functions that compute your datasets are expensive or it requires a large amount of space.
If you want fast recovery, use the replicated storage levels. All levels are fully fault tolerant, but would still require the
recomputing of the data. If you have a replicated copy, you can continue to work while Spark is reconstruction a lost
partition.

Finally, use Tachyon if your environment has high amounts of memory or multiple applications. It allows you to share
the same pool of memory and significantly reduces garbage collection costs. Also, the cached data is not lost if the
individual executors crash.

On these last two slides, I'll talk about Spark's shared variables and the type of operations you can do on key-value
pairs.
Spark provides two limited types of shared variables for common usage patterns: broadcast variables and
accumulators. Normally, when a function is passed from the driver to a worker, a separate copy of the variables are 
used for each worker. Broadcast variables allow each machine to work with a read-only variable cached on each
machine. Spark attempts to distribute broadcast variables using efficient algorithms. As an example, broadcast
variables can be used to give every node a copy of a large dataset efficiently.
The other shared variables are accumulators. These are used for counters in sums that works well in parallel. These
variables can only be added through an associated operation. Only the driver can read the accumulators value, not the
tasks. The tasks can only add to it. Spark supports numeric types but programmers can add support for new types. As
an example, you can use accumulator variables to implement counters or sums, as in MapReduce.
Last, but not least, key-value pairs are available in Scala, Python and Java. In Scala, you create a key-value pair RDD
by typing val pair = (‘a’, ‘b’). To access each element, invoke the ._ notation. This is not zero-index, so the ._1 will
return the value in the first index and ._2 will return the value in the second index. Java is also very similar to Scala
where it is not zero-index. You create the Tuple2 object in Java to create a key-value pair. In Python, it is a zeroindex
notation, so the value of the first index resides in index 0 and the second index is 1.

There are special operations available to RDDs of key-value pairs. In an application, you must remember to import the
SparkContext package to use PairRDDFunctions such as reduceByKey.
The most common ones are those that perform grouping or aggregating by a key. RDDs containing the Tuple2 object
represents the key-value pairs. Tuple2 objects are simply created by writing (a, b) as long as you import the library to
enable Spark’s implicit conversion.

If you have custom objects as the key inside your key-value pair, remember that you will need to provide your own
equals() method to do the comparison as well as a matching hashCode() method.
So in the example, you have a textFile that is just a normal RDD. Then you perform some transformations on it and it
creates a PairRDD which allows it to invoke the reduceByKey method that is part of the PairRDDFunctions API.

In the first
reduceByKey example with the a,b => a + b. This simply means that for the values of the same key, add them up
together. In the example on the bottom of the slide, reduceByKey(_+_) uses the shorthand for anonymous function
taking two parameters (a and b in our case) and adding them together, or multiplying, or any other operations for that
matter.

Another thing I want to point is that for the goal of brevity, all the functions are concatenated on one line. When you
actually code it yourself, you may want split each of the functions up. For example, do the flatMap operation and
return that to a RDD. Then from that RDD, do the map operation to create another RDD. Then finally, from that last
RDD, invoke the reduceByKey method. That would yield multiple lines, but you would be able to test each of the
transformation to see if it worked properly.

So having completed this lesson, you should now be able to describe pretty well, RDDs. You should also understand
how to create RDDs using various methods including from existing datasets, external datasets such as a textFile or
from HDFS, or even just from existing RDDs. You saw various RDD operations and saw how to work with shared
variables and key-value pairs.

Next steps. Complete lab exercise #2 Working with RDD operations. Then proceed to the next lesson in this course.
