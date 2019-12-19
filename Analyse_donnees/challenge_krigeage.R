
require(sf)  
require(stars)
require(gstat) 

datacapteur <- read.csv("./Data_project/data_calibr.csv", sep = ";", dec = ",")
datacapteur$NDVI <- (datacapteur[,18]-datacapteur[,13]) / (datacapteur[,18]+datacapteur[,13])


krigeage <- function(datacapteur){
  
  mydata <- st_as_sf(datacapteur, coords = c("CoordX", "CoordY"))
  
  crs.wgs84 <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "
  CRS.lambert93 <- CRS("+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs ")
  
  st_crs(mydata) <- crs.wgs84
  mydata_lambert <- st_transform(mydata, CRS.lambert93)
  
  chull <- mydata_lambert %>% st_union() %>% st_convex_hull()
  mydata.points <- mydata_lambert %>% st_make_grid(n=100) %>% st_intersection(chull) %>% st_centroid()
  mydata.grid<-mydata_lambert %>% st_make_grid(n=100) %>% st_intersection(chull)
  
  vargram <- variogram(NDVI ~ 1, data = mydata_lambert)
  plot(vargram)
  fit_vargram <- fit.variogram(vargram, vgm(model = "Sph", nugget = 1))#, anis = c(122, 0.6)))
  graph <- plot(vargram, fit_vargram)
  
  NF.kriged = krige(NDVI ~ 1, locations = mydata_lambert,  #using ordinary kriging]
                    newdata = mydata.points, model = fit_vargram, nmax = 20) %>% 
    rename(NDVI = var1.pred)
  
  list(variogramme = graph, kriged = NF.kriged, data_lambert = mydata_lambert)
}

k <- krigeage(datacapteur)
k$variogramme
mapview(k$kriged, zcol="NDVI",lwd=0,legend=FALSE) +
  mapview(k$data_lambert, zcol="NDVI")
