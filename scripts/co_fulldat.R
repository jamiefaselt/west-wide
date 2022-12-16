# full data with either aadt and bridges
library(terra)
library(sf)
library(dplyr)


# aadt data ---------------------------------------------------------------

deliv.results <- st_read("data/original/WW_results_20220824_perm90_5760_ranked.shp")

states <- tigris::states()
co <- states %>% filter(., NAME=="Colorado", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))

co.dist.results <- st_read("data/processed/west_all_dists.shp") %>%
  st_transform(., st_crs(deliv.results)) %>%
  filter(., State=="Colorado",  drop=TRUE)

co.dist.results$ID <- 1:nrow(co.dist.results)


# bring in state specific aadt data
aadt <- st_read("data/original/aadt/co_aadt/Highways%3A_Traffic_Counts.shp") %>%
  st_transform(., st_crs(deliv.results))

aadt.rast <- rast("data/processed/co/co_aadt.tif")

# make aadt layer a raster
# lets try the raster approach
aadt.vect <- vect(aadt)
co.results.vect <- vect(co.dist.results)


aadt.rast <- rasterize(aadt, perm.co, field = "AADT", fun = "max")
plot(aadt.rast)

results.extract <- extract(aadt.rast, co.results.vect, fun = "max")

co.dist.results$ID <- 1:nrow(co.dist.results)
joined <- left_join(co.dist.results, results.extract)


st_write(joined, "data/processed/co/co_full_df.shp") # end here if no ungulate corridor data

