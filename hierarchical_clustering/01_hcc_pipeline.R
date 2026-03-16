# ===============================
#  HIERARCHICAL CLUSTERING PIPELINE
# ===============================
library(ggplot2)
library(NbClust)
library(cluster)
library(dplyr)
library(readxl)
library(pheatmap)
library(RColorBrewer)

HCC_pipeline <- function(data_mat, distance_method = c("euclidean", "1-r")) {
  distance_method <- match.arg(distance_method)
  
  # ===============================
  #       DISTANCE MATRIX
  # ===============================
  if(distance_method == "euclidean") {
    dist_mat <- dist(data_mat, method = "euclidean")
  } else {
    dist_mat <- as.dist(1 - data_mat)
  }
  
  # ===============================
  #  HIERARCHICAL CLUSTERING
  # ===============================
  hc_list <- list(
    single = hclust(dist_mat, method = "single"),
    average = hclust(dist_mat, method = "average"),
    complete = hclust(dist_mat, method = "complete"),
    ward.D2 = hclust(dist_mat, method = "ward.D2")
  )
  
  # ===============================
  #  PLOT DENDROGRAMS
  # ===============================
  par(mfrow = c(2,2))
  for(n in names(hc_list)) {
    plot(hc_list[[n]], hang = -1, main = paste(n, "linkage"), cex = 0.8)
  }
  par(mfrow = c(1,1))
  
  # ===============================
  #  HEATMAPS
  # ===============================
  colors <- colorRampPalette(brewer.pal(n = 7, name = "RdBu"))(100)
  dist_matrix <- as.matrix(dist_mat)
  for(method_name in names(hc_list)) {
    pheatmap(
      dist_matrix,
      clustering_distance_rows = dist_mat,
      clustering_distance_cols = dist_mat,
      clustering_method = method_name,
      color = colors,
      show_rownames = TRUE,
      show_colnames = TRUE,
      border_color = NA,
      main = paste("Heatmap", method_name)
    )
  }
  
  return(list(distance_matrix = dist_mat, hc_list = hc_list))
}
