# Fluo-4 and mtCEPIA

## Purpose of this script
This folder contains an ImageJ macro that semi-automates **single-cell selection** based on fluorescence of a **Ca2+ indicator** and simultaneous data acquisition from raw **Fluo-4 fluorescence microcopy data (1 channel)**, as well as an additional channel for the mitochondrial stain (typically red or green).
The ROIs created by this macro are based on the cyosolic Ca2+ sensor. Images for testing this macro were acquired using a Nikon TI2-E microscope and the NIS elements software. This macro requires a two channel .nd2 input file.

## How to operate this macro

* Run the macro
* Specify the required parameters
  * Time_series: path to your Time series .nd2 measurement
  * Fluo-4 channel: channel of Fluo-4 signal
  * mtCEPIA channel: channel of mitochondrial signal
  * Folder_results: path to your output folder
  * BG_rolling_ball_radius: radius of the **largest object** in your sample for background subtraction. For more information see: https://imagej.nih.gov/ij/docs/menus/process.html#:~:text=The%20Rolling%20Ball%20Radius%20is,the%20image%20is%20too%20uneven.
  * Transfection_RFU_cutoff: threshold of absolute fluorescence intensity of the final frame of acquisition of a ROI below which the cell is considered untransfected or unstained.
*The Bio-Formats plugin will prompt the import window. Select 'Hyperstack' as stack viewer and tick 'Split channels'. If you want to prevent this window from opening in the future, activate the windowless version of Bio-Formats in ImageJ.
![image](https://user-images.githubusercontent.com/38840043/222672367-9e25e26e-95ce-48be-aa54-545bd6a490df.png)
![image](https://user-images.githubusercontent.com/38840043/222531717-991d0687-b0c9-46a2-a841-285ec7317a2b.png)
* Press OK
* Verify whether thresholded ROIs require adaptation through user intervention
* When finished, press OK
![2023-01-09 (1)](https://user-images.githubusercontent.com/38840043/211396777-480df19a-10ad-4df0-a7d0-b0987f950fc9.png)
* ROIs and numeric data (.csv) are saved in seperate folders
