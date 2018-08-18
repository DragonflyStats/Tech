The process of data cleansing

Data Auditing: The data is audited with the use of statistical methods to detect anomalies and contradictions. This eventually gives an indication of the characteristics of the anomalies and their locations.

Workflow specification: The detection and removal of anomalies is performed by a sequence of operations on the data known as the workflow. It is specified after the process of auditing the data and is crucial in achieving the end product of high quality data. In order to achieve a proper workflow, the causes of the anomalies and errors in the data have to be closely considered. If for instance we find that an anomaly is a result of typing errors in data input stages, the layout of the keyboard can help in manifesting possible solutions.

Workflow execution: In this stage, the workflow is executed after its specification is complete and its correctness is verified. The implementation of the workflow should be efficient even on large sets of data which inevitably poses a trade-off because the execution of a data cleansing operation can be computationally expensive.

Post-Processing and Controlling: After executing the cleansing workflow, the results are inspected to verify correctness. Data that could not be corrected during execution of the workflow are manually corrected if possible. The result is a new cycle in the data cleansing process where the data is audited again to allow the specification of an additional workflow to further cleanse the data by automatic processing.
