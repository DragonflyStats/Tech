Apache Mahout
=====================
Apache Mahout is a new open source project by the Apache Software Foundation (ASF) with the primary goal of creating scalable machine-learning algorithms that are free to use under the Apache license. The project is entering its second year, with one public release under its belt. Mahout contains implementations for clustering, categorization, CF, and evolutionary programming. Furthermore, where prudent, it uses the Apache Hadoop library to enable Mahout to scale effectively in the cloud.

#### Mahout history
The Mahout project was started by several people involved in the Apache Lucene (open source search) community with an active interest in machine learning and a desire for robust, well-documented, scalable implementations of common machine-learning algorithms for clustering and categorization. 

The community was initially driven by Ng et al.'s paper "Map-Reduce for Machine Learning on Multicore" but has since evolved to cover much broader machine-learning approaches. Mahout also aims to:
- Build and support a community of users and contributors such that the code outlives any particular contributor's involvement or any particular company or university's funding.
- Focus on real-world, practical use cases as opposed to bleeding-edge research or unproven techniques.
- Provide quality documentation and examples.

#### Clustering with Mahout
Mahout supports several clustering-algorithm implementations, all written in Map-Reduce, each with its own set of goals and criteria:
- Canopy: A fast clustering algorithm often used to create initial seeds for other clustering algorithms.
- k-Means (and fuzzy k-Means): Clusters items into k clusters based on the distance the items are from the centroid, or center, of the previous iteration.
- Mean-Shift: Algorithm that does not require any a priori knowledge about the number of clusters and can produce arbitrarily shaped clusters.
- Dirichlet: Clusters based on the mixing of many probabilistic models giving it the advantage that it doesn't need to commit to a particular view of the clusters prematurely.
