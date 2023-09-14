# Image-compression-AND-Audio-spectral-analysis-and-filtering

1- Image Compression:

A simple image compression algorithm is performed. First an input image is read and process each of its color components (red, green, and blue) in blocks of 8 × 8 pixels. 

Each block will be converted into frequency domain using 2D DCT and then only few coefficients are retained, while the rest will be ignored.

Finally the image is decompressed by applying inverse 2D DCT to each block to compare quality


2- Audio Spectral Analysis and Filtering:

An audio file which is corrupted by some interference is analyzed, identifying the interference, and filtering the audio signal to remove the interference
