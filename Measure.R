library(ROCR)
library(ggplot2)

mccf1_feature <- function(actualvector, predictedvector,fold=100,plotCurve=T,.title="the MCC-F1 score curve",.curveFileName){
  # actualvector is a vector of actual values in binary classification
  # predictedvector is a vector of predicted values in binary classification
  # fold is the number that will be used to divide the range of normalized Matthews Correlation Coefficient
  # plotCurve is whether or not the MCC-F1 curve will be plotted.
  # title is the title of the curve
  # curveFileName is the location and name of the curve if the user wants to save the curve automatically
  
  pred <- prediction(predictedvector, actualvector)
  perf <- performance(pred, measure = "tpr", x.measure = "fpr")
  
  perf <- performance(pred, measure = "mat", x.measure = "f")
  # get MCC
  mcc <- attr(perf, "y.values")[[1]]
  # get normalised MCC: change the range of MCC from [-1, 1] to [0, 1]
  mcc.nor <- (mcc + 1)/2
  # get F1 score
  f <- attr(perf, "x.values")[[1]]   
  # get the thresholds
  thresholds <- attr(perf, "alpha.values")[[1]]
  
  df <- data.frame(F1 = f, MCC.nor = mcc.nor)
  
  P = ggplot(df, aes(x=F1, y=MCC.nor, ymin=0, ymax=1, xmin=0, xmax=1 )) + geom_point(size = 0.2, shape = 21, fill="white")+
    theme(plot.title=element_text(hjust=0.5))+
    coord_equal(ratio=1)+
    labs(x = "F1 score", y = "normalized MCC", title = .title)
  
  # xlab(expression(F[1]*" score"))
  
  if (plotCurve){
    
    plot(P)
  }
  
  if (!missing(.curveFileName)){
    pdf(file = .curveFileName)
    plot(P)
    dev.off()
  }
  
  
  
  # get rid of NaN values
  mcc.nor_truncated <- mcc.nor[2: (length(mcc.nor)-1)]
  f_truncated <- f[2: (length(f)-1)]
  
  # calculate mcc_f1 metric
  
  sums <- c()
  c <- (max(mcc.nor_truncated)-min(mcc.nor_truncated))/fold
  for (i in 1:fold){
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
    
    sums <- c(sums, sum/length(pos))
  }
  
  total_sum <- sum(sums,na.rm=T)
  metric <- 1 - (total_sum/length(sums))/sqrt(2)
  
  # find the best(top) threshold (closest to (1,1))
  distance = c()
  for (i in (1:length(mcc.nor))){
    distance <- c(distance, sqrt((1-mcc.nor[i])^2 + (1-f[i])^2))
  }
  
  bestthreshold <- thresholds[match(min(distance, na.rm = T), distance)]
  
  # output of the function is the MCC-F1 metric and the top threshold
  result <- list(metric=metric, bestthreshold=bestthreshold)
  return(result)
}

############################### TO REMOVE


mccf1_feature(real_value_a,predicted_value_A)

