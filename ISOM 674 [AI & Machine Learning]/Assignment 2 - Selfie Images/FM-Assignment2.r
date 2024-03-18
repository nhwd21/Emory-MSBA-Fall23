# Read in the data --------------------------------------------------------

# Note: Change Filename once the data is finalized
FileName <- "SelfieImageDataFinal.csv"
Labs <- scan(file=FileName,what="xx",nlines=1,sep="|")
DataAsChars <- matrix(scan(file=FileName,what="xx",sep="|",skip=1),byrow=T,ncol=length(Labs))
colnames(DataAsChars) <- Labs

ImgData <- matrix(as.integer(DataAsChars[,-1]),nrow=nrow(DataAsChars))
colnames(ImgData) <- Labs[-1]
rownames(ImgData) <- DataAsChars[,1]

# Free up some memory just in case
remove(DataAsChars)
remove(FileName)
remove(Labs)

# Q2: Average Image -------------------------------------------------------

# Compute the average of each column and store it in AvgImgData
AvgImgData <- apply(ImgData, 2, mean)

# Convert the result back to a matrix with one row
AvgImgData <- matrix(AvgImgData, nrow = 1)

# Create the image plot
Img <- matrix(AvgImgData[1,],byrow=T,ncol=sqrt(ncol(ImgData)))
Img <- apply(Img,2,rev)

# Set up plot parameters
par(pty="s",mfrow=c(1,1))10

# Plot the image
image(z=t(Img), col = grey.colors(255), useRaster = TRUE)

# Add a title to the plot
title(main = "DMOSDEN: Average Face", cex.main = 1.2)

remove(Img)
remove(AvgImgData)

# Q5 - Scree Plot ---------------------------------------------------------

# Step 1: Center the Data
# FIX From solutions
AveFace <- apply(ImgData,2,mean)
X_c <- sweep(ImgData,2,AveFace,FUN="-")

# Step 2: Compute small matrix
small_matrix <- X_c %*% t(X_c)

# Step 3: Compute eigenvalues and eigenvectors of the small matrix
eigen <- eigen(small_matrix)
lambda <- eigen$values 
v <- eigen$vectors
remove(eigen)
remove(small_matrix)

# Step 4: Compute Sigma^ eigenvalues and eigenvectors
sigma_eigenvalues <- lambda / (nrow(ImgData) - 1)
sigma_eigenvectors <- t(X_c) %*% v 
sigma_eigenvectors <- apply(sigma_eigenvectors, MARGIN=2, function(x) x/sqrt(sum(x^2)))

# Step 5: Sort eigenvalues in descending order
sorted_indices <- order(sigma_eigenvalues, decreasing = TRUE)
sigma_values_sorted <- sigma_eigenvalues[sorted_indices]
sigma_vectors_sorted <- sigma_eigenvectors[, sorted_indices]
remove(sorted_indices)

# Load required library
library(ggplot2)

# Create scree plot
scree_data <- data.frame(
  Principal_Component = 1:length(sigma_values_sorted),
  Eigenvalue = sigma_values_sorted
)

scree_plot <- ggplot(scree_data, aes(x = Principal_Component, y = Eigenvalue)) +
  geom_point(size = 2, color = "blue") +
  geom_line(color = "red") +
  labs(x = "Principal Component", y = "Eigenvalue", title = "DMOSDEN: Scree Plot") +
  theme_minimal()

# Print the scree plot
print(scree_plot)

remove(lambda)
remove(sigma_eigenvalues)
remove(sigma_values_sorted)
remove(sigma_vectors_sorted)
remove(v)
remove(sigma_eigenvectors)
remove(scree_data)
remove(scree_plot)
remove(AveFace)

# Q6 - Largest Eigenvalue -------------------------------------------------

# FIX From solutions
AveFace <- apply(ImgData,2,mean)
X_c <- sweep(ImgData,2,AveFace,FUN="-")

# Step 2: Compute small matrix
small_matrix <- X_c %*% t(X_c)

# Step 3: Compute eigenvalues and eigenvectors of the small matrix
eigen <- eigen(small_matrix)
lambda <- eigen$values 
v <- eigen$vectors
remove(eigen)
remove(small_matrix)

