# MCC-F1Curve #

MCC-F1Curve: a method to evaluate the performance of binary classification models

## Summary ##

The MCC-F1Curve reads an input dataset of real values and prediction values of binary classification, and outputs the corresponding MCC-F1 metric and the best threshold of this prediction. It can also plot the MCC-F1 curve.

## Installation ##

To run MCC-F1Curve, you need to have the following programs and packages installed in your machine:

* R (version 3.3.3)
* R **ROCR** package

		install.packages("ROCR")

* R **ggplot2** package

		install.packages("ggplot2")

After installing R and the afore-mentioned libraries, clone this MCC-F1Curve repository.

## Execution instructions ##

# An example

To run MCC-F1Curve, you first need to have a vector of actual values and a vector of predicted values.
I will use the following code to simulate an example. I will use beta distribution to simulate the predicted value vector.

  actual <- c(rep(1, 1000), rep(0, 10000))
  predicted <- c(rbeta(300, 12, 2), rbeta(700, 3, 4),rbeta(10000, 2, 3))

Secondly, run our package MCC-F1Curve.

Then you can use the function mccf1_calcu the corresponding MCC-F1 metric and the best threshold of the prediction.

	result <- mccf1_calcu(actual, predicted)

	result$metric

	result$bestThreshold
	
You can change the fold when calculating MCC-F1 metric.
	
  mccf1_calcu(actual, predicted, fold = 50)
  
You can also use mccf1_plot to plot the corresponding MCC-F1 curve 

	mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)")

You can save the pdf file of the image to a specified folder 

  mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)", 
           .curveFileName="/users/ccao/Pictures")

## Contacts ##

The MCC-F1Curve package was developed by Chang Cao, Davide Chicco, and Michael M. Hoffman at the Hoffman Lab of the Princess Margaret Cancer Centre (Toronto, Ontario, Canada). Questions should be
addressed to Michael M. Hoffman <michael.hoffman@utoronto.ca>.
