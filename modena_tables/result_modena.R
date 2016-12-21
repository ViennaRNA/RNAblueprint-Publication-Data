#!/usr/bin/env Rscript

# Packages
check_package <- function(x) {
  if (!require(x,character.only = TRUE)) {
    install.packages(x,dep=TRUE)
  }
}

check_package("Hmisc")
check_package("gtools")
check_package("getopt")
check_package("corrplot")

# Option Parsing
spec = matrix(c(
    'prefix','p', 1, "character",
    'suffix','s', 1, "character",
    'directory', 'd', 1, "character",
    'help', 'h', 0, "logical",
    'corrplots', 'c', 0, "logical"
), byrow=TRUE, ncol=4);
opt = getopt(spec);

if (!is.null(opt$help)) {
cat(getopt(spec, usage=TRUE));
q(status=1);
}

prefix <- opt$prefix
postfix <- opt$suffix

if (!is.null(opt$directory)) {
setwd(opt$directory)
}

infiles <- mixedsort(list.files(pattern = '*.out'))

evaluate <- function(file) {
  data <- read.csv(file, header = TRUE, sep=";", dec = ".", comment.char='#')
  
  file <- sub(toString(prefix), "", file) 
  file <- sub(toString(postfix), "", file)
  file <- gsub("_", " ", file)
  
  data <- cbind(data,path=file) # add column with filename
  
  l <- max(data$seq_length)
  mean_nom <- mean(data$num_mutations)
  median_nom <- median(data$num_mutations)
  mean_constructing <- mean(data$construction_time)
  mean_sampling <- mean(data$sample_time)
  max_dimensions <- max(data$max_dimensions)

  all_deltas <- data[,grep("^diff_eos_mfe_", colnames(data))] # find all entries concerning diff_eos
 
  d1_min_row<- apply(all_deltas, 1, min) # find min delta of each row
  d2_min_row <- apply(all_deltas, 1, max) # find max delta of each row

  probs <- data[,grep("^prob_", colnames(data))]
  row_sum_prob <- c(rowSums(probs))

  # find min d2 and min d1, if there are more than one min d2
  deltas <- data.frame(d1_min_row, d2_min_row, row_sum_prob) 

  min_d2 <-  deltas[deltas$d2_min_row == min(deltas$d2_min_row),] # rows where column d2 is minimum 
  min_d1 <- min_d2[min_d2$d1_min_row == min(min_d2$d1_min_row),] # find all minima of d1, then compare probs
  min_d1 <- min_d1[min_d1$row_sum_prob == min(min_d1$row_sum_prob),] # find minimal probs
  sum_prob <- min(min_d1$row_sum_prob) # find one min prob
  
  d1 <- min_d1[1,1] # all entries in this column mimima, therefore take first entry
  d2 <- min_d2[1,2] # all entries in this column mimima, therefore take first entry
  
  # mean, median, standard deviation and standard error of d1 and d2 
  mean_d1 <- mean(d1_min_row)
  median_d1 <- median(d1_min_row)
  sd_d1 <- sd(d1_min_row)
  se_d1 <- sd_d1/sqrt(length(d1_min_row))
  mean_d2 <- mean(d2_min_row)
  median_d2 <- median(d2_min_row)
  sd_d2 <- sd(d2_min_row)
  se_d2 <- sd_d2/sqrt(length(d2_min_row))

  mfe_reached <- data[,grep("^mfe_reached_", colnames(data))] # "ns"
  sorted_mfes <- t(apply(mfe_reached, 1, sort, decreasing = TRUE))   

  colnames(sorted_mfes) <- cbind(colnames(mfe_reached))
  rownames(sorted_mfes) <- rbind(rownames(mfe_reached))
 
  sum_n <- t(colSums(sorted_mfes)) # sums of ns
  RNA <- file
  num_of_structs <- length(mfe_reached)

  #prob <- data[grep("^prob_", colnames(data))] # find all entries concerning probabilities
  #sum_prob <- c(rowSums(prob))
  #mean_prob <- mean(sum_prob)
  #median_prob <- median(sum_prob)
  
  result <-data.frame(RNA, l, sum_n, d1, d2, mean_d1, median_d1, mean_d2, median_d2, mean_nom, median_nom, sum_prob, mean_constructing, mean_sampling, max_dimensions, num_of_structs)
  return(result)
}

all_infiles <- lapply(infiles, 
                      function(file) { 
                        tryCatch(evaluate(file), error = function(e) { stop(paste("Error in file ", file, ":", e$message)) }) 
                      }
)

all_infiles <- do.call(rbind,all_infiles)

num_of_structs <- all_infiles$num_of_structs

insert_point <- 3
for (i in 1:num_of_structs) {
    colnames(all_infiles)[insert_point] <- paste0("n", i)
    insert_point <- insert_point + 1
}

