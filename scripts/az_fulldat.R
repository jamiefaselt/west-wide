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

full.df <- st_read("data/tst/ww_alldist_arc.shp") %>%
  st_zm(., drop = TRUE, what = "ZM") %>%
  st_as_sf() %>%
  st_transform(., st_crs(deliv.results))


full.df <- full.df %>%
  select(c(Wld_m_y,Length,TARGET_FID,State,mean,pcntCls,Cst_yr_,brdg_rn,pa_mile,ch_mi,ID,AADT_1,geometry))

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








az.dist.results <- st_read("data/processed/west_all_dists.shp") %>%
  st_transform(., st_crs(deliv.results)) %>%
  filter(., State=="Arizona",  drop=TRUE)

perm <- rast("data/original/PercPerm202209_amod_90_5760 (1).tif") %>%
  project(deliv.results)

az.dist.results$ID <- 1:nrow(az.dist.results)


# bring in state specific aadt data
aadt <- st_read("data/original/aadt/az_aadt/AADT_s_2020.shp") %>%
  st_transform(., st_crs(az.dist.results))
aadt.drop <- aadt %>%
  select(c(AADT,geometry))

aadt.drop$ID<- 1:nrow(aadt.drop)
aadt

# make aadt layer a raster
# lets try the raster approach
aadt.vect <- vect(aadt)
az.results.vect <- vect(az.dist.results)

#aadt.rast <- rast("data/aadt/az_aadt/az_aadt_rast.tif")


aadt.rast <- rasterize(aadt, perm, field = "AADT", fun = "max")
#plot(aadt.rast)


results.extract <- extract(aadt.rast, az.results.vect, fun = "max")

az.dist.results$ID <- 1:nrow(az.dist.results)
joined <- left_join(az.dist.results, results.extract)


st_write(joined, "data/processed/az/az_full_df.shp")


# Layers for Maps ---------------------------------------------------------


full.df <- st_read("data/processed/az/az_full_df.shp")

colnames(full.df)

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
st_write(map1.dat, "data/processed/az/visuals/az_wvc_perm.shp")


# distances
perm50.pa.dist <- map1.dat %>%
  filter(pa_mile <=1)
st_write(perm50.pa.dist, "data/processed/az/visuals/az_padist_wvc_perm.shp")

perm50.ch.dist <- map1.dat %>%
  filter(ch_m<=.25)
st_write(perm50.ch.dist, "data/processed/az/visuals/az_chdist_wvc_perm.shp")

pa.dist.filter <- map1.dat %>%
  filter(pa_mile <=1) %>%
  filter(ch_m<=.25)
st_write(pa.dist.filter, "data/processed/az/visuals/az_pachdist_wvc_perm.shp")

# AADT
just.high.aadt <- full.df %>%
  filter(AADT>=15000)
st_write(just.high.aadt, "data/processed/az/visuals/az_only_aadt.shp")

high.aadt <- map1.dat %>%
  filter(AADT>=15000)
st_write(high.aadt, "data/processed/az/visuals/az_aadt_wvc_perm.shp")

high.aadt.50perm <- full.df %>%
  filter(., mean>perm.quint[[3]]) %>%
  filter(AADT>=15000)
st_write(high.aadt.50perm, "data/processed/az/visuals/az_aadt_perm50.shp")


bridge.filter <- high.aadt.50perm %>%
  filter(bridge==1)
st_write(bridge.filter, "data/processed/az/visuals/az_map3_aadtperm50_bridge.shp")

# cost filters for the thresholds filter the baseline threshold data to areas above "threshold costs"
# 12006 for fence without apron
# 18601 for fence with buried apron
# 40857 for fence with apron, jumpouts, and underpasses
# 51547 for fence with apron, jumpouts, over and under passes

fence.w.out <- map1.dat %>%
  filter(Cost_yr_mi>= 12006)
st_write(fence.w.out, "data/processed/az/visuals/az_econ_fence_wout.shp")

fence.w <- map1.dat %>%
  filter(Cost_yr_mi>=18601)
st_write(fence.w, "data/processed/az/visuals/az_econ_fence_with.shp")

fence.w.under <- map1.dat %>%
  filter(Cost_yr_mi>=40857)
st_write(fence.w.under, "data/processed/az/visuals/az_econ_under.shp")

fence.w.over <- map1.dat %>%
  filter(Cost_yr_mi>=51547)
st_write(fence.w.over, "data/processed/az/visuals/az_econ_over.shp")

# crash, conservation, cost
hottest <- map1.dat %>%
  filter(Cost_yr_mi>=40857) %>%
  filter(pa_mile <=1| ch_m<=.25)
st_write(hottest, "data/processed/az/visuals/az_map1_padist_econ.shp")
