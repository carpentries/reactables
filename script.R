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


issue_tbl <- build_issue_table(issue_data)
save_bare_html(issue_tbl, file = "tmp/issue_table.html", libdir = "reactable")

## Generate Community lesson table
lesson_data <- fromJSON("https://feeds.carpentries.org/community_lessons.json")
lesson_data <- lesson_data[, c(
  "description",
  "repo",
  "life_cycle_tag",
  "lesson_tags",
  "org_full_name",
  "carpentries_org",
  "repo_url",
  "full_name",
  "rendered_site",
  "github_topics"
)]

lesson_table <- build_lesson_table(lesson_data)
save_bare_html(lesson_table, file = "tmp/lesson_table.html", libdir = "reactable")
