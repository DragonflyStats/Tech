# Load SparkR library
Sys.setenv(SPARK_HOME = "/Users/giorgijvaridze/code/spark/spark-1.6.0-bin-hadoop2.6")
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# Start up SparkContext and SqlContext
sc <- sparkR.init(master = "local[*]", sparkEnvir = list(spark.driver.memory="2g"))
sqlContext <- sparkRSQL.init(sc)

# Create Spark DataFrame from data.frame
df <- createDataFrame(sqlContext, faithful)

# Get basic information about the DataFrame
df
## DataFrame[eruptions:double, waiting:double]

# Select only the "eruptions" column
head(select(df, df$eruptions))
##  eruptions
##1     3.600
##2     1.800
##3     3.333

# You can also pass in column name as strings
head(select(df, "eruptions"))
##  eruptions
##1     3.600
##2     1.800
##3     3.333
##4     2.283
##5     4.533
##6     2.883

# Filter the DataFrame to only retain rows with wait times shorter than 50 mins
head(filter(df, df$waiting < 50))
##  eruptions waiting
##1     1.750      47
##2     1.750      47
##3     1.867      48

# Register Spark DataFrame as a temp table so we can query with SQL on it
registerTempTable(df, "faithfulTable")

res <- sql(sqlContext, "select sum(waiting)/count(waiting) from faithfulTable")
##DataFrame[_c0:double]

collect(res)
##       _c0
##1 70.89706

# Reading Json file via Spark
people <- read.df(sqlContext, c(file.path(Sys.getenv("SPARK_HOME"), "/examples/src/main/resources/people.json")), "json")
head(people)
##  age    name
##1  NA Michael
##2  30    Andy
##3  19  Justin

# SparkR automatically infers the schema from the JSON file
printSchema(people)
## root
##  |-- age: integer (nullable = true)
##  |-- name: string (nullable = true)

# Convert to data.frame
people.df <- collect(people)
