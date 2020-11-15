Lesson Two: RDD Architecture
This course was developed in collaboration with MetiStream and IBM Analytics.
Lesson Objectives
After completing this lesson, you should be able to:
 Understand how Spark generates RDDs
 Manage partitions to improve RDD performance
 Understand what makes an RDD resilient
 Understand how RDDs are broken into jobs and stages
 Serialize tasks
RDD Review
By now you should be familiar with the Resilient Distributed Dataset, the fundamental data abstraction
in Spark. An RDD is made up of multiple partitions. Spark normally determines the number of partitions
based on the number of CPUs in your cluster. Each partition has a sequence of records which tasks will
execute on. The partitioning is what enables parallel execution of Spark jobs.
Recall that an RDD is part of a graph, sometimes referred to as a lineage, which traces its history.
How an RDD is Generated
Spark uses standard Hadoop APIs for input. Because of that, it’s able to read from many different data
stores in addition to HDFS, including the local file system and cloud services like Cloudant, AWS, Google,
and Azure.
Any InputFormat implementation can also be used directly by the hadoopFile API for connecting with
HBase, MongoDB, Cassandra, and more.
You can also implement your own custom InputFormats if necessary.
The partitions in the RDD map to the Hadoop splits as defined by the InputFormat.
This lets Spark take advantage of data locality when the Spark nodes are deployed on the Hadoop Data
Nodes.
You can also specify a minimum partitioning if necessary.
Partitioning correlates to the parallelism of tasks since each task executes on a single partition of data. A
key element of performance is balancing partitions with the number of cores on your cluster.
Example RDD from text file
Here is an example of using the built-in textFile API. This is just a convenience function that calls the
hadoopFile API, the same way you would read a text file in a MapReduce program. The textFile API
simply calls the map function to discards the keys and extract just the Text value from each record (line
of text) in the file.
If we look at the graph of the full RDD you can see that the root is a HadoopRDD, then a MappedRDD.
As we know, each RDD in a graph has a reference to its dependencies, up to the root RDD, which
depends on nothing. It’s important to know how this affects partitioning. The root RDD describes the
original partitioning. These partitions are inherited by the child RDDs. The transformations of each RDD,
such as in the example above, are executed on each partition of the parent RDD. However, we will soon
see situations where a repartitioning occurs.
Partitioning Considerations
Partitioning can have a huge impact on performance in Spark. There are several factors to be consider
that we will cover in this lesson.
You want your data to be evenly distributed across partitions to leverage parallelism and reduce the
chance of having a job that takes much longer than the others, causing a bottleneck.
On systems like Hadoop and Cassandra, it’s crucial that their cores line up logically with partitions. You
don’t want a partition divided between two cores on separate machines, for example.
The number of partitions should correlate to the number of CPU cores in your cluster.
Tasks that take a very long time to complete might suggest a different partitioning is in order.
You always want to avoid shuffling, that is, the movement of data between partitions caused by certain
operations. Shuffling is very expensive performance wise and can even lead to out-of-memory errors.
The big takeaway here is that there are many considerations and tradeoffs when designing your cluster.
It ultimately depends on your data and the type of operations you’ll be doing on it.
Partitioning example
Imagine that you have 4 partitions, with 1000 records each, on a cluster with three cores. Each task
takes one hour to complete. Only three partitions can be run the task at once, so it would take two
hours to complete all of them, and for half that time only one core is active.
Now repartition to three partitions. Each task will take longer, since there are more records per
partitions, but they can all run in parallel. The job finishes after only 80 minutes.
Factors to partitioning
By default, partitions and the records within them are distributed based on the original storage system’s
InputFormat. For example, in Hadoop the partitions correspond with HDFS cores.
RDD operations such as filter and map don’t alter partitioning. 
However in some cases you may want to force an increase or decrease in partitions.
Repartition will cause a shuffle and redistribute partitions evenly. Repartition can be helpful to
rebalance after filtering or reducing records and to increase parallelism if the input splits are too low for
your cluster. Coalesce can decrease partitions WITHOUT incurring a shuffle. Coalesce is useful when you
want to consolidate partitions before outputting to HDFS or external systems, but you lose parallelism.
Partitioners for key/value RDDs
When we key an RDD, either by a map or using keyBy, we’re not changing the partitioning. All we’ve
done is mapped each value to have a key. Those keys may or may not be co-located and we have no way
of knowing since typically an RDD will not have a partitioner when it’s first generated. However, for
certain keyed operations or iterative processing it’s beneficial to keep records with the same keys colocated.
This lets our transformations run quickly within the same JVM when operating over the same
keys. In order to do that we can use either a HashPartitioner or RangePartitioner.
In the case of HashPartitioner we specify the number of partitions and it will ensure that all keys with
the same hash will be in the same partition. This does NOT mean each key will have its own partition.
This is called consistent hashing, where the key hash modulo the number of partitions defines the
partition in which the record will be placed. Calling partitionBy will incur a shuffle but downstream
operations will benefit from the co-located records.
partitionBy Example
Consider an RDD with 3 partitions and no partitioner. The keys are not co-located. If we plan on doing
keyed operations we'd be better off repartitioning so that all values for the same key are in the same
partition. Simply call partitionby with a hash partitioner with the desired number of partitions. A shuffle
will occur, but further keyed operations will be more efficient.
Join Partitioning
Joining RDDs that have no partitioner will cause each executor to shuffle all values with the same key to
a single machine, for both RDDs. If you’re repeatedly joining on the same RDD this is highly inefficient.
The resulting RDD will use a HashPartitioner with the number of partitions equal to the largest RDD.
If you need to join an RDD multiple times, a better option is to partition it. In this case, only the “right”
RDD will get shuffled across the network to the corresponding partition from the “left” rdd.
The best case scenario is that left and right RDDs are “co-partitioned” so they have similar keys and the
same partitioner and same number of partitions. While a shuffle will still occur, if the partitions of
different RDDs are on the same executor they won’t cross the network. In general this will generate the
least amount of network I/O and latency.
Resilience
RDD’s describe a lineage of transformations that are lazily executed. As we’ve seen, each RDD depends
on the parent. It describes some transformation to run over each partition of the parent RDD.
Keeping this lineage allows us to reconstruct the results in the event of a failure. So if a partition is lost in
an executor Spark only needs to recompute those lost partitions by walking up the lineage tree until it
either reaches a root or persisted RDD.
As an example, let's say we have two RDD's that are joined together.
We then persist the RDD to memory.
During the next operations, a reduceByKey and saveAsTextFile, a failure occurs and one of the partitions
is lost.
Spark is able to walk the RDD lineage until it finds the last known good state.
Then it can recompute the lost partition. Note that is doesn't have to recompute every partition, just the
one that was lost.
Executing Jobs
Spark actions can be thought of in three stages. A Job is a sequence of transformations initiated by an
action, like collect, reduce, etc.
Jobs are broken down into stages, which in turn consist of tasks.
The scheduler analyzes the whole RDD lineage and determines how to break the job into stages and
tasks.
Stage boundaries are defined by shuffle dependencies, i.e., when a join, repartition or other operation
that causes a shuffle occurs. Transformations that cause a shuffle are also called wide dependencies.
Tasks are then serialized and distributed to the executors.
Tasks
Tasks are the operations we’ve defined in our Driver program for that RDD. The closures (AKA lambdas)
we wrote in our code will get serialized then deployed to each executor with the partition on which that
task must execute.
The important thing to remember here is the fact that the tasks must be serializable since they have to
get sent over the network to the worker nodes. This includes the tasks themselves as well as any
references they make to objects and variables within the Driver.
You have to be careful that your tasks aren’t too large, for instance with large local variables (such as
collections or maps). There are multiple costs associated with large tasks.
The first is serialization and de-serialization cost. Also there is the network I/O for sending those tasks
each time that transformation is executed. Finally large tasks may delay task launch times. 
Troubleshooting Task not Serializeable
Some common errors you may get, especially as you create more complex applications using 3rd-party
libraries, are “task not serializable” errors. These typically crop up on complex tasks referencing member
variables of the class defining the closures.
In this example we have a very basic helper class that doesn’t really do much. We reference it in a map
operation. If we try to run an action on the output RDD we’d get an error.
The problem is that “MyHelper” doesn’t implement Serializable. So if we extend our class with
Serializable and try to run it again it will work properly.
What if “MyHelper” in turn is also referencing another 3rd party library as a member variable which is
not serializable? We may not want (or be able to) change the code to make it serializable. Also, because
of the cost of sending large objects as part of our closure it would be better not to serialize the whole
object graph.
What other option do we have?
If we mark the member variable transient and lazy, it will not get serialized but will still be instantiated
locally within each task and our code will run as expected, without incurring the cost of serializing a
large task or lots of code changes.
Here we have another example, this time of a full Scala app. We have a local class “MyOtherHelper”
used in a map operation. In its current form this example will fail, even though the helper class is
serializable. Why?
Because “helper1” is a member variable of MySparkApp, and so Spark tries to serialize that instance as
well.
We just could make MySparkApp serializable, but is it really a good idea to ship our whole app to every
worker?
A better option is to make a local reference to “helper1”. This way we’re keeping our task as slim as
possible and minimizing serialization issues over large object graphs.
Identifying Stages
As we discussed earlier, stages are defined by shuffle dependencies.
Here we have a graph of 2 RDDs being joined, then a reduceByKey, and finally a saveAsTextFile.
Here is the RDD lineage from calling to debug string. The debug string clearly highlights the stage
boundaries. Stage one and two are the original RDDs being filtered, mapped and keyed in preparation
for the join. The join requires a shuffle, so there is a stage boundary there. The third stage is the reduce
and save after the join.
Handling Stragglers and Failures
Spark has a featured called speculative execution for handling slow tasks.
As stages are running slow tasks will be re-launched as necessary.
Speculative execution is disabled by default. We can enable it by setting the spark.speculation
parameter to true.
“Slow” is a configurable value set by spark.speculation.multiplier. This defines how many times slower a
task is than the median to be considered for speculation.
We also need a way to handle failing tasks. Tasks could fail either due to memory issues, underlying
hardware issues, networking problems, etc.
By default Spark will retry a task 3 times before failing a stage, which can be changed with the
spark.task.maxFailures parameter as needed.
For example you may want to fail fast versus running a long task multiple times to find out there’s an
issue on your cluster.
An important issue to be aware of is any operation that has side-effects, such as outputting data in a
foreach* call.
If our task fails and gets re-run it may very well try to output that data again.
If you’re using custom code to write out to another system be aware that you may need to ensure the
operation is idempotent.
Concurrent Jobs
Most of what we’ve looked at so far as been a single-user working in the Spark shell or a single app
being submitted working on a single task. By default, Spark uses a basic FIFO scheduler. It works well for
single-user apps where each job gets as many resources it needs.
The SparkContext is fully thread-safe so within a Spark app we can actually submit jobs from multiple
threads. If multiple jobs are submitted concurrently they could run in parallel if the first job doesn’t
need all the cluster resources. However, if that’s not the case you may have a single large job that backs
up all other requests until it’s finished.

