##### az Hotspot
# in this script I azlculate the distance to protected areas, critiazl habitat, extract values for AADT and identify areas where corridors intersect with road segments
# then I filter to the top 50% for habitat permeability, and rank them as high, medium, and low?


# Distance Workflow ---------------------------------------------------------------


library(tigris)
library(ggplot2)
library(tidyverse)
library(sf)
library(sp)
library(raster)
library(terra)
library(dplyr)
library(rgdal)
library(gdalUtilities)
ensure_multipolygons <- function(X) {
  tmp1 <- tempfile(fileext = ".gpkg")
  tmp2 <- tempfile(fileext = ".gpkg")
  st_write(X, tmp1)
  ogr2ogr(tmp1, tmp2, f = "GPKG", nlt = "MULTIPOLYGON")
  Y <- st_read(tmp2)
  st_sf(st_drop_geometry(X), geom = st_geometry(Y))
}
library(measurements)
library(units)
library(reshape)
library(reshape2)



# PA Distance -------------------------------------------------------------

# bring in and match data
pas <- st_read("data/padus_clip/PADUS3_Clip.shp") %>% # cropped and dropped iazalid geometries in arcpro due to computational issues in r
  ensure_multipolygons(.) %>% 
  st_make_valid(.)


pas <-  pas %>% # filtering out tribl, marine protected area mpa, watershed management distrci
  filter(.,  Mang_Type != "TRIB") %>% 
  filter(., Loc_Ds != "WMD") %>% 
  filter(., Des_Tp != "TRIBL") %>% 
  filter(., Des_Tp != "MPA") 

# bring in the results dataframe 
deliv.results <- st_read("/Users/Jamie Faselt/Box/Science/1_Science Program/Active Projects/West-wide study/Westwide_Data/Deliverable 202209-20221027T195246Z-002/Deliverable 202209/WW_results_20220824_perm90_5760_ranked.shp") %>% 
  st_transform(., st_crs(pas))  %>% 
  st_make_valid(.)


states <- tigris::states()
az <- states %>% filter(., NAME=="Arizona", drop=TRUE) %>% 
  st_transform(crs=st_crs(pas))



# rename and crop to study area
poly1 <- deliv.results %>%  # filter to just the state for road segments
  filter(., State=="Arizona",  drop=TRUE)

poly2.pas <-pas %>% # filter to a buffer above our distance threshold around the full state in azse the closest is outside of the state
  st_crop(., st_buffer(az, 3000))


# create an index of the nearest feature (solution found on stackoverflow and checked with lengthier way to azlc all distances)
index <- st_nearest_feature(x = poly1, y = poly2.pas)

# slice based on the index - 
poly2.pas <- poly2.pas %>% slice(index)

# azlculate distance between polygons
poly_dist.pas <- st_distance(x = poly1, y= poly2.pas, by_element = TRUE)

# add the distance azlculations to the fire polygons
poly1$pa_meter <- poly_dist.pas

# add a mile column
poly1.pa.dist <- poly1 %>% mutate(pa_mile = conv_unit(poly1$pa_meter, "m", "mi"))

st_write(poly1.pa.dist, "data/processed/az/intermediate/az_pa_dist.shp")


# Dist azlc for crit hab --------------------------------------------------
crithab <- st_read("data/crit_hab/CRITHAB_POLY.shp") %>% 
  st_make_valid() %>% 
  st_transform(., st_crs(pas)) 

crithab.line <- st_read("data/crit_hab/CRITHAB_LINE.shp") %>% 
  st_make_valid() %>% 
  st_transform(., st_crs(pas)) 

crithab.join <- bind_rows(crithab, crithab.line)

# rename and crop to study area
poly1 <- poly1.pa.dist # bring the dataframe with the pa.distance 


poly2.crithab <-crithab.join %>% 
  st_crop(., st_buffer(az, 3000))


# create an index of the nearest feature
index <- st_nearest_feature(x = poly1, y = poly2.crithab)

# slice based on the index - 
poly2.crithab <- poly2.crithab %>% slice(index)

# azlculate distance between polygons
poly_dist.crithab <- st_distance(x = poly1, y= poly2.crithab, by_element = TRUE)

# add the distance azlculations to the fire polygons
poly1$ch_m <- poly_dist.crithab

# add a mile column
poly1.dist <- poly1 %>% mutate(ch_mi = conv_unit(poly1$ch_m, "m", "mi"))

st_write(poly1.dist, "data/processed/az/intermediate/az_all_dists.shp")




