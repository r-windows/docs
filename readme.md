# R for Windows and Rtools40

As of version 4.0 (April 2020) R for Windows uses a new toolchain called Rtools40. This version upgrades the mingw-w64 gcc toolchains to 8.3.0, and also introduces a new build system based on [msys2](https://www.msys2.org/), which makes easier to build R for Windows, as well as external system libraries needed by R packages.

## Installing Rtools40

> Note that you only need rtools40 if you want to build R packages from source that contain C/C++/Fortran code. By default, R for Windows installs the precompiled _binary packages_ from CRAN, for which you do not need rtools!

To use rtools40, download the installer from CRAN:

 - On Windows 64-bit: [rtools40-x86_64.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40-x86_64.exe) (recommended: includes both i386 and x64 compilers)
 - On Windows 32-bit: [rtools40-i686.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40-i686.exe) (i386 compilers only)

![installer](https://user-images.githubusercontent.com/216319/79896057-25fa8000-8408-11ea-9069-d01bfbd67786.png)

After the installation is completed, you need to perform __one more step__ to be able to compile R packages: you need to put the location of the rtools _make utilities_ (`bash`, `make`, etc) on the `PATH`. The easiest way to do so is create a text file `.Renviron` in your Documents folder which contains the following line:

```
PATH="${RTOOLS40_HOME}\usr\bin;${PATH}"
```

You can do this with a text editor, or you can even do it from R like so:

```r
# Automatically put Rtools on the PATH
writeLines('PATH="${RTOOLS40_HOME}\\usr\\bin;${PATH}"', file = "~/.Renviron")
```

Now restart R and verify that `make` can be found, which should show the path to your rtools installion. If that works you can try to install a package from source:

```r
# Confirm that make.exe is on the PATH
Sys.which("make")
## "C:\\rtools40\\usr\\bin\\make.exe"

# Try to install a package
install.packages("jsonlite", type = "source")
```

If this succeeds, you're good! See the links below to learn more about rtools40.


## Additional Resources


Documentation for the new build infrastructure based on Rtools40.


 - [rtools40](rtools40.md): some info about the new rtools build system
 - [faq](faq.md) common problems with R on Windows

 Other resources for more advanced users:

 - [r-base](https://github.com/r-windows/r-base#readme): Scripts for building R for Windows using Rtools40.
 - [rtools-packages](https://github.com/r-windows/rtools-packages#readme): Toolchains and static libraries for Rtools 4.0 (GCC 8+)
 - [rtools-backports](https://github.com/r-windows/rtools-backports): Backported C/C++ libraries for the gcc-4.9.3 legacy toolchain (for R 3.3 - 3.6)
 - [rtools-installer](https://github.com/r-windows/rtools-installer): Builds the Rtools40 installer bundle.
