# Andrea-Sepe.github.io
# – Hierarchical Clustering

This folder contains R scripts for performing hierarchical clustering and permutation-based correlation analysis on neural data. 
The scripts are designed to process correlation matrices, analyze cluster structure, and visualize results.

## Scripts Overview

### `01_hcc_pipeline.R`
- **Purpose:** Performs hierarchical clustering on a correlation matrix and visualizes results.
- **Main function:** `HCC_pipeline(data_mat, distance_method = c("euclidean", "1-r"))`
- **Description:**
  - Computes a distance matrix from the input correlation data (`euclidean` or `1-r`).
  - Performs hierarchical clustering using four linkage methods: single, average, complete, and Ward (ward.D2).
  - Generates dendrograms for all linkage methods.
  - Produces heatmaps of the distance matrices, showing the clustering patterns visually.
- **Output:** 
  - A list containing the distance matrix and the `hclust` objects for each linkage method.

---

### 2️`02_plot_linkage_curves.R`
- **Purpose:** Plots the evolution of the number of clusters at different dendrogram heights.
- **Main function:** `plot_linkage_curves(data_list, distance_method = c("euclidean", "1-r"))`
- **Description:**
  - Accepts multiple correlation matrices (e.g., from different datasets or conditions).
  - Performs hierarchical clustering for each dataset using four linkage methods.
  - Extracts the number of clusters at each dendrogram height.
  - Plots the “cluster evolution curves” for visual comparison across datasets and linkage methods.
- **Output:** 
  - A combined data frame with cluster counts and dendrogram heights.
  - A faceted ggplot figure showing cluster evolution for each linkage method.
- **Use case:** Identify optimal cluster numbers and compare clustering patterns across datasets.

---

### `03_permutation_network.R`
- **Purpose:** Performs permutation testing on correlation matrices to compare groups or conditions.
- **Main functions:**  
  - `compute_cor()`: calculates the correlation matrix.  
  - `perm_test_network()`: performs permutation tests between two groups.  
  - `plot_delta_heatmap()`: visualizes the difference matrix between groups.  
  - `plot_pvalue_heatmap()`: visualizes p-values from permutation tests.  
  - `get_significant_edges()`: extracts ROI pairs with significant differences.
- **Description:**
  - Compares correlation matrices between groups.
  - Uses permutation testing to generate null distributions for statistical significance.
  - Produces heatmaps for both correlation differences (delta) and p-values.
  - Can filter only significant differences for clear visualization.
- **Output:** 
  - Delta correlation matrices
  - P-value matrices
  - Heatmaps and tables of significant edges
- **Use case:** Identify connections that are significantly different between groups or conditions.

---

## How to use
1. Place your Excel data files with correlation matrices in a known location.
2. Source or copy the desired script into your R environment.
3. Call the functions with your data matrices or paths to your Excel files.
4. Explore dendrograms, heatmaps, and cluster evolution plots to analyze the data.

---

## Notes
- Scripts are modular and can be combined or adapted to different datasets.
- Designed for R (tested with R >= 4.0) with dependencies: `ggplot2`, `dplyr`, `readxl`, `NbClust`, `cluster`, `pheatmap`, `RColorBrewer`.
- Input data should be clean numeric correlation matrices with rows/columns labels.
