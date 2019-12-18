# Dérive (laisser fonctionner dans temps)

setwd("~/SUPAGRO/3A/Decembre")

# Chargement des librairies et donnees ----
library(dplyr) # import et data management
library(leaflet)
require(sp) 
require(gstat) 

ndvi_sat <- read.csv("./Data_project/NDVI_satellite_prelevements.csv")

datacapteur <- read.csv("./Data_project/data_calibr.csv", sep = ";", dec = ",")
datacapteur <- as.data.frame(datacapteur)
longueur_onde <- as.numeric(substr(colnames(datacapteur)[4:21], 2,4))


# NDVI
datacapteur$NDVI <- (datacapteur[,18]-datacapteur[,13]) / (datacapteur[,18]+datacapteur[,13])
hist(datacapteur$NDVI)

pal <- colorNumeric(palette = c("blue", "white", "red"),domain = datacapteur$NDVI)
# pal2 <- colorNumeric(palette = c("blue", "white", "red"),domain = ndvi_sat$rvalue_1)
m <- leaflet(datacapteur) %>% 
  addTiles() %>%
  # addCircleMarkers(~CoordX, ~CoordY, popup = ~as.character(ndvi_sat$rvalue_1), 
  #                  label = ~as.character(ndvi_sat$rvalue_1),
  #                  radius = 10,
  #                  color = ~pal2(ndvi_sat$rvalue_1),
  #                  stroke = FALSE, fillOpacity = 1) %>% 
  addCircleMarkers(~CoordX, ~CoordY, popup = ~as.character(NDVI),
                   label = ~as.character(NDVI),
                   radius = 5,
                   color = ~pal(NDVI),
                   stroke = FALSE, fillOpacity = 1) %>%
  # addLegend("bottomleft", pal2, ndvi_sat$rvalue_1) %>% 
  addLegend("bottomright", pal, datacapteur$NDVI)
m

ndvi_diff <- ndvi_sat$rvalue_1 - datacapteur$NDVI
pal_diff <- colorNumeric(palette = c("blue", "white", "red"),domain = ndvi_diff)
m <- leaflet(datacapteur) %>% 
  addTiles() %>%
  addCircleMarkers(~CoordX, ~CoordY, popup = ~as.character(ndvi_diff), 
                   label = ~as.character(ndvi_diff),
                   radius = 10,
                   color = ~pal_diff(ndvi_diff),
                   stroke = FALSE, fillOpacity = 0.6) %>%
  addLegend("bottomright", pal_diff, ndvi_diff)
m


library(rgdal)
## NDVI calculé
test_spacial <- datacapteur
coordinates(test_spacial) <- ~ CoordX + CoordY
proj4string(test_spacial) <- CRS("+init=epsg:4326") # Dire qu'on est en WGS 84
CRS.new <- CRS("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")
spatial_lambert <- spTransform(test_spacial, CRS.new)
# spatial_lambert@coords
vargram <- variogram(NDVI ~ 1, data = spatial_lambert, boundaries = seq(0,60,7), alpha = c(122, 32))
plot(vargram)
fit_vargram <- fit.variogram(vargram, vgm(model = "Sph", nugget = 1, anis = c(122, 0.6)))
plot(vargram, fit_vargram)


chull <- test_spacial %>% st_union() %>% st_convex_hull()
mydata.points <- mydata %>% st_make_grid(n=100) %>% st_intersection(chull) %>% st_centroid()
mydata.grid <- mydata %>% st_make_grid(n=100) %>% st_intersection(chull)
ndvi_krige <- krige(NDVI ~ 1, spatial_lambert, model = fit_vargram, locations = spatial_lambert)

require(mapview)
mapview(spatial_lambert, zcol = "NDVI")



## NDVI Sentinel
test_sentinel <- ndvi_sat
coordinates(test_sentinel) <- ~ CoordX + CoordY
proj4string(test_sentinel) <- CRS("+init=epsg:4326") # Dire qu'on est en WGS 84
CRS.new <- CRS("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")
spatial_lambert_sentinel <- spTransform(test_sentinel, CRS.new)
vargram_sentinel <- variogram(rvalue_1 ~ 1, data = spatial_lambert_sentinel)
plot(vargram_sentinel)
fit_vargram_sentinel <- fit.variogram(vargram_sentinel, vgm(model = "Sph", nugget = 1))
plot(vargram_sentinel, fit_vargram_sentinel)
