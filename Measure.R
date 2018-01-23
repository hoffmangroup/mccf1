library(ROCR)
library(ggplot2)

mccf1_calcu <- function(actualVector, predictedVector, fold=100){
  # actualVector is a vector of actual values in binary classification
  # predictedVector is a vector of predicted values in binary classification
  # fold is the number that will be used to divide the range of normalized Matthews Correlation Coefficient
  
  pred <- prediction(predictedVector, actualVector)
  perf <- performance(pred, measure = "tpr", x.measure = "fpr")
  
  perf <- performance(pred, measure = "mat", x.measure = "f")
  # get MCC
  mcc <- attr(perf, "y.values")[[1]]
  # get normalised MCC: change the range of MCC from [-1, 1] to [0, 1]
  mcc.nor <- (mcc + 1)/2
  # get F1 score
  f1 <- attr(perf, "x.values")[[1]]   
  # get the thresholds
  thresholds <- attr(perf, "alpha.values")[[1]]
  
  # df <- data.frame(F1 = f1, MCC.nor = mcc.nor)
  # 
  # plot = ggplot(df, aes(x=F1, y=MCC.nor, ymin=0, ymax=1, xmin=0, xmax=1 )) + geom_point(size = 0.2, shape = 21, fill="white")+
  #   theme(plot.title=element_text(hjust=0.5))+
  #   coord_equal(ratio=1)+
  #   labs(x = "F1 score", y = "normalized MCC", title = .title)
  # 
  # # xlab(expression(F[1]*" score"))
  # 
  # if (plotCurve){
  #   
  #   plot(plot)
  # }
  # 
  # if (!missing(.curveFileName)){
  #   pdf(file = .curveFileName)
  #   plot(plot)
  #   dev.off()
  # }
  
  
  
  # get rid of NaN values
  mcc.nor_truncated <- mcc.nor[2: (length(mcc.nor)-1)]
  f_truncated <- f1[2: (length(f1)-1)]
  
  # calculate mcc_f1 metric
  
  sum_of_mean_distance <- c()
  unit_len <- (max(mcc.nor_truncated)-min(mcc.nor_truncated))/fold
  for (i in 1:fold){
    # find all the points with mcc between unit_len*(i-1) and unit_len*i
    pos1 <- which(mcc.nor_truncated >= min(mcc.nor_truncated)+(i-1)*unit_len)
    pos2 <- which(mcc.nor_truncated <= min(mcc.nor_truncated)+i*unit_len)
    pos <- c()
    for (m in pos1){
      if  (m %in% pos2){
        pos <- c(pos, m)
      }
    }
    sum_of_distance <- 0
    for (j in pos){
      d <- sqrt((mcc.nor_truncated[j]-1)^2 + (f_truncated[j]-1)^2)  # d -> temp_dist
      sum_of_distance <- sum_of_distance + d
    }
    
    sum_of_mean_distance <- c(sum_of_mean_distance, sum_of_distance/length(pos))
  }
  
  sums_no_na <- sum(sum_of_mean_distance,na.rm=T)
  metric <- 1 - (sums_no_na/length(sum_of_mean_distance))/sqrt(2)
  
  # find the best(top) threshold (closest to (1,1))
  distance = c()
  for (i in (1:length(mcc.nor))){
    distance <- c(distance, sqrt((1-mcc.nor[i])^2 + (1-f1[i])^2))
  }
  
  bestthreshold <- thresholds[match(min(distance, na.rm = T), distance)]
  
  # output of the function is the MCC-F1 metric and the top threshold
  result <- list(metric=metric, bestthreshold=bestthreshold)
  return(result)
}


mccf1_plot <- function(actualVector, predictedVector, fold=100, .title="the MCC-F1 score curve",
                       .curveFileName){
  # actualVector is a vector of actual values in binary classification
  # predictedVector is a vector of predicted values in binary classification
  # fold is the number that will be used to divide the range of normalized Matthews Correlation Coefficient
  # title is the title of the plot of the MCC-F1 curve
  # if the user wants to save the pdf file of the graph of the MCC-F1 curve automatically, 
  # curveFileName is the location and name of the curve 
  
  pred <- prediction(predictedVector, actualVector)
  perf <- performance(pred, measure = "tpr", x.measure = "fpr")
  
  perf <- performance(pred, measure = "mat", x.measure = "f")
  # get MCC
  mcc <- attr(perf, "y.values")[[1]]
  # get normalised MCC: change the range of MCC from [-1, 1] to [0, 1]
  mcc.nor <- (mcc + 1)/2
  # get F1 score
  f1 <- attr(perf, "x.values")[[1]]   
  # get the thresholds
  thresholds <- attr(perf, "alpha.values")[[1]]
  
  df <- data.frame(F1 = f1, MCC.nor = mcc.nor)  #df -> dataFrame
  
  # mcc_f1score_plot
  plot = ggplot(df, aes(x=F1, y=MCC.nor, ymin=0, ymax=1, xmin=0, xmax=1 )) + geom_point(size = 0.2, shape = 21, fill="white")+
    theme(plot.title=element_text(hjust=0.5))+
    coord_equal(ratio=1)+
    labs(x = "F1 score", y = "normalized MCC", title = .title)
  
  # xlab(expression(F[1]*" score"))
  
    plot(plot)
  
  
  if (!missing(.curveFileName)){
    pdf(file = .curveFileName)
    plot(plot)
    dev.off()
  }
}



############################### TO REMOVE

# put the example data in real_value_a
real_value_a <- ...

# put the example data in predicted_value_A
predicted_value_A <- ...

mccf1_feature(real_value_a, predicted_value_A)

