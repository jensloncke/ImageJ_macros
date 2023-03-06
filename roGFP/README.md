# roGFP

## Purpose of this script
This folder contains an ImageJ macro that semi-automates **single-cell selection** based on fluorescence of  **roGFP signal** and data acquisition from raw **FURA-2 fluorescence microcopy data (2 channels)**, excited at 405nm and 488nm and acquired at 510nm.
Images for testing this macro were acquired using a Nikon TI2-E microscope and the NIS elements software. This macro requires one two channel .nd2 input file.

## How to operate this macro

* Run the macro
* Specify the required parameters
  * Time_series: path to your FURA-2 .nd2 measurement
  * Folder_results: path to your output folder
  * BG_rolling_ball_radius: radius of the **largest object** in your sample for background subtraction. For more information see: https://imagej.nih.gov/ij/docs/menus/process.html#:~:text=The%20Rolling%20Ball%20Radius%20is,the%20image%20is%20too%20uneven.
![image](https://user-images.githubusercontent.com/38840043/223061959-82675a2c-fee4-4caf-afc9-7875e89f272e.png)
* Press OK
* The Bio-Formats plugin will prompt the import window. Select 'Hyperstack' as stack viewer and tick 'Split channels'. If you want to prevent this window from opening in the future, activate the windowless version of Bio-Formats in ImageJ.
![image](https://user-images.githubusercontent.com/38840043/222672367-9e25e26e-95ce-48be-aa54-545bd6a490df.png)
* Verify whether thresholded ROIs require adaptation through user intervention
* When finished, press OK
![image](https://user-images.githubusercontent.com/38840043/223062589-721372e4-2cd5-4eca-87cc-20dfcc8b7f07.png)
* ROIs and numeric data (.csv) are saved in seperate folders
