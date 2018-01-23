# MCC-F1Curve #

MCC-F1Curve: a method to evaluate the performance of binary classification models

## Summary ##

The MCC-F1Curve reads an input dataset of real values and prediction values of binary classification, and outputs the corresponding MCC-F1 metric and the best threshold of this prediction. It can also plot the MCC-F1 curve.

## Installation ##

To run MCC-F1Curve, you need to have the following programs and packages installed in your machine:

* R (version 3.3.3)
* R **ROCR** package

	install.package("ROCR")
	
* R **ggplot2** package
	
	install.package("ggplot2")

After installing R and the afore-mentioned libraries, clone this MCC-F1Curve repository.

## Execution instructions ##

# An example

Suppose you are evaluating a binary classification model. In your test set, you have the actual values and the predicted values. Let's use *actualVector* to represent the vector of actual values and *predictedVector* to represent the vector of predicted values.

First, run our package MCC-F1Curve.

Then you can use the function mccf1_calcu the corresponding MCC-F1 metric and the best threshold of the prediction, or the function mccf1_plot to plot the MCC-F1 curve.

	result <- mccf1_calcu(actualVector, predictedVector)

	result$metric

	result$bestthreshold

	mccf1_plot(actualVector, predictedVector)

## Contacts ##

The MCCF1_curve package was developed by Chang Cao, Davide Chicco, and Michael M. Hoffman at the Hoffman Lab of the Princess Margaret Cancer Centre (Toronto, Ontario, Canada). Questions should be
addressed to Michael M. Hoffman <michael.hoffman@utoronto.ca>.
