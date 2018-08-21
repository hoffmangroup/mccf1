# mccf1 #

mccf1: a method to evaluate the performance of binary classification models

## Summary ##

The mccf1 reads an input dataset of real values and prediction values of binary classification, and outputs the corresponding MCC-F1 score metric and the best confusion matrix threshold of the prediction. It can also plot the MCC-F1 score curve.

## Installation ##

The mccf1 package is now available on CRAN: [https://cran.r-project.org/package=mccf1](https://cran.r-project.org/package=mccf1)

To run mccf1, you need to have the following programs and packages installed in your machine:

* R (version 3.3.3)
* R **ROCR** package

		install.packages("ROCR")

* R **ggplot2** package

		install.packages("ggplot2")

After installing R, you can install the mccf1 package by typing in the R terminal:
`install.packages("mccf1")`

## Execution instructions ##

Allocate your ground-truth real values into an array, and your predicted real values into another one. Then call the `mccf1_calcu()` function to compute the MCC-F1 score metric and the best thresold, or the `mccf1_plot()` to plot and save the MCC-F1 score curve. See the example below.

# An example

To run mccf1, you first need to have a vector of actual values and a vector of predicted values.

We use beta distribution to simulate the predicted value vector. From the R terminal, type:

    positive_class <- 1
    negative_class <- 0
    num_of_positive_class <- 1000
    num_of_negative_class <- 10000
    proportion_of_predicted_for_pos_type_1 <- 0.3
    proportion_of_predicted_for_pos_type_2 <- 1 - proportion_of_predicted_for_pos_type_1
    shape1_pos_type_1 <- 12
    shape2_pos_type_1 <- 2
    shape1_pos_type_2 <- 3
    shape2_pos_type_2 <- 4
    shape1_neg <- 2 
    shape2_neg <- 3
    actual <- c(rep(positive_class, num_of_positive_class), rep(negative_class, num_of_negative_class))
    predicted <- c(rbeta(proportion_of_predicted_for_pos_type_1 * num_of_positive_class, shape1_pos_type_1,    
                  shape2_pos_type_1), rbeta(proportion_of_predicted_for_pos_type_2 * num_of_positive_class, 
                  shape1_pos_type_2, shape2_pos_type_2), rbeta(num_of_negative_class, shape1_neg, shape2_neg))

Secondly, include the code file mccf1.R.

    source("mccf1.R")

Then you can use the function `mccf1_calcu()` to generate the corresponding MCC-F1 score metric and the best threshold of the prediction:

	result <- mccf1_calcu(actual, predicted)

	cat("The MCC F1 score metric is ", result$mccf1_metric," \n");

	cat("The best confusion matrix threshold for the MCC F1 score curve is ", result$bestThreshold," \n");
	
You can also change the fold when calculating MCC-F1 metric.
	
	mccf1_calcu(actual, predicted, fold = 50)
  
You can also use `mccf1_plot()` to plot the corresponding MCC-F1 curve. 

	mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)")

You can save the pdf file of the image to a specified folder. 

    pdfFileName = "./curve.pdf" 

    mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)", .curveFileName=pdfFileName)

## Contacts ##

The mccf1 package was developed by Chang Cao, Davide Chicco, and Michael M. Hoffman at the [Hoffman Lab](http://www.hoffmanlab.org) of the [Princess Margaret Cancer Centre](http://www.uhn.ca/PrincessMargaret/Research) (Toronto, Ontario, Canada). Questions should be
addressed to Michael M. Hoffman <michael.hoffman@utoronto.ca>.
