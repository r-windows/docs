# Rtools 40

New toolchain for R on Windows based on gcc 8.3.0 and msys2.

## Installing Rtools40

Rtools40 does not conflict with other versions of Rtools and can be installed alongside existing Rtools 3.5 installations.

- Use [rtools40-x86_64.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40-x86_64.exe) on 64 bit Windows (recommended, includes `i386` and `x64` toolchains)
- Use [rtools40-i686.exe](https://cran.r-project.org/bin/windows/Rtools/rtools40-i686.exe) on 32 bit Windows (includes `i386` toolchain only)


## System Libraries

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