# Step 4: Compute Sigma^ eigenvalues and eigenvectors
sigma_eigenvalues <- lambda / (nrow(ImgData) - 1)
sigma_eigenvectors <- t(X_c) %*% v 
sigma_eigenvectors <- apply(sigma_eigenvectors, MARGIN=2, function(x) x/sqrt(sum(x^2)))

# Find the largest eigenvalue
largest_eigenvalue <- max(sigma_eigenvalues)

# Format the answer as a decimal number with 2 significant digits after the decimal point
formatted_answer <- sprintf("%.2f", largest_eigenvalue)

# Print the formatted answer
print(formatted_answer)

remove(formatted_answer)
remove(largest_eigenvalue)
remove(v)
remove(lambda)
remove(sigma_eigenvalues)
remove(sigma_eigenvectors)
remove(AveFace)

# Q7 - Vectors for 85% Variance -------------------------------------------

# FIX From solutions
AveFace <- apply(ImgData,2,mean)
X_c <- sweep(ImgData,2,AveFace,FUN="-")

# Step 2: Compute small matrix
small_matrix <- X_c %*% t(X_c)

# Step 3: Compute eigenvalues and eigenvectors of the small matrix
eigen <- eigen(small_matrix)
lambda <- eigen$values 
v <- eigen$vectors
remove(eigen)
remove(small_matrix)

# Step 4: Compute Sigma^ eigenvalues and eigenvectors
sigma_eigenvalues <- lambda / (nrow(ImgData) - 1)
sigma_eigenvectors <- t(X_c) %*% v 
sigma_eigenvectors <- apply(sigma_eigenvectors, MARGIN=2, function(x) x/sqrt(sum(x^2)))

# Step 5: Sort eigenvalues in descending order
sorted_indices <- order(sigma_eigenvalues, decreasing = TRUE)
sigma_values_sorted <- sigma_eigenvalues[sorted_indices]
sigma_vectors_sorted <- sigma_eigenvectors[, sorted_indices]
remove(sorted_indices)

# Step 5: Determine the number of principal components to retain for 95% variance
total_variance <- sum(sigma_values_sorted)
cumulative_variance <- cumsum(sigma_values_sorted) / total_variance

# Determine the number of principal components to retain for 85% variance
num_components_85percent <- sum(cumulative_variance <= 0.85) + 1  # Add 1 because indexing starts from 1

# Print the number of eigenvectors needed to explain 85% of the total variance
print(num_components_85percent)

remove(v)
remove(lambda)
remove(sigma_eigenvalues)
remove(sigma_eigenvectors)
remove(sigma_vectors_sorted)
remove(cumulative_variance)
remove(num_components_85percent)
remove(sigma_values_sorted)
remove(total_variance)
remove(AveFace)

# Q8: Non-Centered PCA (20 components) ------------------------------------

# Step 1: Compute small matrix
small_matrix <- ImgData %*% t(ImgData)

# Step 2: Compute eigenvalues and eigenvectors of the small matrix
eigen <- eigen(small_matrix)
lambda <- eigen$values 
v <- eigen$vectors
remove(eigen)
remove(small_matrix)

# Step 3: Compute Sigma^ eigenvalues and eigenvectors
sigma_eigenvalues <- lambda / (nrow(ImgData) - 1)
sigma_eigenvectors <- t(ImgData) %*% v 
sigma_eigenvectors <- apply(sigma_eigenvectors, MARGIN=2, function(x) x/sqrt(sum(x^2)))

# Step 4: Sort eigenvalues in descending order
sorted_indices <- order(sigma_eigenvalues, decreasing = TRUE)
sigma_values_sorted <- sigma_eigenvalues[sorted_indices]
sigma_vectors_sorted <- sigma_eigenvectors[, sorted_indices]
remove(sorted_indices)

# Compute the first 20 principal components using the first 20 eigenvectors
first_20_eigenvectors <- sigma_vectors_sorted[, 1:20]
first_20_principal_components <- ImgData %*% first_20_eigenvectors

