## source files in R/
lapply(list.files(pattern = "[rR]$", path = "R", full.names = TRUE), source)


## Generate help wanted table

issue_data <- fromJSON("https://feeds.carpentries.org/help_wanted_issues.json")
issue_data <- issue_data[, c(
  "title",
  "description",
  "org_name",
  "created_at",
  "updated_at",
  "labels",
  "type",
  "url",
  "label_colors",
  "font_colors",
  "org",
  "repo",
  "full_repo",
  "clean_description"
)]


tbl <- build_table(issue_data)
save_bare_html(tbl, file = "tmp/issue_table.html", libdir = "reactable")
