# R on Windows FAQ

These are some common issues related to installing R packages on Windows with Rtools. This complements the official [R-FAQ](https://cran.r-project.org/doc/FAQ/R-FAQ.html) from CRAN.


## What is Rtools

Rtools is the toolchain bundle that is used on Windows to build R base and R packages that contain compiled code. You can download it from [CRAN](https://cran.r-project.org/bin/windows/Rtools/). There are currently two version of Rtools:

 - Rtools35 (gcc 4.9.3): used by old R versions 3.3 - 3.6. No longer updated.
 - Rtools40 (gcc 8.3.0): current toolchain, used for R 4.0 and up.

You only need Rtools if you want to compile R packages from source that contain C/C++/Fortran. By default, R for Windows installs the precompiled _binary packages_ from CRAN, for which you do not need rtools.

## How to install Rtools40:

Please see instructions in: https://github.com/r-windows/docs


## Why does Rtools not put itself on the PATH automatically?

Some versions of rtools in the past would automatically alter the global windows system PATH variable and add the rtools path. This was problematic for several reasons:

The main problem is that other Windows programs may also attempt to do this (Strawberry Perl for example) and hence if those programs are installed after rtools, they may mask the rtools utilities from the PATH. But it would also hold vice-versa: prepending the windows system PATH with the rtools utilities could have undesired side-effects for other software relying on the path.

For these reasons, the best way to set the PATH for R is in your `~/.Renviron` file.


## What is the difference between the msys, mingw32, and mingw64 shells?

These are almost the same, the only difference is the default PATH. The mingw32/mingw64 shell automatically put the respective gcc version on the path, whereas the msys shell has no toolchain on the path. Other than that there is no difference.


## Does Rtools40 include git or svn? Why not?

Rtools40 does not include git or svn clients. Most Windows users have [Git for Windows](https://git-scm.com/download/win) or [TortoiseSVN](https://tortoisesvn.net/) installed and configured, so we recommend to use these.


## Is Git-for-Windows compatible with rtools40?

Yes. If you have [Git for Windows](https://git-scm.com/download/win) you will be able to use `git` commands from the rtools40 shell as well. Note that Git for Windows also includes it's own shell called "Git Bash" which looks very similar to Rtools Bash. That is because they use exactly the same system.

Most git commands will work the same in Rtools as Git Bash, however for git commands that use vim for interactive editing things, it is safer to use Git Bash (because it includes a special vim that rtools doesn't have).


## How to extract a tarball with symlinks

Windows does not support symlinks. Cygwin has several ways to emulate symlinks, but each has limitations. To extract a tarball which contains symlinks (such as the official R source releases) you can set this environment variable: 

```
MSYS="winsymlinks:lnk"
```

This will create symlinks as Windows shortcuts with a special header and the R/O attribute set.


## How does R find compilers

The most important thing is that the rtools40 `make` is on the path. It is not needed to put gcc on the path.

```r
# Check your path
Sys.getenv('PATH')

# Confirm that make.exe is on the PATH
Sys.which('make')
## "C:\\rtools40\\usr\\bin\\make.exe"
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
r_cmd_config <- function(var){
  tools::Rcmd(c("config", var), stdout = TRUE)
}

test_compiler <- function(){
  testprog <- '#include <iostream>\nint main() {std::cout << "Hello World!";}'
  make <- Sys.which('make')
  if(!nchar(make))
    stop("Did not find 'make' on the PATH")
  CXX <- r_cmd_config("CXX")
  src <- tempfile(fileext = '.cpp')
  obj <- sub('cpp$', 'o', src)
  writeLines(testprog, con = src)
  out <- system2('make', c(obj, sprintf('CXX="%s"', CXX)))
  if(!file.exists(obj))
    stop("Failed to compile example program: ", out)
  TRUE
}
```

## How to build base R on Windows

See the [r-windows/r-base](https://github.com/r-windows/r-base) repository for scripts and documenation for building the R for Windows installer from source.


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



