# R on Windows FAQ

## When do I need Rtools ?



## What is Rtools

Rtools is the toolchain bundle that is used to build R for Windows and R packages that contain compiled code. You can download it from [CRAN](https://cran.r-project.org/bin/windows/Rtools/). There are currently two version of Rtools:

 - Rtools35 (gcc 4.9.3): used by R versions 3.3 - 3.6. This is probably what you need.
 - Rtools40 (gcc 8.3.0): experimental next generation, see [documentation](https://cran.r-project.org/bin/windows/testing/rtools40.html)

It is recommended to install Rtools in the default location which is `C:/rtools40/` for Rtools40. If you install it in another location, make sure there are no spaces or diacritics in the path name, as that might not work for all packages.


## Where R looks for the compiler

The most important thing is that the correct version of `make` is on the path. __It is not needed to put gcc on the path!__

```r
# Check your path
Sys.getenv('PATH')

# Check if make is on the path
Sys.which('make')
```




Once `make` is available, R will lookup make variables via `R CMD config` to find the path to gcc and other tools. To test this manually in R, let's lookup the path to the C++11 compiler:

```r
R <- file.path(R.home('bin'), 'R')
system2(R, c("CMD", "config", "CXX11"))
# C:/Rtools/mingw_64/bin/g++
```

This system is the same on all operating systems (Windows, MacOS, Linux).


## How to test if the compiler is available in R?

The script below looks up the compiler via `R CMD config` and then tests that it works. The same script can be used on any platform (not just windows).

```r
test_compiler <- function(){
  testprog <- '#include <iostream>\nint main() {std::cout << "Hello World!";}'
  make <- Sys.which('make')
  if(!nchar(make))
    stop("Did not find 'make' on the PATH")
  R <- file.path(R.home('bin'), 'R')
  CXX <- system2(R, c("CMD", "config", "CXX"), stdout = TRUE)
  if(!nchar(CXX))
    stop("Failed to lookup 'R CMD config CXX'")
  src <- tempfile(fileext = '.cpp')
  obj <- sub('cpp$', 'o', src)
  writeLines(testprog, con = src)
  out <- system2('make', c(obj, paste0("CXX=", CXX)), stdout = TRUE, stderr = TRUE)
  if(!file.exists(obj))
    stop("Failed to compile example program: ", out)
  TRUE
}
```

## How to build base R on Windows

See the [rwinlib/base](https://github.com/rwinlib/base) repository for scripts and documenation for building the R for Windows installer from source.

## How to install rJava on Windows?

The latest CRAN version of rJava will find the `jvm.dll` automatically, without manually setting the `PATH` or `JAVA_HOME`. However note that:
 
 - To use rJava in 32-bit R, you need [_Java for Windows x86_](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) ([direct download](https://github.com/portapps/untouched/releases/tag/oracle-jdk-8u221))
 - To use rJava in 64-bit R, you need [_Java for Windows x64_](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) ([direct download](https://github.com/portapps/untouched/releases/tag/oracle-jdk-8u221))
 - To build or check R packages with multi-arch (the default) you need to  __install both__ _Java For Windows x64_ as well as _Java for Windows x86_. On Win 64, the former installs in `C:\Program files\Java\` and the latter in `C:\Program Files (x86)\Java\` so they do not conflict.

As of Java version 9, support for x86 (win32) has been discontinued. Hence the latest working multi-arch setup is to install both [jdk-8u201-windows-i586.exe](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and [jdk-8u201-windows-x64.exe](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and then the binary package from CRAN: 

```r
install.packages("rJava")
```

The binary package from CRAN should pick up on the jvm by itself. __Experts only__: to build rJava from source, you need the `--merge-multiarch` flag:

```r
install.packages('rJava', type = 'source', INSTALL_opts='--merge-multiarch')
```

## Why does Rtools not put itself on the PATH ?


