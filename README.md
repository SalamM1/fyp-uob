# UoB CS - BSc. Final Year Project
# Emotion Classification from Speech Data

This is the repository of Faisal I M H Alrajhi, a student in the University of Birmingham's School of Computer Science. The files relating to the BSc. Final Year Project (40 credits) are all in this repository.

*NOTE:* In the interest of both file size and ethics, the audio files are not uploaded with the MATLAB code. 
However, PlotLDA and ClassifyLDA should still work as intended. The MATLAB should be well documented.*

## Project Summary
Emotion recognition from speech is important with tasks involving Human-Machine interaction, such as with automated voice systems Amazon Alexa and Google Home. The main issues in this field are related to the search for highly discriminate features and appropriate features and classification methods. In this project, I am to:

 1. Conduct an appropriate literature review regarding relative topics, primarily Emotion Recognition and Speech Signal Processing, that use more recent techniques in the field, such as Neural Networks and IVectors.
 2. Familiarise with the data in the PF Star corpus and with relevant emotional recognition research involving it.
 3. Apply Signal Processing techniques to convert the Analogue speech signal into usable digital data, ideally into IVectors as feature vectors.
 4. Use the processed signals to train a baseline Deep Neural Network (DNN) classifier.

If time is available, the additional objectives of optimising the classifier and testing the classifier for cross-language (English and German) emotion recognition will be explored. Challenges will be faced during Signal Processing and Feature Extraction due to it being the area I have the least experience in.

## Programming
The programming languages that will be used in the project are MATLAB and Python, with some reliance on libraries and add-ons.
### MATLAB
 * PlotLDA - loads labels and ivectors and plots the 5x5 LDA image found in the report.
 * ClassifyLDA - Baseline classifiers of nearest neighbor with cosine similarity and euclidean distance.
 * FeatureExtraction - mains script to convert audio files into
 * GetLabelsAsArray - converts the labelled segments into 5302x2 file of ID and label.
 * WriteFile - writes the features/labels to csv files used in Python
 * read_audio_file - function to read file
 * extract_mfcc - function to do MFCC extraction
 
### Python
Required Libraries
 * Keras
 * Matplotlib
