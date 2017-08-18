library(ROCR)
library(ggplot2)
library(cowplot)

## real value
real_value_a = c(rep(1, 1000), rep(0, 10000))
real_value_b = c(rep(1, 10000), rep(0, 1000))
real_value_c = c(rep(1, 10000), rep(0, 10000))

## classifiers
# classifier A
predicted_value_A = c(rbeta(300, 12, 2), rbeta(700, 3, 4),rbeta(10000, 2, 3))
# classifier B
predicted_value_B = c(rbeta(1000, 4, 3), rbeta(10000, 2, 3))
# classifier C
predicted_value_C = c(rbeta(3000, 12, 2), rbeta(7000, 3, 4), rbeta(1000, 2, 3))
# classifier D
predicted_value_D = c(rbeta(10000, 4, 3), rbeta(1000, 2, 3))
# classifier E
predicted_value_E = c(rbeta(3000, 12, 2), rbeta(7000, 3, 4), rbeta(10000, 2, 3))
# classifier F
predicted_value_F = c(rbeta(10000, 4, 3), rbeta(10000, 2, 3))

output_A <- classification_result(real_value_a, predicted_value_A)
output_B <- classification_result(real_value_a, predicted_value_B)
output_C <- classification_result(real_value_b, predicted_value_C)
output_D <- classification_result(real_value_b, predicted_value_D)
output_E <- classification_result(real_value_c, predicted_value_E)
output_F <- classification_result(real_value_c, predicted_value_F)

## plot the first column
df_A <- data.frame(recall = output_A$recall, fpr = output_A$fpr, classifier = "A",
                 case = "(a)1000:10000")
df_B <- data.frame(recall = output_B$recall, fpr = output_B$fpr, classifier = "B",
                   case = "(a)1000:10000")
df_C <- data.frame(recall = output_C$recall, fpr = output_C$fpr, classifier = "C",
                   case = "(b)10000:1000")
df_D <- data.frame(recall = output_D$recall, fpr = output_D$fpr, classifier = "D", 
           case = "(b)10000:1000")
df_E <- data.frame(recall = output_E$recall, fpr = output_E$fpr, classifier = "E", 
                   case = "(c)10000:10000")
df_F <- data.frame(recall = output_F$recall, fpr = output_F$fpr, classifier = "F", 
                   case = "(c)10000:10000")

df <- rbind.data.frame(df_A, df_B, df_C, df_D, df_E, df_F)

first_col <- ggplot(df, aes(x= fpr, y= recall, group = classifier, color = classifier, ymin=0, ymax=1, xmin=0, xmax=1)) + 
  geom_point(size = 0.01) + 
  facet_wrap(~ case, ncol = 1) +
  labs(x = "FPR", y = "Recall", title = "ROC") +
  theme(legend.position="none", plot.title=element_text(hjust=0.5, size = 12), 
        axis.text = element_text(size = 8), axis.title = element_text(size = 10)) +
  coord_equal(ratio=1)+ 
  scale_color_manual(values=c("firebrick1", "gold", "forestgreen", "darkorange", "deepskyblue", "mediumpurple1"))

c("firebrick1", "gold", "forestgreen", "darkorange", "deepskyblue", "mediumpurple1")
  
## plot the second column
df_A <- data.frame(recall = output_A$recall, precision = output_A$precision, classifier = "A",
                   case = "(a)1000:10000")
df_B <- data.frame(recall = output_B$recall, precision = output_B$precision, classifier = "B",
                   case = "(a)1000:10000")
df_C <- data.frame(recall = output_C$recall, precision = output_C$precision, classifier = "C",
                   case = "(b)10000:1000")
df_D <- data.frame(recall = output_D$recall, precision = output_D$precision, classifier = "D", 
                   case = "(b)10000:1000")
df_E <- data.frame(recall = output_E$recall, precision = output_E$precision, classifier = "E", 
                   case = "(c)10000:10000")
df_F <- data.frame(recall = output_F$recall, precision = output_F$precision, classifier = "F", 
                   case = "(c)10000:10000")

df <- rbind.data.frame(df_A, df_B, df_C, df_D, df_E, df_F)

second_col <- ggplot(df, aes(x= recall, y= precision, group = classifier, color = classifier, ymin=0, ymax=1, xmin=0, xmax=1)) + 
  geom_point(size = 0.01) + 
  facet_wrap(~ case, ncol = 1) +
  labs(x = "Recall", y = "Precision", title = "PR") +
  theme(legend.position="none", plot.title=element_text(hjust=0.5, size = 12),
        axis.text = element_text(size = 8), axis.title = element_text(size = 10)) +
  coord_equal(ratio=1) 


## plot the third column
df_A <- data.frame( mcc.nor = output_A$mcc.nor, f = output_A$f, classifier = "A",
                   case = "(a)1000:10000")
df_B <- data.frame(mcc.nor = output_B$mcc.nor, f = output_B$f, classifier = "B",
                   case = "(a)1000:10000")
df_C <- data.frame(mcc.nor = output_C$mcc.nor, f = output_C$f, classifier = "C",
                   case = "(b)10000:1000")
df_D <- data.frame(mcc.nor = output_D$mcc.nor, f = output_D$f, classifier = "D", 
                   case = "(b)10000:1000")
df_E <- data.frame(mcc.nor = output_E$mcc.nor, f = output_E$f, classifier = "E", 
                   case = "(c)10000:10000")
df_F <- data.frame(mcc.nor = output_F$mcc.nor, f = output_F$f, classifier = "F", 
                   case = "(c)10000:10000")

df <- rbind.data.frame(df_A, df_B, df_C, df_D, df_E, df_F)

third_col <- ggplot(df, aes(x= f, y= mcc.nor, group = classifier, color = classifier, ymin=0, ymax=1, xmin=0, xmax=1)) + 
  geom_point(size = 0.01) + 
  facet_wrap(~ case, ncol = 1) +
  labs(x = "F1 score", y = "normalized MCC", title = "MCC-F1 score") +
  theme(plot.title=element_text(hjust=0.5, size =12), 
        axis.text = element_text(size = 8), axis.title = element_text(size = 10),
        legend.text=element_text(size=10), legend.title = element_text(size = 12)) +
  coord_equal(ratio=1)+
  guides(colour = guide_legend(override.aes = list(size=1.5)))

legend <- get_legend(third_col)
third_col <- third_col + theme(legend.position="none")

plot_grid(first_col, second_col, third_col, legend, ncol = 4, rel_widths = c(1, 1, 1, 0.4))

## beta distribution plot  
x <- seq(0,1, length=100)
hx <-dbeta(x, 12, 2)
plot(x, hx, type="l", xlab="x value", col="red",
     ylab="Density")
lines(x, dbeta(x, 3, 4), col="red")
text(0.4,2.1,"Beta(3, 4)")
text(0.9,5, "Beta(12,2)")
lines(x, dbeta(x, 4, 3), col="blue")
text(0.6, 2.1, "Beta(4, 3)")
lines(x, dbeta(x, 2, 3), col="grey")
text(0.36, 1.7, "Beta(2, 3)")
legend("topleft", inset=.05,
       c("positive cases: classifier A (C or E)", "positive cases: classifier B (D or F)", 
         "negative cases: all classifiers"), lwd=2, col= c("red", "blue", "grey"))


