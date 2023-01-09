# FURA transfected cells

## Purpose of this script
This folder contains an ImageJ macro that semi-automates **single-cell selection** based on fluorescence of a **genetically encoded dye** and data acquisition from raw **FURA-2 fluorescence microcopy data (2 channels)**, excited at 340nm and 380nm and acquired at 510nm.
Images were acquired using a Nikon TI2-E microscope and the NIS elements software. This macro requires one single acquisition .nd2 file for cell selection and one two channel .nd2 input file.

## How to operate this macro

* Run the macro
* Specify the required parameters
  * Time_series: path to your FURA-2 .nd2 measurement
  * MCherry: path to your single acquisition of transfected cells
  * Folder_restuls: path to your output folder
  * BG_rolling_ball_radius: radius of the **largest object** in your sample for background subtraction. For more information see: https://imagejdocu.list.lu/gui/process/subtract_background#:~:text=The%20Rolling%20Ball%20Radius%20is,the%20image%20is%20too%20uneven.
![2023-01-09 (2)](https://user-images.githubusercontent.com/38840043/211395430-6718ef0c-4448-44c5-bd25-c84e05e43831.png)
* Press OK
* Verify whether thresholded ROIs require adaptation through user intervention
* When finished, press OK
![2023-01-09 (1)](https://user-images.githubusercontent.com/38840043/211396777-480df19a-10ad-4df0-a7d0-b0987f950fc9.png)
* ROIs and numeric data (.csv) are saved in seperate folders