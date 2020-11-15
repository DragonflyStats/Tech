Lesson 5: Developing and Testing
=========================================
This course was developed in collaboration with MetiStream and IBM analytics.
#### Build Tools
- Sbt is the most popular built tool for Scala.
- It has built in REPL interface that allows you to build and run from the shell. It’s simple to use but
powerful and extensible. It has plugins for Eclipse and direct support in the IntelliJ IDE.
- If you’re already using it or just prefer the familiarity you can also use Maven, but it’s not as powerful or
customizable.

#### Create a Project from Command Line
With SBT you can also create builds directly from the console. For example, renaming your current
project.
In fact, sbt can build and run without any configuration files at all. It will automatically find source and
library files using a conventional directory structure. Visit the sbt project page and the tutorials there for
more information.

#### sbt and Eclipse
You can use the sbt-eclipse plugin to generate the files for an Eclipse projects.
Just add this line to your project’s plugins.sbt file.
Then from the terminal, in the root directory of your project, run sbt eclipse.
Now you can import the project from within Eclipse. This needs to be re-reun whenever the build
changes.
View the github page for the plugin for more information.

-----------------------------------------------------------
#### sbt and IntelliJ
Intellij has much cleaner integration with sbt. It fully supports sbt build files with no conversions
required. Intellij has a built-in Scala console, it supports scalatest and debugging.

------------------------------------------------------------
#### Unit Testing
We’ll go over a few points to get you started with unit testing.
Isolate your RDD operations. The transformations for a given RDD should be put in its own object or
class. You want to test the code that is actually used in your application.

Take advantage of standard unit testing tools, like scalatest. There is also the very handy spark-testingbase
package that comes with helper class to facilitate testing.
Here is part of an sbt build that includes scalatest and spark-testing-base.

------------------------------------------------------------
#### Unit Testing Example
Here is an example unit test of a word count.
We have our test input and the expected results.
Then we run a word count on the input. Realistically the logic for the word count would be in a class or
object somewhere else. Then we run assertResults to check that the expected value matches the
output.

Here’s another test. Again, this is just a contrived example for demonstration purposes.
assertResult tests that splitting the input gives the expected sequence.
But in this case the test will fail, since our input string doesn’t have any spaces in it.
A Testfailedexception will be thrown, showing the expected and actual results of the test.

------------------------------------------------------------
#### Managing Dependencies
Any additional libraries in your project must be distributed to workers.
When using the spark-submit script, use the jars flag. You can reference jars from many sources
including HTTP, FTP, and HDFS
Common practice is to bundle everything into one big jar.
This is made easy with sbt. just add sbt-assembly to your plugins file. Then run sbt assembly in your
project root directory.
-----------------------------------------------------------
#### Lesson Summary
Having completed this lesson, you should be able to use sbt to build Spark projects, use Eclipse and
IntelliJ for Spark development, unit test your spark projects, and manage dependencies.
Congratulations on completing the course. Don't forget to do the final exercise and the course quiz, and
then fill out the course feedback.
Thank you.
