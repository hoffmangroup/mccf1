library(ROCR)
library(ggplot2)

#' MCC (Matthews correlation coefficient) - F1
#'
#' This function creates the "mccf1" object.
#' @param response a vector of actual values (0 or 1) in binary classification.
#' @param predictor a vector of predicted values (between 0 and 1) in binary classification.
#' @return the "mccf1" object, which is basically a list containing a vector of thresholds, a vector of corresponding normalized MCC, and a vector of corresponding F1.
#' @examples
#' response <- c(rep(1, 1000), rep(0, 10000))
#' set.seed(2017)
#' predictor <- c(rbeta(300, 12, 2), rbeta(700, 3, 4), rbeta(10000, 2, 3))
#' x <- mccf1(response, predictor)
#' head(x$normalizedMCC)
#' # [1]  NaN 0.5150763 0.5213220 0.5261152 0.5301566 0.5337177
#' head(x$F1)
#' # [1]  NaN 0.001998002 0.003992016 0.005982054 0.007968127 0.009950249
#' head(x$thresholds)
#' # [1]  Inf 0.9935354 0.9931493 0.9930786 0.9925507 0.9900520

mccf1 <- function(response, predictor){
  # get a performance object based on the classification
  pred <- ROCR::prediction(predictor, response)
  perf <- ROCR::performance(pred, measure = "mat", x.measure = "f")
  # get MCC (Matthews correlation coefficient)
  mcc <- attr(perf, "y.values")[[1]]
  # get normalised MCC: change the range of MCC from [-1, 1] to [0, 1]
  mcc.nor <- (mcc + 1) / 2
  # get F1 score
  f1 <- attr(perf, "x.values")[[1]]
  # get the thresholds
  thresholds <- attr(perf, "alpha.values")[[1]]

  res = list(normalizedMCC = mcc.nor, F1 = f1, thresholds = thresholds)
  class(res)="mccf1"
  return(res)
}

#' Plot the MCC-F1 curve
#'
#' This function plots the MCC-F1 score curve using ggplot.
#' @param x "mccf1" object resulting from the function mccf1
#' @param main main title of the plot (default: "the MCC-F1 score curve")
#' @param xlab,ylab x- and y- axis annotation (default: "F1 score","normalized MCC")
#' @param .curveFileName character string, used for naming pdf file of the plot with \code{\link[grDevices]{pdf}} (if this argument is present, the plot will be stored in pdf with specified file name)
#' @param ... further arguments passed to and from methods
#' @return the ggplot object
#' @examples
#' response <- c(rep(1, 1000), rep(0, 10000))
#' predictor <- c(rbeta(300, 12, 2), rbeta(700, 3, 4), rbeta(10000, 2, 3))
#' plot(mccf1(response, predictor))

plot.mccf1 <- function(x, main = "the MCC-F1 score curve", xlab = "F1 score", ylab = "normalized MCC", .curveFileName, ...){
  # get rid of NaN values in the vectors of mcc.nor and f1
  mcc.nor_truncated <- x$normalizedMCC[2: (length(x$normalizedMCC) - 1)]
  f_truncated <- x$F1[2: (length(x$F1) - 1)]

  f <- m <- NULL


  mccf1_df <- data.frame(f = f_truncated,  m = mcc.nor_truncated)

  # plot the MCC-F1 curve
  mccf1_plot = ggplot2::ggplot(mccf1_df, ggplot2::aes(x = f, y = m, ymin = 0, ymax = 1, xmin = 0, xmax = 1)) +
    ggplot2::geom_point(size = 0.2, shape = 21, fill = "white")+
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))+
    ggplot2::coord_equal(ratio = 1)+
    ggplot2::labs(x = xlab, y = ylab, title = main)

  plot(mccf1_plot)

  if (!missing(.curveFileName)){
    pdf(file = .curveFileName)
    plot(mccf1_plot)
    dev.off()
  }
}

