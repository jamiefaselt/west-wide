# all states individual dataframes

# full data with either aadt and bridges
library(terra)
library(sf)
library(dplyr)


# aadt data ---------------------------------------------------------------

deliv.results <- st_read("data/original/WW_results_20220824_perm90_5760_ranked.shp")

states <- tigris::states()
az <- states %>% filter(., NAME=="Arizona", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
ca <- states %>% filter(., NAME=="California", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
co <- states %>% filter(., NAME=="Colorado", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
id <- states %>% filter(., NAME=="Idaho", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
mt <- states %>% filter(., NAME=="Montana", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
nm <- states %>% filter(., NAME=="New Mexico", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
nv <- states %>% filter(., NAME=="Nevada", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
or <- states %>% filter(., NAME=="Oregon", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
ut <- states %>% filter(., NAME=="Utah", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
wa <- states %>% filter(., NAME=="Washington", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))
wy <- states %>% filter(., NAME=="Wyoming", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))

full.df <- st_read("data/processed/west/west_all_dists.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))


az.df <- full.df %>%
  filter(., State=="Arizona",  drop=TRUE)
st_write(az.df, "data/processed/az/az_dist_brdge.shp")

ca.df <- full.df %>%
  filter(., State=="California",  drop=TRUE)
st_write(ca.df, "data/processed/ca/ca_dist_brdge.shp")

co.df <- full.df %>%
  filter(., State=="Colorado",  drop=TRUE)
st_write(co.df, "data/processed/co/co_dist_brdge.shp")

id.df <- full.df %>%
  filter(., State=="Idaho",  drop=TRUE)
st_write(id.df, "data/processed/id/id_dist_brdge.shp")

mt.df <- full.df %>%
  filter(., State=="Montana",  drop=TRUE)
st_write(mt.df, "data/processed/mt/mt_dist_brdge.shp")

nm.df <- full.df %>%
  filter(., State=="New Mexico",  drop=TRUE)
st_write(nm.df, "data/processed/nm/nm_dist_brdge.shp")

nv.df <- full.df %>%
  filter(., State=="Nevada",  drop=TRUE)
st_write(nv.df, "data/processed/nv/nv_dist_brdge.shp")

or.df <- full.df %>%
  filter(., State=="Oregon",  drop=TRUE)
st_write(or.df, "data/processed/or/or_dist_brdge.shp")

ut.df <- full.df %>%
  filter(., State=="Utah",  drop=TRUE)
st_write(ut.df, "data/processed/ut/ut_dist_brdge.shp")

wa.df <- full.df %>%
  filter(., State=="Washington",  drop=TRUE)
st_write(wa.df, "data/processed/wa/wa_dist_brdge.shp")

wy.df <- full.df %>%
  filter(., State=="Wyoming",  drop=TRUE)
st_write(wy.df, "data/processed/wy/wy_dist_brdge.shp")
