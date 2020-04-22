# Todo: can we just get a nice simple light theme?
library(rmarkdown)
render("readme.md", html_document(self_contained = FALSE, mathjax = NULL, highlight = 'pygments'))
txt <- readLines('readme.html')
txt <- sub('<title>.*</title>', '<title>Using Rtools40 on Windows</title>', txt)
txt <- sub('readme_files/bootstrap-([.0-9]+)/css/bootstrap.min.css', 'https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/\\1//css/bootstrap.min.css', txt)
txt <- sub('.*<script src="readme_files.*', "", txt)
writeLines(txt, 'readme.html')
browseURL('readme.html')


# Alternative style
render("readme.md", html_document(self_contained = F, mathjax = NULL, highlight = 'haddock', 
  theme = NULL, css='https://cran.r-project.org/web/CRAN_web.css'), 'cranstyle.html')
txt <- readLines('cranstyle.html')
txt <- sub('<title>.*</title>', '<title>Using Rtools40 on Windows</title>', txt)
writeLines(txt, 'cranstyle.html')
browseURL('cranstyle.html')
