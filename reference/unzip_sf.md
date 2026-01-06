# Helper function for loading in shapefiles that come zipped

Helper function for loading in shapefiles that come zipped

## Usage

``` r
unzip_sf(zip_url)
```

## Arguments

- zip_url:

  The url that the file you need to download and unzip is at

## Value

The temporary path the file is stored in, ready to pass to st_read() or
other
