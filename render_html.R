# Todo: can we just get a nice simple light theme?
library(rmarkdown)
render("readme.md", html_document(self_contained = FALSE, mathjax = NULL, highlight = 'pygments'))
txt <- readLines('readme.html')
txt <- sub('<title>.*</title>', '<title>Using Rtools40 on Windows</title>', txt)
txt <- sub('readme_files/bootstrap-([.0-9]+)/css/bootstrap.min.css', 'https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/\\1//css/bootstrap.min.css', txt)
txt <- sub('.*<script src="readme_files.*', "", txt)
writeLines(txt, 'readme.html')
browseURL('readme.html')
