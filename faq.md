# R on Windows FAQ

## How to test if the compiler is available?

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

## How to install rJava?

The latest CRAN version of rJava will find the `jvm.dll` automatically, without manually setting the `PATH` or `JAVA_HOME`. However note that:
 
 - To use rJava in 32-bit R, you need [_Java for Windows x86_](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
 - To use rJava in 64-bit R, you need [_Java for Windows x64_](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
 - To build or check R packages with multi-arch (the default) you need to  __install both__ _Java For Windows x64_ as well as _Java for Windows x86_. On Win 64, the former installs in `C:\Program files\Java\` and the latter in `C:\Program Files (x86)\Java\` so they do not conflict.

As of Java version 9, support for x86 (win32) has been discontinued. Hence the latest working multi-arch setup is to install both [jdk-8u172-windows-i586.exe](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and [jdk-8u172-windows-x64.exe](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) and then the binary package from CRAN: 

```r
install.packages("rJava")
```

The binary package from CRAN should pick up on the jvm by itself. __Experts only__: to build rJava from source, you need the `--merge-multiarch` flag:

```r
install.packages('rJava', type = 'source', INSTALL_opts='--merge-multiarch')
```


