# R on Windows FAQ


## What is Rtools

Rtools is the toolchain bundle that is used to build R for Windows and R packages that contain compiled code. You can download it from [CRAN](https://cran.r-project.org/bin/windows/Rtools/). There are currently two version of Rtools:

 - Rtools35 (gcc 4.9.3): used by R versions 3.3 - 3.6. This is probably what you need.
 - Rtools40 (gcc 8.3.0): experimental next generation, see [documentation](https://cran.r-project.org/bin/windows/testing/rtools40.html)

It is highly recommended to always install Rtools in the default path, so that R can find it when building packages.


## Where R looks for the compiler

The way R finds the compiler path is a bit convoluted for historical reasons, but it is quite simple. The most important thing is that the correct version of `make` is on the path. _On Windows it is not needed to put gcc on the path!_

```r
# Check your path
Sys.getenv('PATH')

# Check if make is on the path
Sys.which('make')
```

If this works, R can use the values provided by `R CMD config` to lookup the path to the compiler and other build tools. To test this manually in R, let's lookup the path to our C++11 compiler:

```r
R <- file.path(R.home('bin'), 'R')
system2(R, c("CMD", "config", "CXX11"))
# C:/Rtools/mingw_64/bin/g++
```

All of the above is the same on all operating systems (Windows, MacOS, Linux). But the following section is Windows specific.


## Using a non-default compiler path on Windows

If for whatever reason you want R to use gcc from another path (which is not recommended) you can override the path to gcc using the `BINPREF` environment variable. As shown above, the default value of `BINPREF` in R 3.5 is hardcoded to `"C:/Rtools/mingw_$(WIN)/bin/"`.  When invoking the compiler, `make` will automatically resolve `$(WIN)` to either `"32"` or `"64"` depending on the target architecture. 

If you set a custom `BINPREF` it is important to embed the `"$(WIN)"` variable to specify the target. To illustrate how this works, try running the following in R for Windows:

```r
Sys.setenv(BINPREF = "C:/mycompiler/something/mingw$(WIN)/")
R <- file.path(R.home('bin'), 'R')
CXX11 <- system2(R, c("CMD", "config", "CXX11"))
# C:/mycompiler/something/mingw64/g++
```

Again, you should never change `BINPREF` when you installed the correct Rtools in the default location. Also if you are not correctly using `"$(WIN)"` inside BINPREF, R might use the compiler for the wrong architecture and bad things will happen.


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
 
 - To use rJava in 32-bit R, you need [_Java for Windows x86_](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
 - To use rJava in 64-bit R, you need [_Java for Windows x64_](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
 - To build or check R packages with multi-arch (the default) you need to  __install both__ _Java For Windows x64_ as well as _Java for Windows x86_. On Win 64, the former installs in `C:\Program files\Java\` and the latter in `C:\Program Files (x86)\Java\` so they do not conflict.

As of Java version 9, support for x86 (win32) has been discontinued. Hence the latest working multi-arch setup is to install both [jdk-8u201-windows-i586.exe](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and [jdk-8u201-windows-x64.exe](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and then the binary package from CRAN: 

```r
install.packages("rJava")
```

The binary package from CRAN should pick up on the jvm by itself. __Experts only__: to build rJava from source, you need the `--merge-multiarch` flag:

```r
install.packages('rJava', type = 'source', INSTALL_opts='--merge-multiarch')
```