# Reconstruct the images from the 20-dimensional representation
reconstructed_images <- first_20_principal_components %*% t(first_20_eigenvectors)

# Reconstruct the specific image as a 451x451 matrix so we can print it out using image()
Img <- matrix(reconstructed_images["dmosden",], byrow = TRUE, ncol = sqrt(ncol(ImgData)))
Img <- apply(Img,2,rev)
par(pty="s",mfrow=c(1,1))
image(z=t(Img),col = grey.colors(255),useRaster=T)
title(main = "DMOSDEN: My Face 20D", cex.main = 1.2)

remove(sigma_eigenvalues)
remove(sigma_eigenvectors)
remove(sigma_vectors_sorted)
remove(sigma_values_sorted)
remove(first_20_eigenvectors)
remove(first_20_principal_components)
remove(reconstructed_images)
remove(Img)
remove(v)
remove(lambda)


# Q10 - 8th EigenFace --------------------------------------------------------

# FIX From solutions
AveFace <- apply(ImgData,2,mean)
X_c <- sweep(ImgData,2,AveFace,FUN="-")

# Step 2: Compute small matrix
small_matrix <- X_c %*% t(X_c)

# Step 3: Compute eigenvalues and eigenvectors of the small matrix
eigen <- eigen(small_matrix)
lambda <- eigen$values 
v <- eigen$vectors
remove(eigen)
remove(small_matrix)

# Step 4: Compute Sigma^ eigenvalues and eigenvectors
sigma_eigenvalues <- lambda / (nrow(ImgData) - 1)
sigma_eigenvectors <- t(X_c) %*% v 
sigma_eigenvectors <- apply(sigma_eigenvectors, MARGIN=2, function(x) x/sqrt(sum(x^2)))

# Step 5: Sort eigenvalues in descending order
sorted_indices <- order(sigma_eigenvalues, decreasing = TRUE)
sigma_values_sorted <- sigma_eigenvalues[sorted_indices]
sigma_vectors_sorted <- sigma_eigenvectors[, sorted_indices]
remove(sorted_indices)

# Get the 8th eigenvector
eigenface <- sigma_vectors_sorted[, 8]

# Map the values in the eigenvector to the interval 0 to 255
mapped_eigenface <- ((eigenface - min(eigenface)) / (max(eigenface) - min(eigenface))) * 255

# Reshape the mapped eigenvector to a matrix (assuming each eigenvector represents a pixel)
eigenface_matrix <- matrix(mapped_eigenface, nrow = sqrt(length(mapped_eigenface)), ncol = sqrt(length(mapped_eigenface)), byrow = TRUE)

# Rotate the matrix 90 degrees counter-clockwise
eigenface_matrix <- t(apply(eigenface_matrix, 2, rev))

# Plot the eigenface
image(eigenface_matrix, col = gray.colors(256), xaxt = "n", yaxt = "n", main = "DMOSDEN: Eigenface 8")

# Q11 - EigenFace for Glasses ---------------------------------------------

# Create a directory if it doesn't exist
if (!file.exists("EigenFaces")) {
  dir.create("EigenFaces")
}

# Loop through eigenvalues 1 to 20, plot corresponding eigenfaces, and export as PNG
for (i in 1:20) {
  # Get the i-th eigenvector
  eigenface <- sigma_vectors_sorted[, i]
  
  # Map the values in the eigenvector to the interval 0 to 255
  mapped_eigenface <- ((eigenface - min(eigenface)) / (max(eigenface) - min(eigenface))) * 255
  
  # Reshape the mapped eigenvector to a matrix (assuming each eigenvector represents a pixel)
  eigenface_matrix <- matrix(mapped_eigenface, nrow = sqrt(length(mapped_eigenface)), ncol = sqrt(length(mapped_eigenface)), byrow = TRUE)
  
  # Rotate the matrix 90 degrees counter-clockwise
  eigenface_matrix <- t(apply(eigenface_matrix, 2, rev))
  
  # Export the plot as a PNG file
  png(file = paste("EigenFaces/eigenface_", i, ".png", sep = ""), width = 800, height = 800)
  image(eigenface_matrix, col = gray.colors(256), xaxt = "n", yaxt = "n", main = paste("Eigenface for the", i, "Eigenvector"))
  dev.off()
}

