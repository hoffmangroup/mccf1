# MCC-F1Curve #

MCC-F1Curve: a method to evaluate the performance of binary classification models

## Summary ##

The MCC-F1Curve reads an input dataset of real values and prediction values of binary classification, and outputs the corresponding MCC-F1 score metric and the best confusion matrix threshold of the prediction. It can also plot the MCC-F1 score curve.

## Installation ##

To run MCC-F1Curve, you need to have the following programs and packages installed in your machine:

* R (version 3.3.3)
* R **ROCR** package

		install.packages("ROCR")

* R **ggplot2** package

		install.packages("ggplot2")

After installing R and the afore-mentioned libraries, clone this MCC-F1Curve repository.

## Execution instructions ##

Allocate your ground-truth real values into an array, and your predicted real values into another one. Then call the `mccf1_calcu()` function to compute the MCC-F1 score metric and the best thresold, or the `mccf1_plot()` to plot and save the MCC-F1 score curve. See the example below.

# An example

To run MCC-F1Curve, you first need to have a vector of actual values and a vector of predicted values.

We use beta distribution to simulate the predicted value vector. From the R terminal, type:

    actual <- c(rep(1, 1000), rep(0, 10000))
    predicted <- c(rbeta(300, 12, 2), rbeta(700, 3, 4),rbeta(10000, 2, 3))

Secondly, include the code file MCC-F1Curve.R.

    source("MCC-F1Curve.R")

Then you can use the function `mccf1_calcu()` to generate the corresponding MCC-F1 score metric and the best threshold of the prediction:

	result <- mccf1_calcu(actual, predicted)

	cat("The MCC F1 score metric is ", result$mccf1_metric," \n");

	cat("The best confusion matrix threshold for the MCC F1 score curve is ", result$bestThreshold," \n");
	
You can also change the fold when calculating MCC-F1 metric.
	
	mccf1_calcu(actual, predicted, fold = 50)
  
You can also use `mccf1_plot()` to plot the corresponding MCC-F1 curve. 

	mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)")

You can save the pdf file of the image to a specified folder. 

    mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)", .curveFileName="/users/ccao/Pictures/mcc-f1_example")

## Contacts ##

The MCC-F1Curve package was developed by Chang Cao, Davide Chicco, and Michael M. Hoffman at the [Hoffman Lab](http://www.hoffmanlab.org) of the [Princess Margaret Cancer Centre](http://www.uhn.ca/PrincessMargaret/Research) (Toronto, Ontario, Canada). Questions should be
addressed to Michael M. Hoffman <michael.hoffman@utoronto.ca>.
