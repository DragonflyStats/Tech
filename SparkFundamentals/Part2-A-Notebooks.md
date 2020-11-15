Lesson One: Introduction
This course was developed in collaboration with MetiStream and IBM analytics.
Lesson Objectives
This lesson is just a quick primer on data notebooks to get you ready for the lab exercises.
After completing this lesson you should be able to:
 Use Zeppelin in your Spark projects
 Identify the various notebooks you can use with Spark
Apache Zeppelin
Apache Zeppelin is an interactive data analytics tool started by NFLabs. With Zeppelin you can run code
and create visualizations through a web interface. You can plug in virtually any programming language
or data processing backend.
Zeppelin comes configured with Scala and Spark, as well as markdown, Spark SQL, and shell.
You can visit the project homepage for more information.
Jupyter / IPython
Jupyter is an evolution of IPython, a mature python-based notebook. IPython is still the Python kernel,
but Jupyter also supports other languages including, Julia, Ruby, R, and Haskell. It supports pyspark, the
spark API for python, and visualizations using the pyplot library. Visit jupyter.org for more information.
Data Scientist Workbench
The data scientist workbench is an interactive data platform in development from IBM. It's build around
Jupyter/Ipython notebooks. The workbench comes preinstalled with Python, Scala, and R. You can
collaborate, search and share notebooks.
There are many tutorials and notebooks available, ranging from introductory to using advanced libraries.
You can register to preview the technology at datascientistworkbench.com
#### Spark Notebook
Another option is Spark notebook, a fork of Scala notebook centered on Spark development, with
integrated spark SQL support. Spark notebook allows you to use JavaScript directly to create
visualizations.
Databricks Cloud
One last notebook solution is databricks cloud. It’s currently only available on Amazon Web Services and
runs on your EC2 account.
#### Using Zeppelin
Here we see parts of the Zeppelin interface. You use special tags to identify which backend to use. The
default (no tags) is Scala. A SparkContext is automatically instantiated with the variable “sc”. There is
also a SQLContext. The sql, sh, and md tags specify SQL, bash shell, and markdown, respectively.
The play button, or shift-enter, executes the panel. You can toggle the output display and change the
panel settings as well. You will become familiar with Zeppelin in the lab exercises.

#### Lesson Summary
After completing this lesson, you should be able to:
 Use Zeppelin in your Spark projects
 Identify the various notebooks you can use with Spark
