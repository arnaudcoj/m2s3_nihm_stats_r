source("ex3.R")
pdf(file="test_ex4_box.pdf")
boxplot(v)
dev.off()
pdf(file="test_ex4_bar.pdf")
barplot(v)
dev.off()
