library(jsonlite)
library(htmltools)
library(reactable)
library(dplyr)
library(lubridate)

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

build_issue_table <- function(issue_data) {

  tbl <- reactable(
    issue_data,
    pagination = FALSE,
    defaultSorted = "created_at",
    defaultSortOrder = "desc",
    defaultColDef = colDef(headerClass = "header", align = "left"),
    columns = list(
      url = colDef(
        show = FALSE
      ),
      title = colDef(
        name = "Issue Title",
        cell = function(value, index) {
          url <- issue_data[index, "url"]
          tags$a(href = url, target = "_blank", value)
        },
        sortable = FALSE,
        filterable = TRUE
      ),
      type = colDef(
        name = "Type",
        filterable = TRUE
      ),
      labels = colDef(
        name = "Labels",
        cell = function(value, index) {
          label_strings <- strsplit(value, ",")
          content <- vector("character", length(label_strings))
          background_colors <- strsplit(issue_data[index, "label_colors"], ",")
          font_colors <- strsplit(issue_data[index, "font_colors"], ",")
          for (i in 1:length(label_strings[[1]])) {
            content <- c(content, paste0("<span class='radius_label' style='background: ", background_colors[[1]][i], "; color: ", font_colors[[1]][i], "'>", label_strings[[1]][i], "</span>"))
          }
          paste0(content, collapse = " ")
        },
        html = TRUE,
        filterable = TRUE
      ),
      label_colors = colDef(
        show = FALSE
      ),
      font_colors = colDef(
        show = FALSE
      ),
      created_at = colDef(
        name = "Created on",
        cell = function(value) {
          as_date(value)
        },
        sortable = TRUE
      ),
      updated_at = colDef(
        name = "Last updated",
        cell = function(value) {
          as_date(value)
        },
        sortable = TRUE
      ),
      org = colDef(
        show = FALSE
      ),
      repo = colDef(
        show = FALSE
      ),
      full_repo = colDef(
        show = FALSE
      ),
      description = colDef(
        name = "Repository",
        cell = function(value, index) {
          url <- paste0("https://github.com/", issue_data[index, "full_repo"])
          tags$a(href = url, target = "_blank", value)
        },
        filterable = TRUE,
        sortable = TRUE
      ),
      clean_description = colDef(
        show = FALSE
      ),
      org_name = colDef(
        name = "Organisation",
        cell = function(value, index) {
          url <- paste0("https://github.com/", issue_data[index, "org"])
          tags$a(href = url, target = "_blank", value)
        },
        filterable = TRUE,
        sortable = TRUE
      )
    ),
    compact = TRUE,
    highlight = TRUE,
    class = "issue-tbl"
  )
}
