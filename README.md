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

Secondly, run our code file MCC-F1Curve.R.

Then you can use the function mccf1_calcu the corresponding MCC-F1 metric and the best threshold of the prediction.

	result <- mccf1_calcu(actual, predicted)

	result$mccf1_metric

	result$bestThreshold
	
You can change the fold when calculating MCC-F1 metric.
	
    mccf1_calcu(actual, predicted, fold = 50)
  
You can also use mccf1_plot to plot the corresponding MCC-F1 curve. 

	mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)")

You can save the pdf file of the image to a specified folder. 

    mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)", .curveFileName="/users/ccao/Pictures/mcc-f1_example")

## Contacts ##

The MCC-F1Curve package was developed by Chang Cao, Davide Chicco, and Michael M. Hoffman at the Hoffman Lab of the Princess Margaret Cancer Centre (Toronto, Ontario, Canada). Questions should be
addressed to Michael M. Hoffman <michael.hoffman@utoronto.ca>.
