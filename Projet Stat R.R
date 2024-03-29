#Projet 
getwd()    #Where we are working
#setwd("C:/Users/marcv/OneDrive/Bureau/Projet Stat")   #where we want to work

library(stringr)
library(plotrix)
library(car)

tableau=read.csv("healthy_lifestyle_city_2021.csv")# modifier le chemin pour ouvrir le fichier

#Probl�matique : Quelles sont les facteurs influents sur le bonheur d'une population au sein d'une ville ?


#On simplifie le nom des variables

sunshine<-tableau$Sunshine.hours.City.
life<-tableau$Life.expectancy.years...Country.
pollution<-tableau$Pollution.Index.score...City.
happiness<-tableau$Happiness.levels.Country.
takeOut<-tableau$Number.of.take.out.places.City.
continent<-tableau$Continent

#on va cr�er deux nouvelles variables gr�ce � la librairie stringr qui va permettre d'avoir des donn�es num�riques exploitables

obesity=as.numeric(str_replace_all(tableau$Obesity.levels.Country.,"%",""))
cost=as.numeric(str_replace_all(tableau$Cost.of.a.bottle.of.water.City.,"£",""))

#On visualise la r�partition des continents (donn�es qualitatives) avec des diagrammes ciculaires et un diagramme � b�tons 

barplotContinet<-barplot(table(continent),main="Continent")#ranger
pieContinent<-pie(table(continent),main="Continent")#ranger
pieContinent3D<-pie3D(table(continent),main="Continent 3D",labels = c("Africa","Asia","Europe","North America","Oceania","South America"))


#on visualise nos donn�es quantitatives avec des histogrammes et la fonction summary()

histLife<-hist(life,col="red",main="R�partition de l'esp�rance de vie",xlab="Esp�rance de vie en ann�e",ylab="Fr�quence")
summary(life) 
histSunshine<-hist(sunshine,col="yellow",main="R�partition du temps d'ensoleillement",xlab="Heures par an",ylab = "Fr�quence")
summary(sunshine) 
histHappiness<-hist(happiness,col="darkgreen",main="R�partition du niveau de bonheur",xlab = "Niveau de bonheur",ylab = "Fr�quence")
summary(happiness)
histPollution<-hist(pollution,col="grey",main="R�partition de la pollution",xlab = "Pollution de l'air en %",ylab = "Fr�quence")
summary(pollution)
histTakeOutPlaces<-hist(takeOut,col="lightgreen",main="R�partiton du nombre de restaurants � emporter",xlab="Nombre de restaurants � emporter ",ylab="Fr�quence")
summary(takeOut)
histObesity<-hist(obesity,col="brown",main="R�partition du pourcentage d'ob�sit�", xlab="Ob�sit� de la population en %",ylab="Fr�quence")
summary(obesity)
hiscost<-hist(cost,col="blue",main="R�partition du prix d'une bouteille d'eau",xlab="Prix en livres",ylab="Fr�quence")
summary(cost) 

#on visualise avec des bo�tes � moustaches

boxplot(life,pollution,obesity,names = c("Esp�rance de vie","Pollution de l'air en %","Pourcentage d'ob�sit�"))
boxplot(happiness,cost,names=c("Niveau de bonheur","Prix d'une bouteille d'eau"))
boxplot(takeOut,sunshine,names = c("Nombre de restaurants � emporter","Temps d'ensoleillement")) 
 
#Avec des diagramme � b�tons et des bo�tes � moustaches on visualise la r�partition des 3 variables en fonction du continent 


df<-data.frame(continent,sunshine,cost,happiness)
boxplot(df$sunshine~df$continent,col="lightyellow",xlab="",ylab="Ensoleillement en heure par ann�e",main="Temps d'ensoleillement par continent")
barplot(c(3333,2354.727,1850.889,2499.5,2564.444,2264),col="lightyellow",ylab="Ensoleillement en heure par ann�e",names=c("Afrique","Asie","Europe","Oc�anie","Am�rique du Nord","Am�rique du Sud"),main="Temps d'ensoleillement par continent")
boxplot(df$happiness~df$continent,col="lightpink",ylab="Bonheur",main="Niveau de bonheur par continent")
barplot(c(4.48,5.49,6.91,7.22,6.95,6.17),col="lightpink",ylab="Bonheur",names=c("Afrique","Asie","Europe","Oc�anie","Am�rique du Nord","Am�rique du Sud"),main="Niveau de bonheur par continent")
boxplot(df$cost~df$continent,col="lightblue",ylab="Prix en �",main="Prix de la bouteille d'eau par continent")
barplot(c(0.375,0.564,1.639,1.525,1.233,0.505),col="lightblue",ylab="Prix en �",names=c("Afrique","Asie","Europe","Oc�anie","Am�rique du Nord","Am�rique du Sud"),main="Prix de la bouteille d'eau par continent")



#A refaire, bizarre le boxplot

#On fait un test de Shapiro pour voir si nos donn�es sont normalement distribu�es

shapiro.test(sunshine)#   p-value = 0.01931
shapiro.test(life)#p-value = 1.401e-06| Apr�s modification de valeurs : p-value = 7.23e-05
shapiro.test(happiness)#p-value = 0.002118 | Apr�s modification de valeurs : p-value = 0.005066
shapiro.test(obesity)#p-value = 0.001401 | Apr�s modification de valeurs : p-value = 0.003214
shapiro.test(takeOut)#p-value = 2.245e-07 | Apr�s modification de valeurs : p-value = 8.206e-05

