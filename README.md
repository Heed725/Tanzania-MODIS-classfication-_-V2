# Land Cover Classification in Tanzania using R

This tutorial guides you through the process of visualizing land cover classification in Tanzania using R with spatial data processing and visualization libraries.

## Prerequisites
Ensure you have the following R packages installed:

```r
install.packages(c("rgeoboundaries", "sf", "terra", "ggplot2", "dplyr"))
```

Load the required libraries:

```r
library(rgeoboundaries)
library(sf)
library(terra)
library(ggplot2)
library(dplyr)
```

## Step 1: Load Spatial Data

### Load Tanzania Boundary Shapefile

The vector data is obtained from [GADM](https://gadm.org) at ADM 1 level.

```r
map_boundary <- st_read("C:/.../Tanzania.shp")
```
Ensure that the file path is correct and the shapefile is available.

### Load Land Cover Raster Data

The raster data is downloaded from [NASA AppEEARS](https://appeears.earthdatacloud.nasa.gov/).

```r
IGBP_raster <- rast("C:/.../Tanzania.tif")
```
Again, verify that the file exists at the specified location.

## Step 2: Data Preprocessing

### Transform Raster to WGS84 Projection

```r
IGBP_raster <- project(IGBP_raster, "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
```

### Crop Raster to Tanzania Boundary

```r
IGBP_raster <- mask(IGBP_raster, vect(map_boundary))
```

### Convert Raster to Data Frame for ggplot

```r
IGBP_df <- as.data.frame(IGBP_raster, xy = TRUE, na.rm = TRUE) %>%
  rename(Land_Cover = names(IGBP_raster)) %>%
  mutate(Land_Cover = as.factor(round(Land_Cover)))
```

### Assign Land Cover Class Labels

```r
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
```

## Step 3: Define Custom Colors

```r
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
```

## Step 4: Plot the Land Cover Map

```r
ggplot() +
  geom_raster(data = IGBP_df, aes(x = x, y = y, fill = Land_Cover)) +
  geom_sf(data = map_boundary, inherit.aes = FALSE, fill = NA, color = "black") +
  scale_fill_manual(name = "Land Cover Type", values = landcover_colors) +
  labs(title = "Land Cover Classification in Tanzania",
       subtitle = "Based on MODIS Data (2019)",
       x = "Longitude",
       y = "Latitude") +
  theme_minimal()
```

## Additional Considerations

- **Performance Optimization:** If the raster file is too large, consider downsampling it:

  ```r
  IGBP_raster <- aggregate(IGBP_raster, fact = 2, fun = modal)
  ```

- **Legend Placement:** You may adjust the legend position to improve readability:

  ```r
  theme(legend.position = "bottom")
  ```

## Final Image

![Land Cover Map](https://github.com/user-attachments/assets/8a621682-082c-4dd1-820c-6b7630496d2c)

This concludes the tutorial on land cover classification in Tanzania using R. 🎉 Happy coding!

## Credit
- Vector Data: [GADM](https://gadm.org) (ADM 1 Level)
- Raster Data: [NASA AppEEARS](https://appeears.earthdatacloud.nasa.gov/)
- Spatial Data Processing: [R Spatial Data](https://rspatialdata.github.io/index.html)

