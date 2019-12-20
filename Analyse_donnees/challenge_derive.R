# Dérive (laisser fonctionner dans temps)

setwd("~/SUPAGRO/3A/Decembre")

# Chargement des librairies et donnees ----
library(dplyr) # import et data management
library(tidyr) # nettoyage de dataset
library(hyperSpec) # Gestion des données de spectre
library(prospectr) # prétraitement
require(leaflet)
library(fda.usc) # pour deriver
require(pls) # pour msc
require(FactoMineR)
require(factoextra)

datacapteur <- read.csv("./Data_project/data_calibr.csv", sep = ";", dec = ",")
datacapteur <- as.data.frame(datacapteur)
longueur_onde <- as.numeric(substr(colnames(datacapteur)[4:21], 2,4))

# Visualisation longueurs d'ondes non corrigees
pal <- colorNumeric(palette = c("blue", "red"), domain = c(1:85))
matplot(longueur_onde, t(datacapteur[,(4:21)]), type="l",
        main=("Capteur données brutes"),xlab="",ylab="Spectral data",
        col = pal(c(1:85)))

# correction des donnees msc
matplot(longueur_onde, t(msc(as.matrix(datacapteur[,(4:21)]))), type="l",
        main=("Capteur correction MSC"),xlab="",ylab="Spectral data",
        col = pal(c(1:85)))

# derives grace points autour
# m = ordre derive, w = window size, s = ~smooth
gsd1 <- prospectr::gapDer(X = datacapteur[,(4:21)], m = 1, w = 3, s = 1)
longueur_onde2 <- as.numeric(substr(colnames(gsd1), 2,4))
matplot(longueur_onde2, t(gsd1), type="l",
        main=("Capteur correction Gap"),xlab="",ylab="Spectral data",
        col = pal(c(1:85)))

# lissage polynome grace algo Savitsky Golay + derive
# p = ordre polynome, w = window size, m = ordre derive
sg <- prospectr::savitzkyGolay(datacapteur[,(4:21)], p = 2, w = 3, m = 2)
longueur_onde3 <- as.numeric(substr(colnames(sg), 2,4))
matplot(longueur_onde3, t(sg), type="l",
        main=("Capteur correction SG"),xlab="",ylab="Spectral data",
        col = pal(c(1:85)), xaxt = "n")
axis(1, at=longueur_onde3, labels=longueur_onde3)

# derivation grace bspline, centre norme aussi
datacapteur2<-as.matrix(datacapteur[,4:21])
datacapteur2<-fdata(datacapteur2)
capteur.d1 <- fdata.deriv(datacapteur2, nderiv = 1, method = "bspline", nbasis = 10)
matable <- as.data.frame(capteur.d1$data)
moy.ligne <- apply(matable,1,mean)
matable <- sweep(matable,1,moy.ligne,FUN="-")
sd.ligne <- apply(matable,1,sd)
matable <- sweep(matable,1,sd.ligne,FUN="/")
colnames(matable) <- paste("L", longueur_onde, sep="")

matplot(longueur_onde, t(matable), type="l",
        main=("Capteur correction SG"),xlab="",ylab="Spectral data",
        col = pal(c(1:85)), xaxt = "n")
axis(1, at=longueur_onde, labels=longueur_onde)

acp_before <- PCA(datacapteur, quanti.sup = c(1:3,22), graph = F) #sup 22 n'y sera plus bientot
acp_res <- PCA(matable, graph = F)
acp_res2 <- PCA(sg, graph = F)
fviz_pca_var(acp_before)
fviz_pca_var(acp_res)
fviz_pca_var(acp_res2)
# fviz_pca_ind(acp_before)
# fviz_pca_ind(acp_res)
View(acp_res$var$coord)

cah_before <- HCPC(acp_before)
cah_res <- HCPC(acp_res)

## Variogramme 1ere composante ACP
spacial_acp <- data.frame(acp1 = acp_res$ind$coord[,1], X = datacapteur$CoordX, Y = datacapteur$CoordY)
coordinates(spacial_acp) <- ~ X + Y
proj4string(spacial_acp) <- CRS("+init=epsg:4326") # Dire qu'on est en WGS 84
CRS.new <- CRS("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")
spacial_lambert_acp <- spTransform(spacial_acp, CRS.new)
vargram_acp <- variogram(acp1 ~ 1, data = spacial_lambert_acp)
plot(vargram_acp)
fit_vargram_acp <- fit.variogram(vargram_acp, vgm(model = "Sph", nugget = 1))
plot(vargram_acp, fit_vargram_acp)

