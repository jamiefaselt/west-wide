# full dataframe
library(terra)
library(sf)
library(dplyr)

deliv.results <- st_read("data/original/WW_results_20220824_perm90_5760_ranked.shp")

az.df <- st_read("data/processed/az/az_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(az.df)
az.filt <- az.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT, geometry))
st_write(az.filt, "data/processed/az/visuals/az_full_df.shp")

ca.df <- st_read("data/processed/ca/ca_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(ca.df)
ca.filt <- ca.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT, geometry))
st_write(ca.filt, "data/processed/ca/visuals/ca_full_df.shp")

co.df <- st_read("data/processed/co/co_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(co.df)
co.filt <- co.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT, geometry))
st_write(co.filt, "data/processed/co/visuals/co_full_df.shp")

id.df <- st_read("data/processed/id/id_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(id.df)
id.filt <- id.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT, geometry))
st_write(id.filt, "data/processed/id/visuals/id_full_df.shp")

mt.df <- st_read("data/processed/mt/mt_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(mt.df)
mt.filt <- mt.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, TYC_AADT, geometry))
mt.filt <- mt.filt %>%
  rename(., AADT = TYC_AADT)
st_write(mt.filt, "data/processed/mt/visuals/mt_full_df.shp")

nm.df <- st_read("data/processed/nm/nm_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(nm.df)
nm.filt <- nm.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT, geometry))
st_write(nm.filt, "data/processed/nm/visuals/nm_full_df.shp")

nv.df <- st_read("data/processed/nv/nv_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(nv.df)
nv.filt <- nv.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT, geometry))
st_write(nv.filt, "data/processed/nv/visuals/nv_full_df.shp")


or.df <- st_read("data/processed/or/or_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(or.df)
or.filt <- or.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT, geometry))
st_write(or.filt, "data/processed/or/visuals/or_full_df.shp")

ut.df <- st_read("data/processed/ut/ut_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(ut.df)
ut.filt <- ut.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT2020, geometry))
ut.filt <- ut.filt %>%
  rename(., AADT = AADT2020)
st_write(ut.filt, "data/processed/ut/visuals/ut_full_df.shp")

wa.df <- st_read("data/processed/wa/wa_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(wa.df)
wa.filt <- wa.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT, geometry))
st_write(wa.filt, "data/processed/wa/visuals/wa_full_df.shp")

wy.df <- st_read("data/processed/wy/wy_full_df.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))
colnames(wy.df)
wy.filt <- wy.df %>%
  select(c(Wld_m_y, Length, State, mean, pcntCls, Cst_yr_, brdg_rn, pa_mile, ch_mi, AADT, geometry))
st_write(wy.filt, "data/processed/wy/visuals/wy_full_df.shp")


west.df <- bind_rows(az.filt, ca.filt, co.filt, id.filt, mt.filt, nm.filt, nv.filt, or.filt, ut.filt, wa.filt, wy.filt)
st_write(west.df, "data/processed/west/visuals/west_full_df.shp")



# filters -----------------------------------------------------------------


# Baseline- 10% WVC, 50% connectivity -------------------------------------

perm.quint <- quantile(west.df$mean, probs =c(0,0.25,0.5,0.75,1))
perm.filt <- west.df %>%
  filter(., mean>perm.quint[[3]])

colnames(west.df)

wvc.drop <- west.df %>% # drop the zeros
  filter(., Wld_m_y>0)
wvc.quant <- quantile(wvc.drop$Wld_m_y, probs =c(0.25,0.5,0.75,.9))
wvc.filt <- west.df %>%
  filter(., Wld_m_y>wvc.quant[[4]])

map1.dat <- west.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(., Wld_m_y>wvc.quant[[4]])
st_write(map1.dat, "data/processed/west/visuals/west_wvc_perm.shp")

map1.dat.brdg <- west.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(., Wld_m_y>wvc.quant[[4]]) %>%
  filter(., brdg_rn<=35)
st_write(map1.dat.brdg, "data/processed/west/visuals/west_wvc_perm_brdg.shp")

# distances
pa.dist <- map1.dat %>%
  filter(pa_mile <=1)
st_write(pa.dist, "data/processed/west/visuals/west_padist_wvc_perm.shp")

ch.dist <- map1.dat %>%
  filter(ch_mi<=.25)
st_write(ch.dist, "data/processed/west/visuals/west_chdist_wvc_perm.shp")

pa.ch.dist.filter <- map1.dat %>%
  filter(pa_mile <=1) %>%
  filter(ch_mi<=.25)
st_write(pa.ch.dist.filter, "data/processed/west/visuals/west_chpadist_wvc_perm.shp")

pa.dist.filter.brdge <- map1.dat %>%
  filter(pa_mile <=1 |ch_mi<=.25 ) %>%
  filter(., brdg_rn<=35)
st_write(pa.dist.filter.brdge, "data/processed/west/visuals/west_chpadist_brdg_wvc_perm.shp")

# AADT
high.aadt <- map1.dat %>%
  filter(AADT>=15000)
st_write(high.aadt, "data/processed/west/visuals/west_highaadt_wvc_perm.shp")

high.aadt.50perm <- west.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(AADT>=15000)
st_write(high.aadt.50perm, "data/processed/west/visuals/west_highaadt_perm.shp")


bridge.aadt.filter <- high.aadt.50perm %>%
  filter(., brdg_rn<=35)
st_write(bridge.aadt.filter, "data/processed/west/visuals/west_highaadt_perm_brdg.shp")

# cost filters for the thresholds filter the baseline threshold data to areas above "threshold costs"
# 12006 for fence without apron
# 18601 for fence with buried apron
# 40857 for fence with apron, jumpouts, and underpasses
# 51547 for fence with apron, jumpouts, over and under passes


fence.w.under <- map1.dat %>%
  filter(Cst_yr_ >=40857)
st_write(fence.w.under, "data/processed/west/visuals/west_econ_under.shp")

fence.w.over <- map1.dat %>%
  filter(Cst_yr_ >=51547)
st_write(fence.w.over, "data/processed/west/visuals/west_econ_over.shp")

fence.w.under.brdge <- map1.dat %>%
  filter(Cst_yr_ >=40857) %>%
  filter(., brdg_rn<=35)
st_write(fence.w.under.brdge, "data/processed/west/visuals/west_econ_under_brdge.shp")

# crash, conservation, cost
hottest <- map1.dat %>%
  filter(Cst_yr_ >=40857) %>%
  filter(pa_mile <=1| ch_mi<=.25)
st_write(hottest, "data/processed/west/visuals/west_wvc_perm_padist_econunder.shp")