#' Summarize the the performance of a binary classification using MCC-F1 metric and the best threshold
#'
#' This function calculates the MCC-F1 metric and the best threshold for a binary classification.
#' @param object "mccf1" object resulting from the function mccf1
#' @param digits an integer, used for number formatting with \code{\link[base]{signif}}
#' @param bins an integer, will be used to divide the range of normalized MCC when calculating the MCC-F1 metric (default = 100)
#' @param ... further arguments passed to and from methods
#' @return a data.frame that shows the MCC-F1 metric (between 0 and 1) and the best threshold (between 0 and 1)
#' @examples
#' response <- c(rep(1, 1000), rep(0, 10000))
#' set.seed(2017)
#' predictor <- c(rbeta(300, 12, 2), rbeta(700, 3, 4), rbeta(10000, 2, 3))
#' \dontrun{summary(mccf1(response, predictor))}
#' # mccf1_metric best_threshold
#' #    0.3508904       0.786905
#' summary(mccf1(response, predictor), bins = 50)
#' # mccf1_metric best_threshold
#' #    0.3432971       0.786905
#' \dontrun{summary(mccf1(response, predictor), digits = 3)}
#' # mccf1_metric best_threshold
#' #    0.351          0.787

summary.mccf1 <- function(object, digits, bins = 100, ...){
  # get rid of NaN values in the vectors of mcc.nor and F1
  mcc.nor_truncated <- object$normalizedMCC[2: (length(object$normalizedMCC) - 1)]
  f_truncated <- object$F1[2: (length(object$F1) - 1)]

  # get the index of the point with largest normalized MCC ("point" refers to the point on the MCC-F1 curve)
  index_of_max_mcc <- which.max(mcc.nor_truncated)
  # define points on the MCC-F1 curve located on the left of the point with the highest normalized MCC as "left curve"
  # get the left curve by getting the subvectors of MCC and F1 up to the index of the largest normalized MCC
  mcc_left <- mcc.nor_truncated[1: index_of_max_mcc]
  f_left <- f_truncated[1: index_of_max_mcc]
  # define points on the MCC-F1 curve located on the right of the point with the highest normalized MCC as "right curve"
  # get the right curve by getting the subvectors of MCC and F1 after the index of the largest normalized MCC
  mcc_right <- mcc.nor_truncated[(index_of_max_mcc + 1): length(mcc.nor_truncated)]
  f_right <- f_truncated[(index_of_max_mcc + 1): length(f_truncated)]

  # divide the range of normalized MCC into subranges
  unit_len <- (max(mcc.nor_truncated) - min(mcc.nor_truncated)) / bins
  # calculate the sum of mean distances from the left curve to the point (1, 1)
  mean_distances_left <- 0
  for (i in 1: bins){
    # find all the points on the left curve with normalized MCC between unit_len*(i-1) and unit_len*i
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

  # calculate the sum of mean distances from the right curve to the point (1, 1)
  mean_distances_right <- 0
  for (i in 1: bins){
    # find all the points on the right curve with normalized MCC between unit_len*(i-1) and unit_len*i
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
  mccf1_metric <- 1 - ((sum_of_mean_distances_left_no_na + sum_of_mean_distances_right_no_na) / (bins*2 - num_of_na_right - num_of_na_left)) / sqrt(2)


  # find the best threshold
  eu_distance = c()
  for (i in (1: length(mcc.nor_truncated))){
    eu_distance <- c(eu_distance, sqrt((1 - mcc.nor_truncated[i])^2 + (1 - f_truncated[i])^2))
  }

  best_threshold <- object$thresholds[2 : (length(object$thresholds) - 1)][match(min(eu_distance, na.rm = T), eu_distance)]

  # output of the function is the MCC-F1 metric and the top threshold
  if (!missing(digits)){
    mccf1_result <- data.frame(mccf1_metric = signif(mccf1_metric, digits), best_threshold = signif(best_threshold, digits))
  } else{
    mccf1_result <- data.frame(mccf1_metric = mccf1_metric, best_threshold = best_threshold)
    }
  print(mccf1_result, row.names = FALSE)
}



