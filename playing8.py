# -*- coding: utf-8 -*-
"""
Created on Thu Nov  9 14:52:15 2023

@author: maria
"""

import cv2
import numpy as np
import pydicom as dicom
import os
import pickle

# Create a list to store the processed ellipse areas
processed_ellipse_areas = []

hearts_folder = 'C:/Users/maria/OneDrive/Desktop/heart_mri/HYPER'
output_folder = 'C:/Users/maria/OneDrive/Desktop/heart_mri/Hyper ellipses2'

for filename in os.listdir(hearts_folder):
    if filename.endswith('.dcm'):
        heart_path = os.path.join(hearts_folder, filename)
        heart = dicom.dcmread(heart_path)
        image = heart.pixel_array
        frame_heart = np.array(image, dtype="uint8")

        # Normalize the image to the range [0, 1]
        normalized_image = frame_heart / 255.0

        # Find the center of the image
        center_x, center_y = frame_heart.shape[1] // 2, frame_heart.shape[0] // 2

        # Create a bigger ellipse with an anticlockwise rotation
        major_axis = 100  # Adjust as needed
        minor_axis = 60  # You can adjust the aspect ratio as needed
        angle = -45  # Rotation angle (-45 for anticlockwise rotation)

        # Create an empty elliptical mask
        mask = np.zeros_like(normalized_image, dtype=np.uint8)

        # Create the elliptical mask with white (1) inside the ellipse
        cv2.ellipse(mask, (center_x, center_y), (major_axis, minor_axis), angle, 0, 360, 1, -1)

        # Multiply the processed image by the mask to keep only the ellipse area
        masked_image = normalized_image * mask

        # Append the processed image with the ellipse to the list
        processed_ellipse_areas.append(masked_image)

        # Print the result
        tumor_detection = "Anticlockwise Ellipse (Circumference)"
        print(f"Image: {filename} - {tumor_detection}")

# Save the processed images with elliptical areas to a file
os.makedirs(output_folder, exist_ok=True)

for i, processed_image in enumerate(processed_ellipse_areas):
    output_path = os.path.join(output_folder, f"image_{i}.png")
    cv2.imwrite(output_path, (processed_image * 255).astype(np.uint8))

print("Processing complete. Processed images with anticlockwise ellipses (circumference) saved in:", output_folder)
