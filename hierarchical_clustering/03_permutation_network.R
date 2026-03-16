library(tidyverse)
library(readxl)
library(pheatmap)

compute_cor <- function(df, roi_cols) {
  cor(as.matrix(df[, roi_cols]), method = "pearson", use = "pairwise.complete.obs")
}

perm_test_network <- function(df, strain_A, strain_B, day_value, roi_cols, n_perm = 10000, seed = 123) {
  set.seed(seed)
  data_A <- df %>% filter(strain == strain_A, day == day_value)
  data_B <- df %>% filter(strain == strain_B, day == day_value)
  nA <- nrow(data_A); nB <- nrow(data_B)
  cor_A <- compute_cor(data_A, roi_cols)
  cor_B <- compute_cor(data_B, roi_cols)
  delta_obs <- cor_A - cor_B
  pool <- bind_rows(data_A, data_B) %>% select(all_of(roi_cols))
  n_tot <- nrow(pool)
  p <- length(roi_cols)
  ut <- which(upper.tri(matrix(0, p, p)), arr.ind = TRUE)
  delta_perm <- matrix(NA, nrow = n_perm, ncol = nrow(ut))
  
  for(k in 1:n_perm) {
    idx_A <- sample(1:n_tot, nA)
    idx_B <- setdiff(1:n_tot, idx_A)
    delta_perm[k, ] <- (compute_cor(pool[idx_A, ], roi_cols) - compute_cor(pool[idx_B, ], roi_cols))[upper.tri(delta_obs)]
  }
  
  p_vals <- sapply(seq_along(ut[,1]), function(i) mean(abs(delta_perm[,i]) >= abs(delta_obs[upper.tri(delta_obs)][i])))
  p_mat <- matrix(1, p, p, dimnames = list(roi_cols, roi_cols))
  p_mat[upper.tri(p_mat)] <- p_vals
  p_mat <- t(p_mat); p_mat[upper.tri(p_mat)] <- p_vals; diag(p_mat) <- 0
  
  list(delta_obs = delta_obs, p_mat = p_mat, nA = nA, nB = nB)
}

plot_delta_heatmap <- function(delta_mat, title = "Δ correlation", cluster = TRUE) {
  pheatmap(delta_mat, color = colorRampPalette(c("blue","white","red"))(101),
           breaks = seq(-1,1,length.out=102), cluster_rows = cluster, cluster_cols = cluster, main=title)
}

plot_pvalue_heatmap <- function(p_mat, alpha=0.05, title="p-values") {
  pheatmap(p_mat, color = colorRampPalette(c("white","orange","red"))(100),
           breaks = seq(0, alpha, length.out=101), cluster_rows=TRUE, cluster_cols=TRUE, main=title)
}

get_significant_edges <- function(delta_mat, p_mat, alpha=0.05) {
  roi <- rownames(delta_mat)
  edges <- expand.grid(ROI1=roi, ROI2=roi, stringsAsFactors = FALSE)
  edges$delta <- as.vector(delta_mat)
  edges$pval <- as.vector(p_mat)
  edges %>% filter(ROI1 < ROI2, pval < alpha) %>% arrange(pval)
}
