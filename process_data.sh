
file_ap="sub-acdc224_ap"
file_pa="sub-acdc224_pa"
ext=".nii.gz"

# Average across time
sct_maths -i ${file_ap}$ext -mean t -o ${file_ap}_mean$ext
sct_maths -i ${file_pa}$ext -mean t -o ${file_pa}_mean$ext

file_ap=${file_ap}_mean
file_pa=${file_pa}_mean

# Segment spinal cord
# TODO: replace with Rohan model and manually edit the segmentation
sct_deepseg_sc -i ${file_ap}$ext -c t2 -qc qc
sct_deepseg_sc -i ${file_pa}$ext -c t2 -qc qc
file_seg_ap=${file_ap}_seg
file_seg_pa=${file_pa}_seg

# Register slicewise
sct_register_multimodal -i ${file_ap}$ext -d ${file_pa}$ext -iseg ${file_seg_ap}$ext -dseg ${file_seg_pa}$ext -param step=1,type=seg,algo=centermass -qc qc

# Split warping field into XYZ
sct_image -i warp_${file_ap}2${file_pa}$ext -mcs 
# Note: the warp of interest is along Y (AP/PA)

# Extract slice value in CSV file
sct_extract_metric -i warp_${file_ap}2${file_pa}_Y$ext -f ${file_seg_ap}$ext -method median -o y_displacement.csv


