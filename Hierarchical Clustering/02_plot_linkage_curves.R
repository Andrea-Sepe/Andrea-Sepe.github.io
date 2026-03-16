library(ggplot2)
library(dplyr)

plot_linkage_curves <- function(data_list, distance_method = c("euclidean","1-r")) {
  distance_method <- match.arg(distance_method)
  results_list <- list()
  
  for(i in seq_along(data_list)) {
    data_mat <- as.matrix(data_list[[i]])
    dist_mat <- if(distance_method == "euclidean") dist(data_mat) else as.dist(1 - data_mat)
    
    hc_list <- list(
      single = hclust(dist_mat, method = "single"),
      average = hclust(dist_mat, method = "average"),
      complete = hclust(dist_mat, method = "complete"),
      ward = hclust(dist_mat, method = "ward.D2")
    )
    
    for(method_name in names(hc_list)) {
      hc <- hc_list[[method_name]]
      heights <- sort(hc$height)
      n_clusters <- sapply(heights, function(h) length(unique(cutree(hc, h = h))))
      
      df <- data.frame(
        dataset = paste0("Dataset_", i),
        linkage = method_name,
        n_clusters = n_clusters,
        height = heights
      )
      results_list[[length(results_list)+1]] <- df
    }
  }
  
  cluster_df <- bind_rows(results_list)
  
  p <- ggplot(cluster_df, aes(x = height, y = n_clusters, color = dataset)) +
    geom_line(size = 1) + geom_point(size = 2) +
    facet_wrap(~linkage, scales = "free_y") +
    labs(title = paste("Cluster evolution (distance:", distance_method, ")"),
         x = "Dendrogram Height", y = "Number of Clusters", color = "Dataset") +
    theme_minimal()
  
  print(p)
  return(cluster_df)
}
