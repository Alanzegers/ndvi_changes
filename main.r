### Alan Zegers & Stijn Wijdeven
### Teamname*
### January 2016

### NDVI change surroundings Wageningen

### load library
library(rgdal)
library(raster)

## load R Function
source('R/NDVI_Calc.R')

### get/set WD
getwd()
#set WD 
#setwd('/home/user/R_scripts/NDVI_changes')

### doanload data 
download.file(url = 'https://www.dropbox.com/s/i1ylsft80ox6a32/LC81970242014109-SC20141230042441.tar.gz?dl=0', destfile = 'data/LC81970242014109-SC20141230042441.tar.gz', method = 'wget')
#2014
download.file(url = 'https://www.dropbox.com/s/akb9oyye3ee92h3/LT51980241990098-SC20150107121947.tar.gz?dl=0', destfile = 'data/LT51980241990098-SC20150107121947.tar.gz', method = 'wget')
#1990
untar('data/LC81970242014109-SC20141230042441.tar.gz', exdir = 'data/LC81970242014109-SC20141230042441')
untar('data/LT51980241990098-SC20150107121947.tar.gz', exdir = 'data/LT51980241990098-SC20150107121947')

### list the files
l8 <- list.files('data/LC81970242014109-SC20141230042441/', pattern = glob2rx('*.tif'), full.names = TRUE)
l5 <- list.files('data/LT51980241990098-SC20150107121947/', pattern = glob2rx('*.tif'), full.names = TRUE)
#files listed
#l8
#l5

###stack the needed files 
ls8 <-stack(l8[c(1,5,6)]) 
ls5 <-stack(l5[c(1,6,7)])
#stacked files
#ls8

### clouds
cloud8 <- ls8[[1]]
cloud5 <- ls5[[1]]

ls8 <- dropLayer(ls8, 1)
ls5 <- dropLayer(ls5, 1)

ls8[cloud8 !=0] <- NA
ls5[cloud5 !=0] <- NA
#plot cloudcorrected bands
plot(ls8)
plot(ls5)

###NDVI
NDVI8 <- overlay(x=ls8[[1]],y=ls8[[2]] ,fun=CalcNDVI)
NDVI5 <- overlay(x=ls5[[1]],y=ls5[[2]] ,fun=CalcNDVI)
#plot ndvi
plot(NDVI8)
plot(NDVI5)

### difference 2014-1990
NDVI_change <- NDVI8-NDVI5
plot(NDVI_change)

###  projection
NDVI_change_projection <- projectRaster(NDVI_change, crs='+proj=longlat')
plot(NDVI_change_projection)

### FINAL PRODUCT ###
writeRaster(NDVI_change_projection, 'output/NDVI_change_Wageningen.tif')

