
# in this script I calculate the distance to protected areas, and critical habitat


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



pas <-  st_read("data/original/padus/pa_vect_nobia_crop.shp")

# bring in the results dataframe

deliv.results <- st_read("data/original/WW_results_20220824_perm90_5760_ranked.shp") %>%
  st_transform(., st_crs(pas))  %>%
  st_make_valid(.)


west <- st_read("data/west/western_11_states.shp") %>%
  st_transform(., st_crs(pas))


# rename and crop to study area
poly1 <- poly1.brdge.dist  #

poly2.pas <-pas %>%
  st_crop(., st_buffer(west, 3000))


# create an index of the nearest feature (solution found on stackoverflow and checked with lengthier way to calc all distances)
index <- st_nearest_feature(x = poly1, y = poly2.pas)

# slice based on the index -
poly2.pas <- poly2.pas %>% slice(index)

# calculate distance between polygons
poly_dist.pas <- st_distance(x = poly1, y= poly2.pas, by_element = TRUE)

# add the distance calculations to the fire polygons
poly1$pa_meter <- poly_dist.pas

# add a mile column
poly1.pa.dist <- poly1 %>% mutate(pa_mile = conv_unit(poly1$pa_meter, "m", "mi"))

st_write(poly1.pa.dist, "data/processed/west_pa_dists.shp")


# Dist calc for crit hab -------------------------------------------------- # need to add lines~
crithab <- st_read("data/original/crit_hab/CRITHAB_POLY.shp") %>%
  st_make_valid() %>%
  st_transform(., st_crs(pas))

crithab.line <- st_read("data/original/crit_hab/CRITHAB_LINE.shp") %>%
  st_make_valid() %>%
  st_transform(., st_crs(pas))

crithab.join <- bind_rows(crithab, crithab.line)
# rename and crop to study area
poly1 <- poly1.pa.dist # bring the dataframe with the pa.distance


poly2.crithab <-crithab.join %>%
  st_crop(., st_buffer(west, 3000))


# create an index of the nearest feature
index <- st_nearest_feature(x = poly1, y = poly2.crithab)

# slice based on the index -
poly2.crithab <- poly2.crithab %>% slice(index)

# calculate distance between polygons
poly_dist.crithab <- st_distance(x = poly1, y= poly2.crithab, by_element = TRUE)

# add the distance calculations to the fire polygons
poly1$ch_m <- poly_dist.crithab

# add a mile column
poly1.dist <- poly1 %>% mutate(ch_mi = conv_unit(poly1$ch_m, "m", "mi"))

st_write(poly1.dist, "data/processed/west_all_dists.shp")

abbreved <- base::abbreviate(colnames(poly1.dist)) # and here is another source of potential error -- working on it

ch.dist <- poly1.dist[, !(colnames(poly1.dist) %in% c("pa_mile","pa_meter"))]
st_write(ch.dist, "data/processed/west_ch_dist.shp")
