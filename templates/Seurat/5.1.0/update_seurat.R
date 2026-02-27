if (!requireNamespace("remotes", quietly = TRUE)) {
  message("Installing remotes...")
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

message("Updating Seurat from GitHub (release-5.0)...")
tryCatch({
  remotes::install_github(
    repo = "satijalab/seurat",
    ref = "release-5.0",
    upgrade = "always",
    force = TRUE,
    build_opts = c("--no-multiarch", "--no-test-load") 
  )
  message("Seurat update completed successfully.")
}, error = function(e) {
  message("Error during installation: ")
  message(e$message)
  message("Trying CRAN latest as fallback...")
  install.packages("Seurat", type="source", repos="https://cloud.r-project.org")
})

message("\n--- Version Check ---")
print(paste("Seurat:", as.character(packageVersion("Seurat"))))
print(paste("SeuratObject:", as.character(packageVersion("SeuratObject"))))
print(paste("sctransform:", as.character(packageVersion("sctransform"))))

