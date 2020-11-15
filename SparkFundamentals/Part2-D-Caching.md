Caching and Serialization
==============================================
This course was developed in collaboration with MetiStream and IBM Analytics.

#### Persistence

Spark is very well suited to iterative analysis because of how it distributes and executes tasks across the
cluster and the fact that it minimizes disk I/O compared to frameworks such as MapReduce. However,
sometimes we may need some additional performance gains while dealing with the same RDD over
numerous iterations. What Spark is most known for is its use of memory caching. It’s important to
understand when and how we should persist RDDs. Persistence doesn’t necessarily have to be inmemory
only. We can use a combination if we know the data is too large to fit in memory or we could
choose to save entirely to disk if we’re more concerned with losing results of an expensive operation.

Persisting to disk would allow us to reconstitute the RDD from disk in the event a partition is lost,
instead of re-computing all the expensive operations for the lost partitions.
Ideally you want to persist after any pruning, filtering, and other transformations needed for
downstream processing. An example is loading a file, parsing it, and partitioning it by a key. It wouldn’t
do much good to simply cache the root RDD if we would have to incur the filter, map, and shuffle again
each time we re-use that RDD. Instead, we’d be better off caching after the partitionBy.
When you no longer need the persisted RDD simply call unpersist. Spark will also use a Least Recently
Used (LRU) algorithm as needed to make room for new RDDs.

#### Where to Persist
In this RDD lineage we’re joining 2 RDDs, one which is filtered. Then we have two branching operations:
a reduceByKey and a mapValues.
It would be a good idea to persist after the join, when the RDD is prepped and ready for the reduce and
map actions downstream.
#### Storage Levels
These are the different storage levels available, from the apache Spark programming guide.
MEMORY_ONLY is the default. You can call the shorthand cache() function to persist with the default.
Note how the different levels handle overflow. With memory only, if the whole RDD can't fit in memory,
some of the partitions will have to be recomputed one the fly. The DISK options write the overflow to
disk instead.
You can also replicate persisted partitions, or store them in Tachyon - a way to "share" RDDs that we will
talk about shortly.
#### Storage Cost
While persisting RDDs might help us save time re-computing partitions it does come at a cost. That is the
space it takes to keep all those objects in memory. Keeping records in memory in a raw state takes the
most space.
To help save on space we can serialize. The records of an RDD will be stored as one large byte array.
You’ll incur some CPU usage to deserialize the data. However it has the added benefit of helping with
garbage collection as you’ll be storing 1 object (the byte array) versus many small objects for each
record.

The default serializer is the Java serializer, or pickle if you’re using python.
Another option for Java and Scala users is the Kryo serializer, which is more efficient at the cost of some
potential compatibility or configuration issues.

You can also compress serialized in-memory RDDs at the cost of decompressing
As a rule of thumb optimize storage by using primitive types instead of Java or Scala collections. Also try
to avoid nested classes with many small objects as that will incur large garbage collection overhead.

#### Storage Level Comparison
Here’s an example of the trips and stations RDDs you’ve been working with in the labs, cached both with
and without serialization. While the uncompressed input file was roughly 36MB, the persisted dataset is
much larger because of the size of the Java objects in memory. In contrast the serialized version, using
the default Java serializer, only uses 52MB of space.
The Kryo serializer actually manages to store the entire RDD in less space than the original file!
#### Using Kryo
Kryo is usually very straightforward to set up. Here we see how to set up Kryo for the lab exercises.
First you create a new SparkConf configuration for the app. Then you set the spark.serializer parameter
to KryoSerializer. You must then register the classes in your application that will be serialized, in this
case, the Trip and Station classes.
Finally you initialize spark context with the configuration.
Now when you use a persist level such as MEMORY_ONLY_SER the serialization will be handled by kryo.

#### Sharing RDDs
One common question when people first start working with Spark is if RDDs can be shared across
applications. Since RDDs are tied to a SparkContext this is not conventially possible. Cue the Tachyon
project, a high-speed memory-based Distributed File System that comes with Spark. You can use
Tachyon to save and read RDDs across SparkContexts in a very efficient manner. The experimental
OFF_HEAP storage level can also be used to persist RDDs just as you would on disk or in RAM of the
Spark cluster.

#### Memory Configuration
There are some key configuration parameters you should be familiar with.
Spark.rdd.compress decides whether or not serialized RDDs should also be compress.
spark.shuffle.consolidateFiles consolidates the intermediate files generated during a shuffle, creating
fewer larger files rather than many small ones potentially improving disk I/O. Docs suggest setting this to
true on ext4 or xfs filesystems. On ext3 this might degrade performance on machines with more than 8
cores.

* spark.shuffle.spill limits the amount of memory used during reduces by spilling data out to disk. The
spilling threshold is specified by spark.shuffle.memoryFraction. You can also set whether or not the spill
will be compressed.
* spark.storage.memoryFraction is how much storage can be dedicated to in-memory persistence.
* spark.storage.unrollFraction is memory dedicated to “unrolling” serialized data such as persisted RDDs
since they’re stored as one large byte-array.

#### Lesson Summary
Having completed this lesson, you should be able to:
 Understand how and when to cache RDDs
 Understand storage levels and their uses
 Optimize memory usage with serialization options
 Share RDDs with Tachyon
Proceed to exercise 4 and the next lesson.
