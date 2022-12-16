# full data with either aadt and bridges
library(terra)
library(sf)
library(dplyr)
library(measurements)
library(units)
library(reshape)
library(reshape2)


# Bridge Data ---------------------------------------------------------------

pas <-  st_read("data/original/padus/pa_vect_nobia_crop.shp")

deliv.results <- st_read("data/original/WW_results_20220824_perm90_5760_ranked.shp")%>%
  st_transform(., st_crs(pas))

west <- st_read("data/west/western_11_states.shp") %>%
  st_transform(., st_crs(pas))

st_crs(deliv.results)==st_crs(west) # true

bridge <- st_read("data/original/bridge/National_Bridge_Inventory_DS_nbi_June_15_2022.shp") %>%
  st_transform(., st_crs(pas))
st_write(bridge.crop, "data/original/bridge/bridge_crop.shp")

bridge.crop <- st_crop(bridge, west)

# calculate distance to nearest bridge...
poly1 <- deliv.results  #

poly2.brdge <-bridge.crop


# create an index of the nearest feature (solution found on stackoverflow and checked with lengthier way to calc all distances)
index <- st_nearest_feature(x = poly1, y = poly2.brdge)

# slice based on the index -
poly2.brdge <- poly2.brdge %>% slice(index)

# calculate distance between polygons
poly_dist.brdge <- st_distance(x = poly1, y= poly2.brdge, by_element = TRUE)

# add the distance calculations to the  results dataframe
poly1$brdge_meter <- poly_dist.brdge

# add a mile column
poly1.brdge.dist <- poly1 %>% mutate(brdge_mile = conv_unit(poly1$brdge_rnd, "m", "mi"))

st_write(poly1.brdge.dist, "data/processed/west_bridge_dist.shp")

poly1$brdge_rnd <- round(poly1$brdge_meter, digits = 1)



# PA Distances ------------------------------------------------------------


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


# Dist calc for crit hab --------------------------------------------------
crithab <- st_read("data/original/crithab/CRITHAB_POLY.shp") %>%
  st_make_valid() %>%
  st_transform(., st_crs(pas))

crithab.line <- st_read("data/original/crithab/CRITHAB_LINE.shp") %>%
  st_make_valid() %>%
  st_transform(., st_crs(pas))

crithab.join <- bind_rows(crithab, crithab.line)
# rename and crop to study area
poly1 <- st_read("data/processed/west_pa_dists.shp") # bring the dataframe with the pa.distance


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





