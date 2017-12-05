library(ROCR)
library(ggplot2)

classification_result <- function (real, prediction){
  
  pred <- prediction(prediction, real)
  perf <- performance(pred, measure = "tpr", x.measure = "fpr")
  # TPR
  tpr <- attr(perf, "y.values")[[1]]
  # FPR
  fpr <- attr(perf, "x.values")[[1]]
  # PR curve
  perf <- performance(pred, measure = "prec", x.measure = "rec")
  # precision
  precision <- attr(perf, "y.values")[[1]]
  # recall
  recall <- attr(perf, "x.values")[[1]]
  # mcc-f1
  perf <- performance(pred, measure = "mat", x.measure = "f")
  # mcc
  mcc <- attr(perf, "y.values")[[1]]
  # normalised mcc: [-1, 1] to [0, 1]
  mcc.nor <- (mcc + 1)/2
  # f score
  f <- attr(perf, "x.values")[[1]]   
  # thresholds
  thresholds <- attr(perf, "alpha.values")[[1]]
  # auc
  auc <- attr(performance(pred, "auc"), "y.values")[[1]]
  # mcc_f1 metric
  # get rid of NaN values
  mcc.nor_truncated <- mcc.nor[2: (length(mcc.nor)-1)]
  f_truncated <- f[2: (length(f)-1)]
  # new metric based on distance
  # distance_total_sum <- 0
  # for (i in 1:length(mcc.nor_truncated)){
  #   d <- sqrt((mcc.nor_truncated[i]-1)^2 + (f_truncated[i]-1)^2)
  #   distance_total_sum <- distance_total_sum + d
  # }
  # metric <- 1 - (distance_total_sum/length(mcc.nor_truncated))/sqrt(2)
  
  total_sum <- 0
  num <- 100
  c <- (max(mcc.nor_truncated)-min(mcc.nor_truncated))/num
  for (i in 1:num){
    # find all the points with mcc between c and c*i
    pos1 <- which(mcc.nor_truncated >= min(mcc.nor_truncated)+(i-1)*c)
    pos2 <- which(mcc.nor_truncated <= min(mcc.nor_truncated)+i*c)
    pos <- c()
    for (m in pos1){
      if  (m %in% pos2){
        pos <- c(pos, m)
      }
    }
    sum <- 0
    for (j in pos){
      d <- sqrt((mcc.nor_truncated[j]-1)^2 + (f_truncated[j]-1)^2)
      sum <- sum + d
    }
    total_sum <- total_sum + sum/length(pos)
  }
  
  
  
  metric <- 1 - (total_sum/num)/sqrt(2)
  
  # finding the best threshold (closest to (1,1))
  distance = c()
  for (i in (1:length(mcc.nor))){
    distance <- c(distance, sqrt((1-mcc.nor[i])^2 + (1-f[i])^2))
  }
  
  cut <- thresholds[match(min(distance, na.rm = T), distance)]
  
  output <-cbind.data.frame(tpr, fpr, precision, recall, mcc.nor, f, auc, metric, cut)
  return(output)
}
tpr_index = 1
fpr_index = 2
precision_index = 3
recall_index = 4 
mcc.nor_index = 5 
f_score_index = 6
auc_index = 7
metric_index = 8
cut_indxt = 9