# MCCF1_curve #

MCCF1_curve: a method to evaluate the performance of binary classification models

## Summary ##

The MCC-F1Measure reads an input dataset of real values and prediction values of binary classification, and outputs the corresponding MCC-F1 metric and the best threshold of this prediction. It can also plot the MCC-F1 curve.

## Installation ##

To run MCCF1_curve, you need to have the following programs and packages installed in your machine:

* R (version 3.3.3)
* R **ROCR** package
* R **ggplot2** package

You also need to install our package MCC-F1_curve.

## Execution instructions ##

# An example

Suppose you are evaluating a binary classification model. In your test set, you have the actual values and the predicted values. Let's use *actualVector* to represent the vector of actual values and *predictedVector* to represent the vector of predicted values.

First, run our package MCC-F1_curve.

Then you can use the function mccf1_calcu the corresponding MCC-F1 metric and the best threshold of the prediction, or the function mccf1_plot to plot the MCC-F1 curve.

`result <- mccf1_calcu(actualVector, predictedVector);
`result$metric;
`result$bestthreshold;

`mccf1_plot(actualVector, predictedVector)

## Contacts ##

* Repo owner or admin
* Other community or team contact
