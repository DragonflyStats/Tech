Spark Action 
==============================
Unlike Transformations which produce RDDs, action functions produce a value back to the Spark driver program.  
Actions may trigger a previously constructed, lazy RDD to be evaluated.

* reduce
* collect
* count
* first
* take
* takeSample
* countByKey
* saveAsTextFile