For multi-user environments such as Zeppelin, you'll want to use the Fair scheduler, which can be set
with the spark.schedule.mode parameter. By default the fair scheduler divvies up the cluster resources
in a round-robin fashion, giving equal shares of resources. So even if you have a very large job it won’t
stop a small, short, job from starting and running.
We can also define pools, that have custom attributes such as weights and minimum shares of the the
cluster resources. Pools can have their own scheduler.
Pools are useful for defining priority queues (like for a certain user or group) or by giving each user a
pool which is internally a just a FIFO queue. This is the model Zeppelin uses to allow multiple users to
work on the Spark cluster at the same time.
#### Using Pools
Configuring custom Fair Scheduler pools involves first defining an XML file with the pools and their
config properties. Then in your Spark app, or config settings, you need to set the
spark.scheduler.allocation.file setting, pointing to that XML file.
Submitting a job for a specific pool is done by setting a local property on the SparkContext,
spark.scheduler.pool. This is a thread local property so if you spawn multiple threads on your driver each
will have to set this value. To clear the value, just set it to null.
####Lesson Summary
Having completed this lesson, you should be able to:
 Understand how Spark generates RDDs
 Manage partitions to improve RDD performance
 Understand what makes an RDD resilient
 Understand how RDDs are broken into jobs and stages
 Serialize tasks
Proceed to exercise 2 and the next lesson.
