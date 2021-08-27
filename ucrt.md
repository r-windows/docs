## UCRT background summary

R-core member Tomas Kalibera has started experimenting with building R to target the new [Windows Universal C Runtime (UCRT)](https://devblogs.microsoft.com/cppblog/introducing-the-universal-crt/). The main motivation is that recent updates to Windows 10 and Windows Server 2019 have made it possible to set the native encoding to UTF-8 on software built for UCRT.

Native UTF-8 on Windows makes it easier for R to support certain system functionality on machines with non-western languages, for example copy-pasting Chineese text to the R terminal, or opening file with a Chineese filename (though the latter already works well in most cases). Tomas as written a few of blog posts with more detailed information: https://developer.r-project.org/Blog/public/

On Windows systems with a European language or from before 2019 the UCRT probably makes no difference to the R user.


## Testing packages with ucrt64 using rtools4

Recent builds of rtools4 include a ucrt64 toolchain to test packages with Windows UCRT. To compile your own packages you need:

 - A recent version of ucrt3 R-devel.exe build: https://www.r-project.org/nosvn/winutf8/ucrt3/
 - A recent version of rtools4: https://cran.r-project.org/bin/windows/Rtools/

Unlike the regular R, the experimental R-devel builds look for gcc on the PATH, so you need to add e.g. `c:/rtools40/ucrt64/bin` to the PATH, in addition to the regular `make` tools from `c:/rtools40/usr/bin`.

A safe way to do this is to create a file `C:/Program Files/R/R-devel/etc/Renviron.site` containing:

```
PATH="${RTOOLS40_HOME}\ucrt64\bin;${RTOOLS40_HOME}\usr\bin;${PATH}"
```

Alternatively could also add this line to your regular `~/Renviron` file as described in the [rtools40 homepage](https://cran.r-project.org/bin/windows/Rtools/). Now restart R and try installing a package from source:

```r
install.packages("jsonlite", type = "source")
```

Also note that the experimental UCRT version of R has a hack to automatically download and apply custom [patches](https://www.r-project.org/nosvn/winutf8/ucrt3/patches/CRAN/) from Tomas Kalibera for certain packages. To disable this behavior you can add the following line to your Renviron file:

```
_R_INSTALL_TIME_PATCHES_=no
```


## Toolchain details

Building software for Windows UCRT requires a toolchain that is [configured to target the UCRT](https://github.com/r-windows/rtools-testing/blob/master/mingw-w64-headers-git/PKGBUILD#L55-L58), but other than that, everything works exactly the same. Binaries for UCRT and MSVCRT are typically incompatible, hence all system libraries and R packages need to be built with a UCRT toolchain to work in a UCRT version of R.  

Recent versions of msys2 and rtools40 include such a ucrt64 toolchain, as well as ucrt64 binaries for all system libraries. Pacman packages are prefixed with `mingw-w64-ucrt-x86_64` (as opposed to `mingw-w64-x86_64` for regular msvcrt mingw64 binaries). For example to install imagemagick:

```
pacman -Sy mingw-w64-ucrt-x86_64-imagemagick
```

Pacman installs the `ucrt-x86_64` toolchains and libaries are under `c:/rtools40/ucrt64/` or `c:/msys64/ucrt64/` so they do not conflict with the regular `x86_64` toolchains and libraries which are in `c:/rtools40/mingw64/` or `c:/msys64/mingw64/`.

Tomas has been using an alternative environment based on [mxe](https://mxe.cc/) to run his experiments, which you can read about in [this blog posts](https://developer.r-project.org/Blog/public/2021/03/12/windows/utf-8-toolchain-and-cran-package-checks/index.html). He has published a 6gb archive bundle of his local environment which uses cross-compilation from Linux. This toolchain is fully compatible and interchangable with the ucrt compilers from rtools4.
