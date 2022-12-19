# az filters for mapping

library(terra)
library(sf)
library(dplyr)

deliv.results <- st_read("data/original/WW_results_20220824_perm90_5760_ranked.shp")

az.df <- st_read("data/processed/az/az_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))

az.df <- az.df %>%
  select(c(Wld_m_y,Length,State,mean,pcntCls,Cst_yr_,brdg_rn,pa_mile,ch_mi,AADT,geometry)) # select colnames


# Layers for Maps ---------------------------------------------------------

# Baseline- 10% WVC, 50% connectivity -------------------------------------

perm.quint <- quantile(az.df$mean, probs =c(0,0.25,0.5,0.75,1))
perm.filt <- az.df %>%
  filter(., mean>perm.quint[[3]])

colnames(az.df)

wvc.drop <- az.df %>% # drop the zeros
  filter(., Wld_m_y>0)
wvc.quant <- quantile(wvc.drop$Wld_m_y, probs =c(0.25,0.5,0.75,.9))
wvc.filt <- az.df %>%
  filter(., Wld_m_y>wvc.quant[[4]])

map1.dat <- az.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(., Wld_m_y>wvc.quant[[4]])
st_write(map1.dat, "data/processed/az/visuals/az_wvc_perm.shp")

map1.dat.brdg <- az.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(., Wld_m_y>wvc.quant[[4]]) %>%
  filter(., brdg_rn<=35)
st_write(map1.dat.brdg, "data/processed/az/visuals/az_wvc_perm_brdg.shp")

# distances
pa.dist <- map1.dat %>%
  filter(pa_mile <=1)
st_write(pa.dist, "data/processed/az/visuals/az_padist_wvc_perm.shp")

ch.dist <- map1.dat %>%
  filter(ch_mi<=.25)
st_write(ch.dist, "data/processed/az/visuals/az_chdist_wvc_perm.shp")

pa.ch.dist.filter <- map1.dat %>%
  filter(pa_mile <=1) %>%
  filter(ch_mi<=.25)
st_write(pa.ch.dist.filter, "data/processed/az/visuals/az_chpadist_wvc_perm.shp")

pa.dist.filter.brdge <- map1.dat %>%
  filter(pa_mile <=1 |ch_mi<=.25 ) %>%
  filter(., brdg_rn<=35)
st_write(pa.dist.filter.brdge, "data/processed/az/visuals/az_chpadist_brdg_wvc_perm.shp")

# AADT
high.aadt <- map1.dat %>%
  filter(AADT>=15000)
st_write(high.aadt, "data/processed/az/visuals/az_highaadt_wvc_perm.shp")

high.aadt.50perm <- az.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(AADT>=15000)
st_write(high.aadt.50perm, "data/processed/az/visuals/az_highaadt_perm.shp")


bridge.aadt.filter <- high.aadt.50perm %>%
  filter(., brdg_rn<=35)
st_write(bridge.aadt.filter, "data/processed/az/visuals/az_highaadt_perm_brdg.shp")

# cost filters for the thresholds filter the baseline threshold data to areas above "threshold costs"
# 12006 for fence without apron
# 18601 for fence with buried apron
# 40857 for fence with apron, jumpouts, and underpasses
# 51547 for fence with apron, jumpouts, over and under passes


fence.w.under <- map1.dat %>%
  filter(Cst_yr_ >=40857)
st_write(fence.w.under, "data/processed/az/visuals/az_econ_under.shp")

fence.w.over <- map1.dat %>%
  filter(Cst_yr_ >=51547)
st_write(fence.w.over, "data/processed/az/visuals/az_econ_over.shp")

# crash, conservation, cost
hottest <- map1.dat %>%
  filter(Cst_yr_ >=40857) %>%
  filter(pa_mile <=1| ch_mi<=.25)
st_write(hottest, "data/processed/az/visuals/az_wvc_perm_padist_econunder.shp")

