# Todo: can we just get a nice simple light theme?
library(rmarkdown)
render("readme.md", html_document(self_contained = FALSE, mathjax = NULL, highlight = 'pygments'))
txt <- readLines('readme.html')
txt <- sub('<title>.*</title>', '<title>Using Rtools40 on Windows</title>', txt)
txt <- sub('readme_files/bootstrap-([.0-9]+)/css/bootstrap.min.css', 'https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/\\1//css/bootstrap.min.css', txt)
txt <- sub('https://cran.r-project.org/bin/windows/Rtools/', '', txt, fixed = TRUE)
txt <- sub('.*<script src="readme_files.*', "", txt)
writeLines(txt, 'readme.html')
browseURL('readme.html')


# Alternative style
library(rmarkdown)
render("readme.md", html_document(self_contained = F, mathjax = NULL, highlight = 'haddock', 
  theme = NULL, includes = includes('style.inc')), 'cranstyle.html')
txt <- readLines('cranstyle.html')
txt <- sub('<title>.*</title>', '<title>Using Rtools4 on Windows</title>', txt)
txt <- sub('.*<script src=".*', "", txt)
txt <- sub('<a href="https://github.com', '<a target="_top" href="https://github.com', fixed = TRUE, txt)
txt <- sub('<a href="https://www.msys2.org', '<a target="_top" href="https://www.msys2.org', fixed = TRUE, txt)
txt <- sub('https://cran.r-project.org/bin/windows/Rtools/', '', txt, fixed = TRUE)
writeLines(txt, 'cranstyle.html')
browseURL('cranstyle.html')
