# Using Rtools40 on Windows

Starting with R 4.0.0 (released April 2020), R for Windows uses a brand new toolchain bundle called **rtools40**.

This version of Rtools upgrades the mingw-w64 gcc toolchains to 8.3.0, and also introduces a new build system based on [msys2](https://www.msys2.org/), which makes easier to build and maintain R itself as well as the system libraries needed by R packages on Windows. For more information, please see the links in the bottom of this document.

**Older versions of Rtools:** This document talks about rtools40, the current version used for R 4.0.0 and newer. For previous versions of Rtools, please see [this page](https://cran.r-project.org/bin/windows/Rtools/history.html).

## Installing Rtools40

_Note that you only need rtools40 if you want to build R packages which contain C/C++/Fortran code. By default, R for Windows installs the precompiled "binary packages" from CRAN, for which you do not need rtools!_

To use rtools40, download the installer from CRAN:

 - On Windows 64-bit: [rtools40-x86_64.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40-x86_64.exe) (recommended: includes both i386 and x64 compilers)
 - On Windows 32-bit: [rtools40-i686.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40-i686.exe) (i386 compilers only)

![installer](https://user-images.githubusercontent.com/216319/79896057-25fa8000-8408-11ea-9069-d01bfbd67786.png)

After installation is complete, you need to perform __one more step__ to be able to compile R packages: you need to put the location of the Rtools _make utilities_ (`bash`, `make`, etc) on the `PATH`. The easiest way to do so is create a text file `.Renviron` in your Documents folder which contains the following line:

```
PATH="${RTOOLS40_HOME}\usr\bin;${PATH}"
```

You can do this with a text editor, or you can even do it from R like so:

```r
# Automatically put Rtools on the PATH
writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', con = "~/.Renviron")
```

Now restart R and verify that `make` can be found, which should show the path to your Rtools installation. If this works, you can try to install an R package from source:

```r
# Confirm that make.exe is on the PATH
Sys.which("make")
## "C:\\rtools40\\usr\\bin\\make.exe"

# Try to install a package
install.packages("jsonlite", type = "source")
```

If this succeeds, you're good to go! See the links below to learn more about rtools40 and the Windows build infrastructure.


## Additional Resources

Documentation about rtools40 for R users and package authors:

 - [rtools40](https://github.com/r-windows/docs/blob/master/rtools40.md#readme): Information about the new rtools build system.
 - [faq](https://github.com/r-windows/docs/blob/master/faq.md#readme): Common issues with Rtools40 and R on Windows.

 Other resources with information about building R and system libraries:

 - [r-base](https://github.com/r-windows/r-base#readme): Scripts for building R for Windows using rtools40.
 - [rtools-packages](https://github.com/r-windows/rtools-packages#readme): Toolchains and static libraries for rtools40 (GCC 8+)
 - [rtools-backports](https://github.com/r-windows/rtools-backports#readme): Backported C/C++ libraries for the gcc-4.9.3 legacy toolchain (for R 3.3 - 3.6)
 - [rtools-installer](https://github.com/r-windows/rtools-installer#readme): Builds the rtools40 installer bundle.

