GraphLab
==============
GraphLab is a graph-based, high performance, distributed computation framework written in C++. The GraphLab project started by Prof. Carlos Guestrin of Carnegie Mellon University in 2009. It is an open source project using Apache License. While GraphLab was originally developed for Machine Learning tasks, it has found great success at a broad range of other data-mining tasks; out-performing other abstractions by orders of magnitude.


Main features of GraphLab are:

- A unified multicore and distributed API: write once run efficiently in both shared and distributed memory systems
- Tuned for performance: optimized C++ execution engine leverages extensive multi-threading and asynchronous IO
- Scalable: GraphLab intelligently places data and computation using sophisticated new algorithms
- HDFS Integration
- Powerful Machine Learning Toolkits

<hr>
GraphLab have implemented the following toolkits

1. Topic Modeling contains applications like LDA which can be used to cluster documents and extract topical representations.
2. Graph Analytics contains application like pagerank and triangle counting which can be applied to general graphs to estimate community structure.
3. Clustering contains standard data clustering tools such as Kmeans
4. Collaborative Filtering contains a collection of applications used to make predictions about users interests and factorize large matrices.
5. Graphical Models contains tools for making joint predictions about collections of related random variables.
6. Factor Graph Toolkit contains Belief Propagation impelementation for factor graphs
7. Linear iterative solver contains solvers for linear systems of equations - currently the Jacobi algorithm is implemented
8. Computer Vision contains a collection of tools for reasoning about images.

#### References
- http://docs.graphlab.org/index.html
- http://docs.graphlab.org/modules.html
