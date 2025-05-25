usethis::use_mit_license(copyright_holder = "Yael Assouline")
rrtools::use_readme_qmd()
rrtools::use_analysis()

usethis::use_git_ignore(".Renviron")

install.packages(c("httr", "jsonlite"))
library(httr)
library(jsonlite)

hf_inference <- function(model_id, inputs, task = "text-generation", parameters = NULL) {
  API_URL <- paste0("https://api-inference.huggingface.co/models/", model_id)

  body <- list(inputs = inputs)
  if (!is.null(parameters)) {
    body$parameters <- parameters
  }

  response <- POST(
    url = API_URL,
    add_headers(
      Authorization = paste("Bearer", Sys.getenv("HF_API_TOKEN")),
      "Content-Type" = "application/json"
    ),
    body = toJSON(body, auto_unbox = TRUE)
  )

  content(response)
}

result <- hf_inference(
  model_id = "mistralai/Mistral-7B-Instruct-v0.2",
  inputs = "<s>[INST] what are the dates for passover this year in Israel? [/INST]",
  parameters = list(
    max_new_tokens = 100,
    temperature = 0.7,
    return_full_text = FALSE
  )
)

cat(result[[1]]$generated_text)

install.packages("gitcreds")  # if not already installed
library(gitcreds)
gitcreds_set()
git push
