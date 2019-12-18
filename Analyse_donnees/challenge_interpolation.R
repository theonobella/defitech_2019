# Dérive (laisser fonctionner dans temps)

setwd("~/SUPAGRO/3A/Decembre")

# Chargement des librairies et donnees ----
library(dplyr) # import et data management
library(leaflet)
require(sf)  
require(stars)
require(gstat) # idw
require(mapview) # comme leaflet

ndvi_sat <- read.csv("./Data_project/NDVI_satellite_prelevements.csv")

datacapteur <- read.csv("./Data_project/data_calibr.csv", sep = ";", dec = ",")
datacapteur <- as.data.frame(datacapteur)
longueur_onde <- as.numeric(substr(colnames(datacapteur)[4:21], 2,4))
datacapteur$NDVI <- (datacapteur[,18]-datacapteur[,13]) / (datacapteur[,18]+datacapteur[,13])

# Données 
mydata <- st_as_sf(datacapteur, coords = c("CoordX", "CoordY"))

crs.wgs84 <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
CRS.lambert93 <- CRS("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")

st_crs(mydata) <- crs.wgs84
mydata_lambert <- st_transform(mydata, CRS.lambert93)

chull <- mydata_lambert %>% st_union() %>% st_convex_hull()
mydata.points <- mydata_lambert %>% st_make_grid(n=100) %>% st_intersection(chull) %>% st_centroid()
mydata.grid<-mydata_lambert %>% st_make_grid(n=100) %>% st_intersection(chull)
mapview(mydata_lambert,zcol="NDVI")+mapview(mydata.grid, col.regions="red")


## interpolation distance inverse
obs_idw <- idw(NDVI ~ 1, locations = mydata_lambert, newdata=st_sf(mydata.points)) %>% 
  rename(NDVI = var1.pred)
st_geometry(obs_idw) <- st_geometry(mydata.grid)

mapview(obs_idw["NDVI"], zcol="NDVI",lwd=0,legend=FALSE) +
  mapview(mydata,zcol="NDVI")


## Variogramme et kriegeage
vargram <- variogram(NDVI ~ 1, data = mydata_lambert)
                     #boundaries = seq(0,60,7))#, alpha = c(122, 32))
plot(vargram)
fit_vargram <- fit.variogram(vargram, vgm(model = "Sph", nugget = 1))#, anis = c(122, 0.6)))
plot(vargram, fit_vargram)

NF.kriged = krige(NDVI ~ 1, locations = mydata_lambert,  #using ordinary kriging]
                  newdata = mydata.points, model = fit_vargram, nmax = 20) %>% 
  rename(NDVI = var1.pred)
plot(NF.kriged["NDVI"])

mapview(NF.kriged, zcol="NDVI",lwd=0,legend=FALSE) +
  mapview(mydata,zcol="NDVI")

## Co kriegeage
resist <- read.csv("./Data_project/Resistivite_prelevements_lam93.csv") %>% 
  left_join(select(ndvi_sat, ID, CoordX, CoordY), by = "ID") %>% 
  # rename(resist = voie_1) %>% 
  st_as_sf(coords = c("CoordX", "CoordY"))
st_crs(resist) <- crs.wgs84
resist <- st_transform(resist, CRS.lambert93)

NDVI.gs <- gstat(NULL,id = "NDVI", formula = NDVI ~ 1, data = mydata_lambert) # set = list(nocheck = 1),
NDVI.gs <- gstat(NDVI.gs, id = "resist", formula = Voie_1 ~ 1, data = resist) # set = list(nocheck = 1),

NDVI.vg <- variogram(NDVI.gs)
plot(NDVI.vg, main='Rainfall - Elevation Variograms')

NDVI.gs <- gstat(NDVI.gs, model = vgm("Sph", nugget = 2),# range = 30, psill=15000), 
                 fill.all=TRUE) # se

NDVI.fit <- fit.lmc(NDVI.vg, NDVI.gs, fit.lmc=TRUE) 
plot(NDVI.vg, model=NDVI.fit, 
     main="Fitted Variogram Models - Raw Data")




