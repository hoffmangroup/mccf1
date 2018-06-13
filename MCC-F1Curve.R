library(ROCR)
library(ggplot2)

mccf1_plot <- function(actualVector, predictedVector, fold=100, .title="the MCC-F1 score curve",
                       .curveFileName) {
  # actualVector is a vector of actual values in binary classification
  # predictedVector is a vector of predicted values in binary classification
  # fold is the number that will be used to divide the range of normalized Matthews Correlation Coefficient
  # title is the title of the plot of the MCC-F1 curve
  # if the user wants to save the pdf file of the graph of the MCC-F1 curve automatically, 
  # curveFileName is the location and name of the curve 
  
  # get a performance object based on the classification
  pred <- prediction(predictedVector, actualVector)
  perf <- performance(pred, measure = "mat", x.measure = "f")
  # get MCC (Matthews correlation coefficient)
  mcc <- attr(perf, "y.values")[[1]]
  # get normalised MCC: change the range of MCC from [-1, 1] to [0, 1]
  mcc.nor <- (mcc + 1) / 2
  # get F1 score
  f1 <- attr(perf, "x.values")[[1]]   
  # get the thresholds
  thresholds <- attr(perf, "alpha.values")[[1]]
  
  # get rid of NaN values in the vectors of mcc.nor and f1
  mcc.nor_truncated <- mcc.nor[2: (length(mcc.nor) - 1)]
  f_truncated <- f1[2: (length(f1) - 1)]
  
  mccf1_df <- data.frame(F1 = f_truncated, MCC.nor = mcc.nor_truncated) 
  
  # plot the MCC-F1 curve
  mccf1_plot = ggplot(mccf1_df, aes(x = F1, y = MCC.nor, ymin = 0, ymax = 1, xmin = 0, xmax = 1)) + 
    geom_point(size = 0.2, shape = 21, fill = "white")+
    theme(plot.title = element_text(hjust = 0.5))+
    coord_equal(ratio = 1)+
    labs(x = "F1 score", y = "normalized MCC", title = .title)
  
  # xlab(expression(F[1]*" score"))
  
  plot(mccf1_plot)
  
  # if the user specifies the location which the plot should be saved to, then produce a pdf file of the 
  # plot and save it to the location
  if (!missing(.curveFileName)){
    pdf(file = .curveFileName)
    plot(mccf1_plot)
    dev.off()
  }
}

mccf1_calcu <- function(actualVector, predictedVector, fold=100) {
  # actualVector is a vector of actual values in binary classification
  # predictedVector is a vector of predicted values in binary classification
  # fold is the number that will be used to divide the range of normalized Matthews Correlation Coefficient
  
  # get a performance object based on the classification
  pred <- prediction(predictedVector, actualVector)
  perf <- performance(pred, measure = "mat", x.measure = "f")
  # get MCC (Matthews correlation coefficient)
  mcc <- attr(perf, "y.values")[[1]]
  # transform MCC to normalised MCC: change the range of MCC from [-1, 1] to [0, 1]
  mcc.nor <- (mcc + 1) / 2
  # get F1 score
  f1 <- attr(perf, "x.values")[[1]]   
  # get the thresholds
  thresholds <- attr(perf, "alpha.values")[[1]]
  
  # get rid of NaN values in the vectors of mcc.nor and F1
  mcc.nor_truncated <- mcc.nor[2: (length(mcc.nor) - 1)]
  f_truncated <- f1[2: (length(f1) - 1)]
  
  # get the index of the point with largest MCC ("point" refers to the point on the MCC-F1 curve)
  index_of_max_mcc <- which.max(mcc.nor_truncated)
  # define points on the MCC-F1 curve located on the left of the point with the highest MCC as "left curve"
  # get the left curve by getting the subvectors of MCC and F1 up to the index of the largest MCC 
  mcc_left <- mcc.nor_truncated[1: index_of_max_mcc]
  f_left <- f_truncated[1: index_of_max_mcc]
  # define points on the MCC-F1 curve located on the right of the point with the highest MCC as "right curve"
  # get the right curve by getting the subvectors of MCC and F1 after the index of the largest MCC
  mcc_right <- mcc.nor_truncated[(index_of_max_mcc + 1): length(mcc.nor_truncated)]
  f_right <- f_truncated[(index_of_max_mcc + 1): length(f_truncated)]
  
  # divide the range of MCC into subranges
  unit_len <- (max(mcc.nor_truncated) - min(mcc.nor_truncated)) / fold
  # calculate the sum of mean distances from the left curve to the point (1, 1)
  mean_distances_left <- 0
  for (i in 1: fold){
    # find all the points with MCC between unit_len*(i-1) and unit_len*i
    pos1 <- which(mcc_left >= min(mcc.nor_truncated) + (i-1) * unit_len)
    pos2 <- which(mcc_left <= min(mcc.nor_truncated) + i * unit_len)
    pos <- c()
    for (index in pos1){
      if  (index %in% pos2){
        pos <- c(pos, index)
      }
    }
    sum_of_distance_within_subrange <- 0
    for (index in pos){
      d <- sqrt((mcc_left[index] - 1)^2 + (f_left[index] - 1)^2)
      sum_of_distance_within_subrange <- sum_of_distance_within_subrange + d
    }
    mean_distances_left <- c(mean_distances_left, sum_of_distance_within_subrange / length(pos))
  }
  
  # get rid of NAs in mean_distances_left and sum the mean distances
  num_of_na_left <- sum(is.na(mean_distances_left))
  sum_of_mean_distances_left_no_na <- sum(mean_distances_left, na.rm = T)
  
  
  mean_distances_right <- 0
  for (i in 1: fold){
    # find all the points with mcc between c and c*i
    pos1 <- which(mcc_right >= min(mcc.nor_truncated) + (i-1) * unit_len)
    pos2 <- which(mcc_right <= min(mcc.nor_truncated) + i * unit_len)
    pos <- c()
    for (index in pos1){
      if  (index %in% pos2){
        pos <- c(pos, index)
      }
    }
    sum_of_distance_within_subrange <- 0 
    for (index in pos){
      d <- sqrt((mcc_right[index] - 1)^2 + (f_right[index] - 1)^2)
      sum_of_distance_within_subrange  <-  sum_of_distance_within_subrange + d
    }
    mean_distances_right <- c(mean_distances_right, sum_of_distance_within_subrange / length(pos))
  }
  
  # get rid of NAs in mean_distances_right and sum the mean distances
  num_of_na_right <- sum(is.na(mean_distances_right))
  sum_of_mean_distances_right_no_na <- sum(mean_distances_right, na.rm = T)
  
  # calculate the MCC-F1 metric
  mccf1_metric <- 1 - ((sum_of_mean_distances_left_no_na + sum_of_mean_distances_right_no_na) / (fold*2 - num_of_na_right - num_of_na_left)) / sqrt(2)
  

  # find the best threshold 
  eu_distance = c()
  for (i in (1:length(mcc.nor))){
    eu_distance <- c(eu_distance, sqrt((1 - mcc.nor[i])^2 + (1 - f1[i])^2))
  }
  
  best_threshold <- thresholds[match(min(eu_distance, na.rm = T), eu_distance)]
  
  # output of the function is the MCC-F1 metric and the top threshold
  mccf1_result <- list(mccf1_metric = mccf1_metric, best_threshold = best_threshold)
  return(mccf1_result)
}







