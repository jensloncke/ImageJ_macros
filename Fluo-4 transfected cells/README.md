# Fluo-4 transfected cells

## Purpose of this script
This folder contains an ImageJ macro that semi-automates **single-cell selection** based on fluorescence of a **genetically encoded dye** and data acquisition from raw **single channel fluorescence microcopy data (e.g. Fluo-4)**.
Images for testing this macro were acquired using a Nikon TI2-E microscope and the NIS elements software. This macro requires one single acquisition .nd2 file for cell selection and one single channel .nd2 input file.

## How to operate this macro

* Run the macro
* Specify the required parameters
  * Time_series: path to your single channel .nd2 measurement
  * mCherry: path to your single acquisition of transfected cells
  * Folder_results: path to your output folder
  * BG_rolling_ball_radius: radius of the **largest object** in your sample for background subtraction. For more information see: https://imagej.nih.gov/ij/docs/menus/process.html#:~:text=The%20Rolling%20Ball%20Radius%20is,the%20image%20is%20too%20uneven.
![image](https://user-images.githubusercontent.com/38840043/221667167-c4f7dd06-cd01-4e68-84e9-5e6940e82806.png)
* Press OK
* The Bio-Formats plugin will prompt the import window. Select 'Hyperstack' as stack viewer and tick 'Split channels'. If you want to prevent this window from opening in the future, activate the windowless version of Bio-Formats in ImageJ.
![image](https://user-images.githubusercontent.com/38840043/222672367-9e25e26e-95ce-48be-aa54-545bd6a490df.png)
* Verify whether thresholded ROIs require adaptation through user intervention
* When finished, press OK
![2023-01-09 (1)](https://user-images.githubusercontent.com/38840043/211396777-480df19a-10ad-4df0-a7d0-b0987f950fc9.png)
* ROIs and numeric data (.csv) are saved in seperate folders
