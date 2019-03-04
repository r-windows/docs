# Rtools 40

New experimental toolchain for R on Windows based on gcc 8 and msys2.

## Install Rtools40 and R-testing

Rtools40 does not conflict with other versions of Rtools and can be installed alongside existing Rtools 3.5 installations.

- Use [rtools40-x86_64.exe](rtools40-x86_64.exe) on 64 bit Windows systems (recommended, includes `i386` and `x64` toolchains)
- Use [rtools40-i686.exe](rtools40-i686.exe) on 32 bit Windows systems (includes `i386` toolchain only)

The daily build of `R-testing` is a modified version of R-devel configured for the new toolchain. 

- Download [R-testing-win.exe](R-testing-win.exe)

For now, `R-testing` automatically sets the `PATH` in R to use `make` and `gcc` from rtools40. No need to modify the Windows system `PATH`. This is a temporary solution to run `R-testing` alongside R 3.5.1. Make sure you do not override the `PATH` in your `~/.Renviron` file.

## Help and Reporting Problems

If you find a problem in a package or cannot make it work, open a ticket here: https://github.com/r-windows/checks/issues. Only report issues here that are specific to the new Rtools toolchain. Check that:

 - The problem does not pre-exist on the CRAN with the current Windows toolchain
 - The error/warning does not appear with GCC-8 on Fedora/Debian on CRAN
 - One issue per package

Please be patient, a toolchain upgrade with 12k packages is a complex operation.

## System Software

Because CRAN does not provide binaries for the new toolchain yet, `R-testing` installs all packages from source.

Some R packages require external libraries or software to build. Rtools40 includes a package manager which you can use to install additional [rtools packages](https://github.com/r-windows/rtools-packages). There should be a shortcut to the Rtools terminal in your Start Menu.

<img src="https://i.imgur.com/Ob34TLi.png" width="600">

The package mananger is called `pacman`: the native package manager from arch linux which has been ported to Windows by msys2.

```sh
# Update repo index
pacman -Sy
```

Binary packages are prefixed with `mingw-w64-686-` for the win32 version and with `mingw-w64-x86_64-` for the win64 build. To build an R package we typically need both, for example to install the `coinor` library:

```sh
# Install libcurl
pacman -S  mingw-w64-{i686,x86_64}-coinor
```

Now we can install the R package. Rtools will automatically find libraries installed by pacman, no need to set custom paths.

```r
# Run in R:
install.packages("Rsymphony")
```


## Compiling R Packages with Custom Flags

Some older R packages do not use the correct flags by default and need a little help. You can pass additional compiler and linker flags by setting these environment variables:

 - `LOCAL_CPPFLAGS`: custom C/C++ flags passed when compiling
 - `LOCAL_LIBS`: custom flags when linking

An example is the old `XML` package. First install `libxml2` in rtools:

```sh
# Run this in Rtools
pacman -S mingw-w64-{i686,x86_64}-libxml2
```

And then install `XML` like this:


```r
# Run this in R
Sys.setenv(LOCAL_CPPFLAGS = "-I/mingw$(WIN)/include/libxml2")
Sys.setenv(LOCAL_LIBS = '-llzma')
install.packages("XML")
```

## Managing System Packages

First update the repository list:

```sh
# Update repo index
pacman -Sy

# Upgrade installed packages
pacman -Su
```

To list all rtools packages currently available:

```sh
pacman -Sl
```

Find out more at the [pacman website](https://wiki.archlinux.org/index.php/pacman).


### Automated Installation

I run this every day on my build server to update and install all available rtools packages:

```sh
# Update all the packages!!
pacman -Syu --noconfirm
pacman -S --needed --noconfirm $(pacman -Slq | grep mingw-w64-)
```


