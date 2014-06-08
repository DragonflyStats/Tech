Apache Spark
================
*(www.Stats-Lab.com)*

- Apache Spark is an open-source  data analytics cluster computing framework originally developed in the AMPLab at UC Berkeley. 
- Spark fits into the Hadoop open-source community, building on top of the Hadoop Distributed File System (HDFS)

<hr>
#### Features

Spark has a number of features that make it a compelling crossover platform for investigative as well as operational analytics:

- Spark comes with a machine-learning library, MLlib, albeit bare bones so far.
- Being Scala-based, Spark embeds in any JVM-based operational system, but can also be used interactively in a REPL in a way that will feel familiar to R and Python users.
- For Java programmers, Scala still presents a learning curve. But at least, any Java library can be used from within Scala.
- Spark’s RDD (Resilient Distributed Dataset) abstraction resembles Crunch’s PCollection, which has proved a useful abstraction in Hadoop that will already be familiar to Crunch developers. (Crunch can even be used on top of Spark.)
- Spark imitates Scala’s collections API and functional style, which is a boon to Java and Scala developers, but also somewhat familiar to developers coming from Python. Scala is also a compelling choice for statistical computing.
- Spark itself, and Scala underneath it, are not specific to machine learning. They provide APIs supporting related tasks, like data access, ETL, and integration. As with Python, the entire data science pipeline can be implemented within this paradigm, not just the model fitting and analysis.
- Code that is implemented in the REPL environment can be used mostly as-is in an operational context.
- Data operations are transparently distributed across the cluster, even as you type.
- 
