library("reshape")
library("ez")

# Chargement des donnees
data = read.table("data.txt", header=TRUE, sep=",")

# On ne garde que ce qui nous interesse
filteredData = subset(data, (Err==0), select = c(Participant, Block, Technique,
                      A, W, density, Time))

# Aggregation des donnees pour ne conserver qu’une valeur par condition
attach(filteredData)
aggdata = aggregate(filteredData$Time, by=list(Participant,Block,Technique,W, density),
                    FUN=mean)
detach(filteredData)

# Reecriture des noms de colonnes
colnames(aggdata) = c("Participant","Block","Technique","W", "density", "Time")

# Conversion des donnees au format long
data.long = melt(aggdata, id = c("Participant","Block","Technique","W","density","Time"))

# On specifie les variables independantes
data.long$Block = factor(data.long$Block)
data.long$Technique = factor(data.long$Technique)
data.long$W = factor(data.long$W)
data.long$density = factor(data.long$density)

# L’ANOVA:
print(ezANOVA(data.long, dv=.(Time), wid=.(Participant), within=.(Technique,W,density)))

# Analyse post-hoc avec ajustement de Bonferroni
attach(data.long)
print(pairwise.t.test(Time, interaction(Technique), p.adj = "bonf"))
print(pairwise.t.test(Time, interaction(Technique, density), p.adj = "bonf"))
detach(data.long)

#q10
calcul_temps_moyen = function(dataframe, dens, technique) {
  participants=subset(dataframe,Err==0 & Technique==technique & density==dens)
  return(mean(participants[,"Time"]))
}

calcul_temps_moyen_par_densite = function(dataframe, techniques, density) {
  return(sapply(techniques, calcul_temps_moyen, dataframe=dataframe, dens=density))
}

techniques=unique(data$Technique)
densities=unique(data$density)

temps_moyens = sapply(densities, calcul_temps_moyen_par_densite, dataframe=data, techniques=techniques)

png(file="ex6.png")
barplot(temps_moyens, names.arg=densities, main="Temps moyen pour chaque technique en fonction de la densité", xlab="Densité", ylab="Temps moyen pour chaque technique", legend=techniques, xlim=c(0,30), beside=TRUE)
dev.off()

#sans SemPoint
data_sans_semPoint=subset(data, Technique!="SemPoint")
techniques_sans_semPoint=unique(data_sans_semPoint$Technique)

temps_moyens_sans_semPoint = sapply(densities, calcul_temps_moyen_par_densite, dataframe=data_sans_semPoint, techniques=techniques_sans_semPoint)

png(file="ex6_sans_semPoint.png")
barplot(temps_moyens_sans_semPoint, names.arg=densities, main="Temps moyen pour chaque technique en fonction de la densité", xlab="Densité", ylab="Temps moyen pour chaque technique", xlim=c(0,24), legend=techniques_sans_semPoint, beside=TRUE)
dev.off()
