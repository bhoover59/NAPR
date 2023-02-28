get_input_file <- function(){
  input <- read.csv(file.choose())
  return(input)
}