shapiro.test(cost)#p-value = 0.07345| Apr�s modification de valeurs : p-value = 0.08574
shapiro.test(pollution)#p-value = 0.1946



#Nous allons maitenant chercher des cor�lations lin�aire � l'aide de la fonction scatterplot() de la librairie car ainsi que les coefficients gr�ce � lm() 
#La fonction cor.test() nous donnes le coefficient de corr�lation LINEAIRE
#Dans certains cas on retire les valeurs extr�mes

scatterplot(cost,happiness,main="Niveau de bonheur en fonction du prix de la bouteille d'eau",xlab="Prix d'une bouteille d'eau",ylab = "Niveau de bonheur" ) #on prends ca
cor.test(cost,happiness)
lm(happiness~cost)$coefficients
cost[37]<-NA
happiness[26]<-NA
scatterplot(cost,happiness,main="Niveau de bonheur en fonction du prix de la bouteille d'eau",xlab="Prix d'une bouteille d'eau",ylab = "Niveau de bonheur" ) #on prends ca
cor.test(cost,happiness)
lm(happiness~cost)$coefficients

scatterplot(life,happiness,main="Niveau de bonheur en fonction de l'esp�rance de vie",xlab="Esp�rance de vie",ylab="Niveau de bonheur" ) #on prends ca
cor.test(life,happiness)
lm(happiness~life)$coefficients
life[39]<-NA
scatterplot(life,happiness,main="Niveau de bonheur en fonction de l'esp�rance de vie",xlab="Esp�rance de vie",ylab="Niveau de bonheur" ) #on prends ca
cor.test(life,happiness)
lm(happiness~life)$coefficients

scatterplot(takeOut,happiness,main="Niveau de bonheur en fonction du nombre de restaurant � emporter",xlab="Nombre de restaurant � emporter",ylab = "Niveau de bonheur" ) #on prends ca
cor.test(takeOut,happiness)
lm(takeOut~happiness)$coefficient 
takeOut[38]<-NA
takeOut[29]<-NA
takeOut[35]<-NA
scatterplot(takeOut,happiness,main="Niveau de bonheur en fonction du nombre de restaurant � emporter",xlab="Nombre de restaurant � emporter",ylab = "Niveau de bonheur" ) #on prends ca
cor.test(takeOut,happiness)
lm(takeOut~happiness)$coefficient 

scatterplot(sunshine,happiness,main="Niveau de bonheur en fonction du temps d'ensoleillement",xlab="Temps d'ensoleillement",ylab="Niveau de bonheur" ) #on prends ca
cor.test(sunshine,happiness)
lm(sunshine~happiness)$coefficient 

scatterplot(obesity,happiness,main="Niveau de bonheur en fonction de l'ob�sit�",xlab="Ob�sit�",ylab="Niveau de bonheur" ) #on prends ca
cor.test(happiness,obesity)
lm(obesity~happiness)$coefficient 
obesity[7]<-NA
obesity[26]<-NA
obesity[29]<-NA
scatterplot(obesity,happiness,main="Niveau de bonheur en fonction de l'ob�sit�",xlab="Ob�sit�",ylab="Niveau de bonheur" ) #on prends ca
cor.test(happiness,obesity)
lm(obesity~happiness)$coefficient 

scatterplot(pollution,happiness,main="Niveau de bonheur en fonction de la pollution",xlab="Taux de pollution",ylab="Niveau de bonheur" ) #on prends ca
cor.test(pollution,happiness)
lm(happiness~pollution)$coefficient 

scatterplot(pollution,cost,main="Prix de la bouteille d'eau en fonction de la pollution",ylab="Pris de la bouteille d'eau",xlab="Taux de pollution") #on prends ca
cor.test(cost,pollution)
lm(cost~pollution)$coefficient 


#Autre type de corr�lation :


      #logarithmique 
happiness[26]<-3.57
cost[37]<-3.20
Estimate = lm(happiness~cost) #lm(y ~ x)
logEstimate = lm(happiness ~ log(cost))
logEstimate$coefficients
plot(cost,predict(Estimate),type='l',col='blue',main="Niveau de bonheur en fonction du prix de la bouteille d'eau",xlab="Prix d'une bouteille d'eau",ylab = "Niveau de bonheur")
lines(smooth.spline(cost,predict(logEstimate)),col='red')
points(cost,happiness)


      #Relation de Spearman 

life[39]<-56.3        #On remet les valeurs extremes
happiness[26]<-3.57

scatterplot(life,happiness,main="Niveau de bonheur en fonction de l'esp�rance de vie",xlab="Esp�rance de vie",ylab="Niveau de bonheur" ) #on prends ca
cor.test(life,happiness,method = "spearman")
lm(happiness~life)$coefficients
life[39]<-NA      
happiness[26]<-NA
scatterplot(life,happiness,main="Niveau de bonheur en fonction de l'esp�rance de vie",xlab="Esp�rance de vie",ylab="Niveau de bonheur" ) #on prends ca
cor.test(life,happiness,method = "spearman")
lm(happiness~life)$coefficients


