# mtKeima

## Purpose of this script
This folder contains an ImageJ macro that semi-automates **single-cell selection** based on fluorescence of the mitophagy probe **mtKeima red** and fluorescence + puncti count data acquisition from raw **dual channel fluorescence microcopy data** on a single-cell basis.
Images for testing this macro were acquired using a Nikon TI2-E microscope and the NIS elements software. This macro requires one single acquisition .nd2 file with two channels.

## How to operate this macro

* Run the macro
* Specify the required parameters
  * stack: path to your dual channel .nd2 acquisition
  * Folder_results: path to your output folder
![image](https://user-images.githubusercontent.com/38840043/222691592-7537328d-38e8-417e-bb4f-e7f292a06c8f.png)
* Press OK
*The Bio-Formats plugin will prompt the import window. Select 'Hyperstack' as stack viewer and tick 'Split channels'. If you want to prevent this window from opening in the future, activate the windowless version of Bio-Formats in ImageJ.
![image](https://user-images.githubusercontent.com/38840043/222672367-9e25e26e-95ce-48be-aa54-545bd6a490df.png)
* Verify whether thresholded ROIs require adaptation through user intervention. Mitochondrial Keima signal is generally quite poor, which decreases the accuracy of automated thesholding.
* When finished, press OK
![image](https://user-images.githubusercontent.com/38840043/222692161-7b18a1cb-4ead-414a-92a7-f890999ec362.png)
* ROIs and numeric data (.csv) are saved in seperate folders