remove(sigma_eigenvalues)
remove(sigma_eigenvectors)
remove(sigma_vectors_sorted)
remove(sigma_values_sorted)
remove(v)
remove(lambda)
remove(eigenface_matrix)
remove(eigenface)
remove(mapped_eigenface)
remove(i)
remove(AveFace)

# Q12: Comparing Eigen values/vectors -------------------------------------

# Compute the eigenvectors for the centered data matrix

# Step 1: Center the data
AveFace <- apply(ImgData,2,mean)
X_c <- sweep(ImgData,2,AveFace,FUN="-")

# Step 2: Compute small matrix
small_matrix_c <- X_c %*% t(X_c)

# Step 3: Compute eigenvalues and eigenvectors of the small matrix
out_c <- eigen(small_matrix_c%*%t(small_matrix_c))

# Step 4: Compute Sigma^ eigenvalues and eigenvectors
n_c <- nrow(small_matrix_c)
Vecs_c <- t(small_matrix_c)%*%out_c$vectors[,-n_c]
VecNorms_c <- sqrt(apply(Vecs_c*Vecs_c,2,sum))
Vecs_c <- sweep(Vecs_c,2,VecNorms_c,FUN="/")

# remove variables to ensure there's no re-use by accident
remove(out_c, small_matrix_c, X_c, AveFace, n_c, VecNorms_c)



# Compute the eigenvectors for the original, uncentered data matrix

# Step 1: Compute small matrix
small_matrix_og <- ImgData %*% t(ImgData)

# Step 2: Compute eigenvalues and eigenvectors of the small matrix
out_og <- eigen(small_matrix_og%*%t(small_matrix_og))

# Step 3: Compute Sigma^ eigenvalues and eigenvectors
n_og <- nrow(small_matrix_og)
Vecs_og <- t(small_matrix_og)%*%out_og$vectors[,-n_og]
VecNorms_og <- sqrt(apply(Vecs_og*Vecs_og,2,sum))
Vecs_og <- sweep(Vecs_og,2,VecNorms_og,FUN="/")

remove(out_og, small_matrix_og, n_og, VecNorms_og)



# Now compare the values

# Calculate the absolute difference between corresponding cells
differences <- abs(Vecs_og - Vecs_c)

# Check if all differences are zero (matrices are the same)
areEqual <- all(differences == 0)

# Print the result
print(sum(differences))
print(areEqual)

remove(differences, areEqual, Vecs_c, Vecs_og)

# Q14: Centered PCA (20 Dimensions) ---------------------------------------

# FIX From solutions
AveFace <- apply(ImgData,2,mean)
X_c <- sweep(ImgData,2,AveFace,FUN="-")

# Step 2: Compute small matrix
small_matrix <- X_c %*% t(X_c)

# Step 3: Compute eigenvalues and eigenvectors of the small matrix
out <- eigen(X_c%*%t(X_c))

# Step 4: Compute Sigma^ eigenvalues and eigenvectors
n <- nrow(X_c)
Vecs <- t(X_c)%*%out$vectors[,-n]
VecNorms <- sqrt(apply(Vecs*Vecs,2,sum))
Vecs <- sweep(Vecs,2,VecNorms,FUN="/")

PC <- ImgData%*%Vecs[,1:20]

reconstructed_images <- PC%*%t(Vecs[,1:20])

NetID <- "dmosden"
whImg <- match(NetID,rownames(ImgData))
# Reconstruct the specific image as a 451x451 matrix so we can print it out using image()
Img <- matrix(reconstructed_images[whImg,],byrow=T,ncol=sqrt(ncol(reconstructed_images)))
Img <- apply(Img,2,rev)
image(z=t(Img),col = grey.colors(255),useRaster=T)
title(paste(rownames(ImgData)[whImg],": Reconstructed Image",sep=""),line=-1,cex.main=0.5)

remove(Img, out, PC, reconstructed_images, small_matrix, Vecs, X_c, AveFace, n, NetID, VecNorms, whImg)
