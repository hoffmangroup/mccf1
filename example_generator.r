# function call to generate the dataset
# actual value vector
actual <- c(rep(1, 1000), rep(0, 10000))
# simulate predicted value vector, using beta distribution
predicted <- c(rbeta(300, 12, 2), rbeta(700, 3, 4),rbeta(10000, 2, 3))

# function call to get the best threshold and MCC-F1 metric
# use mccf1_calcu function to calculate best threshold and MCC-F1 metric
result <- mccf1_calcu(actual, predicted)
result$bestthreshold
result$metric
# change the fold when calculating MCC-F1 metric
mccf1_calcu(actual, predicted, fold = 50)

# function call to generate and plot the MCC-F1 score curve.
# use mccf1_plot to plot the corresponding MCC-F1 curve 
mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)")
# save the pdf file of the image to a specified folder 
mccf1_plot(actual, predicted, .title="the MCC-F1 score curve (example)", 
           .curveFileName="/users/ccao/Pictures")

