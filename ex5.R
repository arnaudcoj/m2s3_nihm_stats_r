library("gplots")

data = read.table("data.txt", header=TRUE, sep=",")

#q3
calcul_temps_moyen = function(dataframe, technique) {
  #participants=subset(dataframe,Technique==technique)
  #q6
  participants=subset(dataframe,Err==0 & Technique==technique)
  return(mean(participants[,"Time"]))
}


#q4
techniques = unique(data$Technique)
temps_moyens = sapply(techniques, calcul_temps_moyen, dataframe=data)

#q5
#barplot(temps_moyens, names.arg=techniques)

#q7
ci = function(vector) {
    return(1.96 * sd(vector) / sqrt(length(vector)))
}

calcul_intervalle_confiance = function(dataframe, technique) {
  participants=subset(dataframe,Err==0 & Technique==technique)
  return(ci(participants[,"Time"]))
}

intervalles_confiance = sapply(techniques, calcul_intervalle_confiance, dataframe=data)

temps_moyens_low = temps_moyens - (intervalles_confiance / 2)
temps_moyens_upp = temps_moyens + (intervalles_confiance / 2)

#q8
png(file="ex5.png")
barplot2(temps_moyens, names.arg=techniques, plot.ci=TRUE, main="Temps moyen pour chaque technique", xlab="Technique", ylab="Temps Moyen" ,ci.l=temps_moyens_low, ci.u=temps_moyens_upp)
dev.off()
