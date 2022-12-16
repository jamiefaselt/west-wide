library(terra)
library(sf)
library(dplyr)


deliv.results <- st_read("data/original/WW_results_20220824_perm90_5760_ranked.shp")

df <- st_read("data/processed/west_all_dists.shp") %>%
  st_transform(., st_crs(deliv.results))

st_crs(df)==st_crs(deliv.results)

perm <- rast("data/original/PercPerm202209_amod_90_5760 (1).tif") %>%
  project(deliv.results)

# bring in all the aadt rasters
az.aadt <- rast("data/processed/az/az_aadt.tif") %>%
  resample(., perm)
ca.aadt <- rast("data/processed/ca/ca_aadt.tif") %>%
  resample(., perm)
co.aadt <- rast("data/processed/co/co_aadt.tif") %>%
  resample(., perm)
id.aadt <- rast("data/processed/id/id_aadt.tif") %>%
  resample(., perm)
mt.aadt <- rast("data/processed/mt/mt_aadt.tif") %>%
  resample(., perm)
nm.aadt <- rast("data/processed/nm/nm_aadt.tif") %>%
  resample(., perm)
nv.aadt <- rast("data/processed/nv/nv_aadt.tif") %>%
  resample(., perm)
or.aadt <- rast("data/processed/or/or_aadt.tif") %>%
  resample(., perm)
ut.aadt <- rast("data/processed/ut/ut_aadt.tif") %>%
  resample(., perm)
wa.aadt <- rast("data/processed/wa/wa_aadt.tif") %>%
  resample(., perm)
wy.aadt <- rast("data/processed/wy/wy_aadt.tif") %>%
  resample(., perm)



aadt.rast.tst <- mosaic( nv.aadt, or.aadt, ut.aadt, wa.aadt, wy.aadt)

aadt.full.rast <- c(az.aadt, ca.aadt, co.aadt, id.aadt, mt.aadt, nm.aadt, nv.aadt, or.aadt, ut.aadt, wa.aadt, wy.aadt)

aadt.add <- (az.aadt + ca.aadt + co.aadt + id.aadt + mt.aadt + nm.aadt + nv.aadt + or.aadt + ut.aadt + wa.aadt + wy.aadt)

df.vect <- vect(df)

aadt.extract <- extract(aadt.rast, df.vect, fun = "max")

df$ID <- 1:nrow(df)
joined <- left_join(df, aadt.extract)
