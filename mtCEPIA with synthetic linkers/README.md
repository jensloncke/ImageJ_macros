# mtCEPIA with synthetic linkers

## Purpose of this script
This folder contains an ImageJ macro that semi-automates **single-cell selection** based on fluorescence of a **mitochondrially localized RFP** and data acquisition from raw **single channel fluorescence microcopy data**.
Images for testing this macro were acquired using a Nikon TI2-E microscope and the NIS elements software. This macro requires one single acquisition .nd2 file (RFP snap) for cell selection and one single channel .nd2 input file (mtCEPIA time series).

## How to operate this macro

* Run the macro
* Specify the required parameters
  * Time_series: path to your single channel .nd2 measurement
  * RFP_snap: path to your single acquisition of transfected cells
  * Folder_results: path to your output folder
  * BG_rolling_ball_radius: radius of the **largest object** in your sample for background subtraction. For more information see: https://imagej.nih.gov/ij/docs/menus/process.html#:~:text=The%20Rolling%20Ball%20Radius%20is,the%20image%20is%20too%20uneven.
![image](https://user-images.githubusercontent.com/38840043/222684005-68281491-91f5-4303-8e35-4866e09889ab.png)
* Press OK
*The Bio-Formats plugin will prompt the import window. Select 'Hyperstack' as stack viewer and tick 'Split channels'. If you want to prevent this window from opening in the future, activate the windowless version of Bio-Formats in ImageJ.
![image](https://user-images.githubusercontent.com/38840043/222672367-9e25e26e-95ce-48be-aa54-545bd6a490df.png)
* Verify whether thresholded ROIs require adaptation through user intervention. Mitochondrial RFP signal is generally quite poor, which decreases the accuracy of automated thesholding.
* When finished, press OK
![image](https://user-images.githubusercontent.com/38840043/222685287-8000d387-aafb-4952-af00-ac1574024329.png)
* ROIs and numeric data (.csv) are saved in seperate folders
