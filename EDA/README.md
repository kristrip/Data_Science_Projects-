# Exploratory Data Analysis


This Repository Contains EDA (Exploratory Data Analysis) of datasets.
It consist of  Statistics ( both  Descriptive statistics and Inferential statistics ) and algebra.


In statistics, exploratory data analysis is an approach of analyzing data sets to summarize their main characteristics, often using statistical graphics and other data visualization methods. A statistical model can be used or not, but primarily EDA is for seeing what the data can tell us beyond the formal modeling and thereby contrasts traditional hypothesis testing. Exploratory data analysis has been promoted by John Tukey since 1970 to encourage statisticians to explore the data, and possibly formulate hypotheses that could lead to new data collection and experiments. EDA is different from initial data analysis (IDA),[1][2] which focuses more narrowly on checking assumptions required for model fitting and hypothesis testing, and handling missing values and making transformations of variables as needed. EDA encompasses IDA.


Overview
Tukey defined data analysis in 1961 as: "Procedures for analyzing data, techniques for interpreting the results of such procedures, ways of planning the gathering of data to make its analysis easier, more precise or more accurate, and all the machinery and results of (mathematical) statistics which apply to analyzing data."[3]

Tukey's championing of EDA encouraged the development of statistical computing packages, especially S at Bell Labs.[4] The S programming language inspired the systems S-PLUS and R. This family of statistical-computing environments featured vastly improved dynamic visualization capabilities, which allowed statisticians to identify outliers, trends and patterns in data that merited further study.

Tukey's EDA was related to two other developments in statistical theory: robust statistics and nonparametric statistics, both of which tried to reduce the sensitivity of statistical inferences to errors in formulating statistical models. Tukey promoted the use of five number summary of numerical data—the two extremes (maximum and minimum), the median, and the quartiles—because these median and quartiles, being functions of the empirical distribution are defined for all distributions, unlike the mean and standard deviation; moreover, the quartiles and median are more robust to skewed or heavy-tailed distributions than traditional summaries (the mean and standard deviation). The packages S, S-PLUS, and R included routines using resampling statistics, such as Quenouille and Tukey's jackknife and Efron's bootstrap, which are nonparametric and robust (for many problems).

Exploratory data analysis, robust statistics, nonparametric statistics, and the development of statistical programming languages facilitated statisticians' work on scientific and engineering problems. Such problems included the fabrication of semiconductors and the understanding of communications networks, which concerned Bell Labs. These statistical developments, all championed by Tukey, were designed to complement the analytic theory of testing statistical hypotheses, particularly the Laplacian tradition's emphasis on exponential families.[5]

Development

Data science process flowchart
John W. Tukey wrote the book Exploratory Data Analysis in 1977.[6] Tukey held that too much emphasis in statistics was placed on statistical hypothesis testing (confirmatory data analysis); more emphasis needed to be placed on using data to suggest hypotheses to test. In particular, he held that confusing the two types of analyses and employing them on the same set of data can lead to systematic bias owing to the issues inherent in testing hypotheses suggested by the data.

The objectives of EDA are to:

Enable unexpected discoveries in the data
Suggest hypotheses about the causes of observed phenomena
Assess assumptions on which statistical inference will be based
Support the selection of appropriate statistical tools and techniques
Provide a basis for further data collection through surveys or experiments[7]
Many EDA techniques have been adopted into data mining. They are also being taught to young students as a way to introduce them to statistical thinking.

Techniques and tools
There are a number of tools that are useful for EDA, but EDA is characterized more by the attitude taken than by particular techniques.

Typical graphical techniques used in EDA are:

Box plot
Histogram
Multi-vari chart
Run chart
Pareto chart
Scatter plot (2D/3D)
Stem-and-leaf plot
Parallel coordinates
Odds ratio
Targeted projection pursuit
Heat map
Bar chart
Horizon graph
Glyph-based visualization methods such as PhenoPlot[10] and Chernoff faces
Projection methods such as grand tour, guided tour and manual tour
Interactive versions of these plots
Dimensionality reduction:

Multidimensional scaling
Principal component analysis (PCA)
Multilinear PCA
Nonlinear dimensionality reduction (NLDR)
Iconography of correlations
Typical quantitative techniques are:

Median polish
Trimean
Ordination
History
Many EDA ideas can be traced back to earlier authors, for example:

Francis Galton emphasized order statistics and quantiles.
Arthur Lyon Bowley used precursors of the stemplot and five-number summary (Bowley actually used a "seven-figure summary", including the extremes, deciles and quartiles, along with the median—see his Elementary Manual of Statistics (3rd edn., 1920), p. 62[11]– he defines "the maximum and minimum, median, quartiles and two deciles" as the "seven positions").
Andrew Ehrenberg articulated a philosophy of data reduction (see his book of the same name).
The Open University course Statistics in Society (MDST 242), took the above ideas and merged them with Gottfried Noether's work, which introduced statistical inference via coin-tossing and the median test.
