# Using Rtools4 on Windows

Starting with R 4.0.0 (released April 2020), R for Windows uses a toolchain bundle called **rtools4**. This version of Rtools is based on [msys2](https://www.msys2.org/), which makes easier to build and maintain R itself as well as the system libraries needed by R packages on Windows. The latest builds of rtools4 contain 3 toolchains:

 - `C:\rtools40\mingw32`: the 32-bit gcc-8-3.0 toolchain used as of R 4.0.0
 - `C:\rtools40\mingw64`: the 64-bit gcc-8-3.0 toolchain used as of R 4.0.0
 - `C:\rtools40\ucrt64`: a new 64-bit gcc-10.3.0 toolchain targeting ucrt

The [msys2 documentation](https://www.msys2.org/docs/environments/#msvcrt-vs-ucrt) gives an overview of the supported environments in msys2 and a comparison of MSVCRT and UCRT. The main difference between upstream msys2 and rtools4 is that our toolchains and libraries are configured for static linking, whereas upstream msys2 prefers dynamic linking. The references at the bottom of this document contain more information.

The current version of Rtools is maintained by Jeroen Ooms. [Older editions](https://cran.r-project.org/bin/windows/Rtools/history.html) were put together by Prof. Brian Ripley and Duncan Murdoch. The best place for reporting bugs is via the [r-windows](https://github.com/r-windows) organization on GitHub.

## Installing Rtools

Note that Rtools is only needed build R packages with C/C++/Fortran code from source. By default, R for Windows installs the precompiled "binary packages" from CRAN, for which you do not need Rtools.

To use rtools, download the installer from CRAN:

 - On Windows 64-bit: [rtools40v2-x86_64.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40v2-x86_64.exe) (includes both i386 and x64 compilers)
 - On Windows 32-bit: [rtools40-i686.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40-i686.exe) (i386 compilers only)
 
__Note for RStudio users:__ please check you are using a recent version of RStudio (at least `1.2.5042`) to work with rtools4.


![](https://user-images.githubusercontent.com/216319/79896057-25fa8000-8408-11ea-9069-d01bfbd67786.png)


## Putting Rtools on the PATH

After installation is complete, you need to perform __one more step__ to be able to compile R packages: you need to put the location of the Rtools _make utilities_ (`bash`, `make`, etc) on the `PATH`. The easiest way to do so is create a text file `.Renviron` in your Documents folder which contains the following line:

```
PATH="${RTOOLS40_HOME}\usr\bin;${PATH}"
```

You can do this with a text editor, or from R like so (note that in R code you need to escape backslashes):

```r
writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
```

Now restart R, and verify that `make` can be found, which should show the path to your Rtools installation.

```r
Sys.which("make")
## "C:\\rtools40\\usr\\bin\\make.exe"
```

If this works, you can try to install an R package from source:

```r
install.packages("jsonlite", type = "source")
```

If this succeeds, you're good to go! See the links below to learn more about rtools4 and the Windows build infrastructure.


## Further Documentation

More documentation about using rtools4 for R users and package authors:

 - [Using pacman](https://github.com/r-windows/docs/blob/master/rtools40.md#readme): the new rtools package manager to build and install C/C++ system libraries.
 - [Installing R packages](https://github.com/r-windows/docs/blob/master/packages.md#readme): Some older R packages that need extra help to compile.
 - [Testing packages with ucrt64](https://github.com/r-windows/docs/blob/master/ucrt.md#readme): Instructions for building and testing using the experimental UCRT toolchains.
 - [FAQ](https://github.com/r-windows/docs/blob/master/faq.md#readme): Common questions about Rtools40 and R on Windows.

Advanced information about building R base and building system libraries:

 - [r-base](https://github.com/r-windows/r-base#readme): Scripts for building R for Windows using rtools4.
 - [rtools-packages](https://github.com/r-windows/rtools-packages#readme): Toolchains and static libraries for rtools4 (GCC 8+)
 - [rtools-backports](https://github.com/r-windows/rtools-backports#readme): Backported C/C++ libraries for the gcc-4.9.3 legacy toolchain (for R 3.3 - 3.6)
 - [rtools-installer](https://github.com/r-windows/rtools-installer#readme): Builds the rtools4 installer bundle.
