makeDependencyRemote <- function(dependency, baseurl) {
  if (!identical(substr(baseurl, nchar(baseurl), nchar(baseurl)), "/")) {
    baseurl <- paste0(baseurl, "/")
  }

  dir <- dependency$src[["file"]]
  dependency$src <- c(href = paste0(baseurl, dependency$src[["file"]]))

  dependency
}


## taken from: https://github.com/rstudio/htmltools/blob/62b2f7dcd9fc01d856301d4f3b38d8a7ab56f671/R/html_print.R#L73

## libdir is created as a subfolder of where file will be written.
save_bare_html <- function(html, file, libdir = "reactable", baseurl = "https://files.carpentries.org") {
  force(html)
  force(libdir)

  stopifnot(is.character(file))

  # ensure that the paths to dependencies are relative to the base
  # directory where the webpage is being built.
  dir <- normalizePath(dirname(file), mustWork = FALSE)
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
  dir <- normalizePath(dirname(file), mustWork = TRUE)

  content_file <- file.path(dir, paste0("_content_", basename(file)))
  head_file <- file.path(dir, paste0("_head_", basename(file)))

  owd <- setwd(dir)
  on.exit(setwd(owd), add = TRUE)

  rendered <- renderTags(html)

  deps <- lapply(rendered$dependencies, function(dep) {
    dep <- copyDependencyToDir(dep, libdir, FALSE)
    dep <- makeDependencyRelative(dep, dir, FALSE)
    dep <- makeDependencyRemote(dep, baseurl)
    dep
  })

  # build the web-page
  html <- list(
    head = c(
      renderDependencies(deps, c("href", "file")),
      rendered$head
    ),
    body = c(
      rendered$html
    )
  )

  # Write to file in binary mode, so \r\n in input doesn't become \r\r\n
  body <- base::file(content_file, open = "w+b")
  on.exit(close(body), add = TRUE)
  writeLines(html$body, body, useBytes = TRUE)

  head <- base::file(head_file, open = "w+b")
  on.exit(close(head), add = TRUE)
  writeLines(html$head, head, useBytes = TRUE)
}