last_element <- length(all_infiles) 
all_infiles <- all_infiles[-c(last_element)] #drop last column(=number_of_structs) 
names_infiles <- colnames(all_infiles)

# calculate mean and median from all_infiles d1 and d2  
mean_all_d1 <- mean(all_infiles$d1)
median_all_d1 <- median(all_infiles$d1)
mean_all_d2 <- mean(all_infiles$d2)
median_all_d2 <- median(all_infiles$d2)

# calculate mean and median from all_infiles row wise sum of probs
mean_all_probs <- mean(all_infiles$sum_prob)
median_all_probs <- median(all_infiles$sum_prob)

# generate row for mean of d1 and d2 and probs for latex table
means_best_designs <- c(rep(NA,last_element-1))
means_best_designs <- t(means_best_designs)
means_best_designs <- as.data.frame(means_best_designs)
colnames(means_best_designs) <- names_infiles
means_best_designs$RNA <- "$\\mu$"
means_best_designs$d1 <- mean_all_d1
means_best_designs$d2 <- mean_all_d2
means_best_designs$sum_prob <- mean_all_probs

# calculate mean  of columns of ns
insert_point <- 3
for (i in 1:num_of_structs) {
    means_best_designs[insert_point] <- mean(all_infiles[,insert_point])
    #print(mean(all_infiles[,insert_point]))
    insert_point <- insert_point + 1
}


# generate row for median of d1 and d2 and probs for latex table
medians_best_designs <- c(rep(NA,last_element-1))
medians_best_designs <- t(medians_best_designs)
medians_best_designs <- as.data.frame(medians_best_designs)
colnames(medians_best_designs) <- names_infiles
medians_best_designs$RNA <- "$\\tilde x$"
medians_best_designs$d1 <- median_all_d1
medians_best_designs$d2 <- median_all_d2
medians_best_designs$sum_prob <- median_all_probs

# calculate median of columns of ns
insert_point <- 3
for (i in 1:num_of_structs) {
    medians_best_designs[insert_point] <- median(all_infiles[,insert_point])
    insert_point <- insert_point + 1
}

# add mean and median d1/d2 to existing data.frame
all_infiles <- rbind(all_infiles, means_best_designs)
all_infiles <- rbind(all_infiles, medians_best_designs)

# format names for latex table
new_names <- colnames(all_infiles)
new_names <- gsub(pattern="_", replacement = " ", new_names, ignore.case = T)
new_names <- sapply(new_names, function(x) {
  x <- gsub(pattern="_", replacement = " ", x)
  x <- gsub(pattern="median", replacement = "$\\\\tilde x$", x)
  x <- gsub(pattern="mean", replacement = "$\\\\mu$", x)
  x <- gsub(pattern="sum", replacement = "$\\\\sum$", x)
})

colnames(all_infiles) <- new_names

# format numbers for latex table 
format_numbers <- c(rep(2, last_element-1))

# keine Nachkommastellen
format_numbers[c(1: (2 + num_of_structs))] <- 0
#format_numbers[c(1:2)] <- 0

# generate latex table
latex.default(all_infiles, cdec=format_numbers, rowname=NULL, n.rgroup=c(NROW(all_infiles) - 2, 2), na.blank=TRUE, booktabs=FALSE, table.env=FALSE, center="none", file="", title="") 


# also generate correlation plot showing the sample times and complexity of the problem
if (!is.null(opt$corrplots)) {
    readData <- function(file) {
      data <- read.csv(file, header = TRUE, sep=";", dec = ".", comment.char='#')
      data <- data[grep("^max_dimensions|^nos|time$|num_mutations|score|max_specials|num_cc", colnames(data), value=TRUE)]
      return(data)
    }

    all_data <- lapply(infiles, 
                          function(file) { 
                            tryCatch(readData(file), error = function(e) { stop(paste("Error in file ", file, ":", e$message)) }) 
                          }
    )
    all_data <- do.call(rbind,all_data)

    svg(paste(opt$directory, ".corr.svg", sep=""), width=6, height=6)
    corrplot(cor(all_data), method="number")
    dev.off()

    svg(paste(opt$directory, ".nom_samptime.svg", sep=""), width=6, height=6)
    ggplot(all_data, aes(x=num_mutations, y=sample_time)) + 
    ggtitle("Number of Mutations vs Sampling time") +
    scale_x_continuous(name="Number of Mutations") + 
    scale_y_continuous(name="Sampling Time") + 
    geom_point(shape=2) + 
    geom_smooth(method=lm)
    dev.off()
    svg(paste(opt$directory, ".maxdim_consttime.svg", sep=""), width=6, height=6)
    ggplot(all_data, aes(x=num_mutations, y=construction_time)) + 
    ggtitle("Maximal Table Dimesions vs Constructing time") +
    scale_x_continuous(name="Maximal Table Dimesions") +
    scale_y_continuous(name="Constructing Time") + 
    geom_point(shape=2) +
    geom_smooth(method=lm)
    dev.off()
}
