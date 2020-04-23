# Package fixes

Some CRAN packages have hardcoded configurations for winbuilder and need some extra help. Here we list how to install these using rtools40, until the problem is fixed in the package itself.

## XML

You need the libxml2 system library:

```sh
pacman -S mingw-w64-{i686,x86_64}-libxml2
```

The XML package wants to have an `LIB_XML` variable:

```r
Sys.setenv(LIB_XML = "$(MINGW_PREFIX)")
install.packages("XML", type= "source")
```

A backward compatible fix for the package author would be to set a default `LIB_XML ?= $(MINGW_PREFIX)` in Makevars.win


## RCurl

You need the curl system library:

```sh
pacman -S mingw-w64-{i686,x86_64}-curl
```

Now you can install RCurl:

```r
install.packages("RCurl", type= "source")
```

This spits out a lot of warnings that you can ignore (The package author should set `-DSTRICT_R_HEADERS` in Makevars.win).


