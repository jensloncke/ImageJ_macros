# mtCEPIA individual mitochondria

## Purpose of this script
This folder contains an ImageJ macro that semi-automates **selection of single mitchondria** based on fluorescence of the Ca2+ sensitive protein **mtCEPIA**. For optimal performance, mtCEPIA signal should be bright and acquisitions should be relatively short. Depending on mitochondrial drift, longer measurements will result in inaccurate detection of mitochondria. 
Images for testing this macro were acquired using a Nikon TI2-E microscope and the NIS elements software. This macro requires a .nd2 input file.

## How to operate this macro

* Run the macro
* Specify the required parameters
  * Time_series: path to your Time series .nd2 measurement
  * mtCEPIA channel: channel of mitochondrial signal
  * Folder_results: path to your output folder
  * BG_rolling_ball_radius: radius of the **largest object** in your sample for background subtraction. For more information see: https://imagej.nih.gov/ij/docs/menus/process.html#:~:text=The%20Rolling%20Ball%20Radius%20is,the%20image%20is%20too%20uneven.
* The Bio-Formats plugin will prompt the import window. Select 'Hyperstack' as stack viewer and tick 'Split channels'. If you want to prevent this window from opening in the future, activate the windowless version of Bio-Formats in ImageJ.
![image](https://user-images.githubusercontent.com/38840043/222672367-9e25e26e-95ce-48be-aa54-545bd6a490df.png)
![image](https://user-images.githubusercontent.com/38840043/222538953-c83ab015-8350-4f29-b48a-d087dea753d9.png)
* Press OK
* Verify whether thresholded ROIs require adaptation through user intervention
* When finished, press OK
![image](https://user-images.githubusercontent.com/38840043/222539685-f1c7ac16-2a64-4b3f-8f4f-826ffee344b5.png)
* ROIs and numeric data (.csv) are saved in seperate folders
