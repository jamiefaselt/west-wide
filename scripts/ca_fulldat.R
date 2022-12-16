# full data with either aadt and bridges
library(terra)
library(sf)
library(dplyr)


# aadt data ---------------------------------------------------------------
deliv.results <- st_read("data/original/WW_results_20220824_perm90_5760_ranked.shp")

states <- tigris::states()
ca <- states %>% filter(., NAME=="California", drop=TRUE) %>%
  st_transform(crs=st_crs(deliv.results))

ca.dist.results <- st_read("data/processed/west_all_dists.shp") %>%
  st_transform(., st_crs(deliv.results)) %>%
  filter(., State=="California",  drop=TRUE)

# bring in state specific aadt data
aadt <- st_read("data/aadt/ca_aadt/HWY_Traffic_Volumes_AADT.shp") %>%
  st_transform(., st_crs(deliv.results))

aadt$AADT <-
  coalesce(aadt$BACK_AADT, aadt$AHEAD_AADT)

st_write(aadt, "data/aadt/ca_aadt/aadt_update.shp")

# make aadt layer a raster
# lets try the raster approach
aadt.vect <- vect(aadt)
ca.results.vect <- vect(ca.dist.results)

aadt.rast <- rast("data/original/aadt/ca_aadt/ca_aadt_rast.tif")

aadt.rast <- rasterize(aadt, perm.ca, field = "AADT", fun = "max")
plot(aadt.rast)

results.extract <- extract(aadt.rast, ca.results.vect, fun = "max")

ca.dist.results$ID <- 1:nrow(ca.dist.results)
joined <- left_join(ca.dist.results, results.extract)


st_write(joined, "data/processed/ca/ca_full_df.shp") # end here if no ungulate corridor data


#renaming for clarity
# new name = old name)


# Layers for Maps ---------------------------------------------------------


full.df <- st_read("data/processed/ca/ca_full_df.shp")



# Baseline- 10% WVC, 50% connectivity -------------------------------------

perm.quint <- quantile(full.df$mean, probs =c(0,0.25,0.5,0.75,1))
perm.filt <- full.df %>%
  filter(., mean>perm.quint[[3]])

colnames(full.df)

wvc.drop <- full.df %>% # drop the zeros
  filter(., Wld_m_y>0)
wvc.quant <- quantile(wvc.drop$Wld_m_y, probs =c(0.25,0.5,0.75,.9))
wvc.filt <- full.df %>%
  filter(., Wld_m_y>wvc.quant[[4]])

map1.dat <- full.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(., Wld_m_y>wvc.quant[[4]])
st_write(map1.dat, "data/processed/ca/visuals/ca_wvc_perm.shp")

map1.dat.brdg <- full.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(., Wld_m_y>wvc.quant[[4]]) %>%
  filter(., brdg_rn<=35)
st_write(map1.dat.brdg, "data/processed/ca/visuals/ca_wvc_perm_brdg.shp")

# distances
pa.dist <- map1.dat %>%
  filter(pa_mile <=1)
st_write(pa.dist, "data/processed/ca/visuals/ca_padist_wvc_perm.shp")

ch.dist <- map1.dat %>%
  filter(ch_m<=.25)
st_write(ch.dist, "data/processed/ca/visuals/ca_chdist_wvc_perm.shp")

pa.ch.dist.filter <- map1.dat %>%
  filter(pa_mile <=1) %>%
  filter(ch_m<=.25)
st_write(pa.ch.dist.filter, "data/processed/ca/visuals/ca_chpadist_wvc_perm.shp")

pa.dist.filter.brdge <- map1.dat %>%
  filter(pa_mile <=1 |ch_m<=.25 ) %>%
  filter(., brdg_rn<=35)
st_write(pa.dist.filter.brdge, "data/processed/ca/visuals/ca_chpadist_brdg_wvc_perm.shp")

# AADT
high.aadt <- map1.dat %>%
  filter(c_dt_rs>=15000)
st_write(high.aadt, "data/processed/ca/visuals/ca_highaadt_wvc_perm.shp")

high.aadt.50perm <- full.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(c_dt_rs>=15000)
st_write(high.aadt.50perm, "data/processed/ca/visuals/ca_highaadt_perm.shp")


bridge.aadt.filter <- high.aadt.50perm %>%
  filter(., brdg_rn<=35)
st_write(bridge.aadt.filter, "data/processed/ca/visuals/ca_highaadt_perm_brdg.shp")

# cost filters for the thresholds filter the baseline threshold data to areas above "threshold costs"
# 12006 for fence without apron
# 18601 for fence with buried apron
# 40857 for fence with apron, jumpouts, and underpasses
# 51547 for fence with apron, jumpouts, over and under passes


fence.w.under <- map1.dat %>%
  filter(Cst_yr_ >=40857)
st_write(fence.w.under, "data/processed/ca/visuals/ca_econ_under.shp")

fence.w.over <- map1.dat %>%
  filter(Cst_yr_ >=51547)
st_write(fence.w.over, "data/processed/ca/visuals/ca_econ_over.shp")

# crash, conservation, cost
hottest <- map1.dat %>%
  filter(Cst_yr_ >=40857) %>%
  filter(pa_mile <=1| ch_m<=.25)
st_write(hottest, "data/processed/ca/visuals/ca_wvc_perm_padist_econunder.shp")
