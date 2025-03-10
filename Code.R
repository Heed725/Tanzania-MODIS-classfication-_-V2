# Load necessary libraries
library(rgeoboundaries)
library(sf)
library(terra)
library(ggplot2)
library(dplyr)

# Read the boundary shapefile for Tanzania
map_boundary <- st_read("C:/Tanzania.shp")

# Read the land cover raster data
IGBP_raster <- rast("C:/Tanzania.tif")

# Transform raster to WGS84
IGBP_raster <- project(IGBP_raster, "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")

# Crop raster to match Tanzania boundary
IGBP_raster <- mask(IGBP_raster, vect(map_boundary))

# Convert raster to dataframe for ggplot
IGBP_df <- as.data.frame(IGBP_raster, xy = TRUE, na.rm = TRUE) %>%
  rename(Land_Cover = names(IGBP_raster)) %>%
  mutate(Land_Cover = as.factor(round(Land_Cover)))

# Assign land cover class labels
levels(IGBP_df$Land_Cover) <- c(
  "Evergreen Needleleaf Forest",
  "Evergreen Broadleaf Forest",
  "Deciduous Needleleaf Forest",
  "Deciduous Broadleaf Forest",
  "Mixed Forests",
  "Closed Shrublands",
  "Open Shrublands",
  "Woody Savannas",
  "Savannas",
  "Grasslands",
  "Permanent Wetlands",
  "Croplands",
  "Urban and Built-Up",
  "Cropland/Natural Vegetation Mosaic",
  "Snow and Ice",
  "Barren or Sparsely Vegetated",
  "Water Bodies"
)

# Define custom colors for land cover types
landcover_colors <- c(
  "Evergreen Needleleaf Forest"    = "#005000",
  "Evergreen Broadleaf Forest"     = "#008000",
  "Deciduous Needleleaf Forest"    = "#008C00",
  "Deciduous Broadleaf Forest"     = "#00A000",
  "Mixed Forests"                  = "#70C070",
  "Closed Shrublands"              = "#A57070",
  "Open Shrublands"                = "#E8C080",
  "Woody Savannas"                 = "#A0A000",
  "Savannas"                       = "#C8DC70",
  "Grasslands"                     = "#E8C000",
  "Permanent Wetlands"             = "#0058D0",
  "Croplands"                      = "#FFFF00",
  "Urban and Built-Up"             = "#FF0000",
  "Cropland/Natural Vegetation Mosaic" = "#A09050",
  "Snow and Ice"                   = "#F0D8D8",
  "Barren or Sparsely Vegetated"   = "#D8D8D8",
  "Water Bodies"                   = "#B0D0E0"
)

# Plot land cover map
ggplot() + 
  geom_raster(data = IGBP_df, aes(x = x, y = y, fill = Land_Cover)) +
  geom_sf(data = map_boundary, inherit.aes = FALSE, fill = NA, color = "black") +
  scale_fill_manual(name = "Land Cover Type", values = landcover_colors) +
  labs(title = "Land Cover Classification in Tanzania",
       subtitle = "Based on MODIS Data (2019)",
       x = "Longitude",
       y = "Latitude") +
  theme_minimal()



