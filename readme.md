# Using Rtools40 on Windows

Starting with R 4.0.0 (released April 2020), R for Windows uses a toolchain bundle called **rtools40**.

This version of Rtools includes gcc 8.3.0, and introduces a new build system based on [msys2](https://www.msys2.org/), which makes easier to build and maintain R itself as well as the system libraries needed by R packages on Windows. For more information about the latter, follow the links at the bottom of this document.

The current version of Rtools is maintained by Jeroen Ooms, [older versions](https://cran.r-project.org/bin/windows/Rtools/history.html) were put together by Prof. Brian Ripley and Duncan Murdoch. The best place for reporting bugs is via the [r-windows](https://github.com/r-windows) organization on GitHub.

## Installing Rtools40

Note that rtools40 is only needed build R packages with C/C++/Fortran code from source. By default, R for Windows installs the precompiled "binary packages" from CRAN, for which you do not need rtools!

To use rtools40, download the installer from CRAN:

 - On Windows 64-bit: [rtools40v2-x86_64.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40v2-x86_64.exe) (recommended: includes both i386 and x64 compilers)
 - On Windows 32-bit: [rtools40-i686.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40-i686.exe) (i386 compilers only)
 
__Note for RStudio users:__ please check you are using a recent version of RStudio (at least `1.2.5042`) to work with rtools40.


![](https://user-images.githubusercontent.com/216319/79896057-25fa8000-8408-11ea-9069-d01bfbd67786.png)


## Putting Rtools on the PATH

After installation is complete, you need to perform __one more step__ to be able to compile R packages: you need to put the location of the Rtools _make utilities_ (`bash`, `make`, etc) on the `PATH`. The easiest way to do so is create a text file `.Renviron` in your Documents folder which contains the following line:

```
PATH="${RTOOLS40_HOME}\usr\bin;${PATH}"
```

You can do this with a text editor, or you can even do it from R like so:

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

If this succeeds, you're good to go! See the links below to learn more about rtools40 and the Windows build infrastructure.


## Further Documentation

More documentation about using rtools40 for R users and package authors:

 - [Using pacman](https://github.com/r-windows/docs/blob/master/rtools40.md#readme): the new rtools package manager to build and install C/C++ system libraries.
 - [Installing R packages](https://github.com/r-windows/docs/blob/master/packages.md#readme): Some older R packages that need extra help to compile.
 - [FAQ](https://github.com/r-windows/docs/blob/master/faq.md#readme): Common questions about Rtools40 and R on Windows.

Advanced information about building R base and building system libraries:

 - [r-base](https://github.com/r-windows/r-base#readme): Scripts for building R for Windows using rtools40.
 - [rtools-packages](https://github.com/r-windows/rtools-packages#readme): Toolchains and static libraries for rtools40 (GCC 8+)
 - [rtools-backports](https://github.com/r-windows/rtools-backports#readme): Backported C/C++ libraries for the gcc-4.9.3 legacy toolchain (for R 3.3 - 3.6)
 - [rtools-installer](https://github.com/r-windows/rtools-installer#readme): Builds the rtools40 installer bundle.

