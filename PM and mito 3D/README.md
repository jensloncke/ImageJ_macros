# PM and mito 3D

## Purpose of these scripts
This folder contains a collection of scripts for **two channel** Z-stack confocal acquisitions, where the **plasma membrane** is stained in one channel (e.g. with CellMask plasma membrane orange stain). The 'PM and mito 3D' script was designed to quantify mitochondrial volume and whole cell volume on a single-cell basis.
The 'PM mito contact' script was tailored for quantification of quantifying the contact between the plasma membrane and mitochondria. Images for testing this macro were recorded on a Zeiss Axiovert 100M confocal microscope

## How to operate PM and mito 3D

* Run the macro
* Specify the required parameters
  * stack: path to your dual channel .nd2 acquisition
  * Folder_results: path to your output folder
![image](https://user-images.githubusercontent.com/38840043/222730707-99d57d15-0633-4a65-83d6-68119f5968b5.png)
* Press OK
*The Bio-Formats plugin will prompt the import window. Select 'Hyperstack' as stack viewer and tick 'Split channels'. If you want to prevent this window from opening in the future, activate the windowless version of Bio-Formats in ImageJ.
![image](https://user-images.githubusercontent.com/38840043/222672367-9e25e26e-95ce-48be-aa54-545bd6a490df.png)
* Manually circle the cells you want to include in the analysis and add them to the ROI manager by pressing 't'. Outlining does not have to be perfect, but ensure no other cell is caught in the shape.
![image](https://user-images.githubusercontent.com/38840043/222721901-e491dc94-d2ca-4f46-9b46-15cdcd5c7caa.png)
* When finished, press OK
* Navigate to the first in-focus stack of your current cell.
* Navigate to the last in-focus stack of your current cell.
* The macro will quantify mitochondrial and whole cell area per Z-slice.
* Numeric data of mitochondria and whole cells are saved in seperate files (.csv) 

## How to operate PM mito contact

* Run the macro
* Specify the required parameters
  * stack: path to your dual channel .nd2 acquisition
  * Folder_results: path to your output folder
![image](https://user-images.githubusercontent.com/38840043/222729376-6cf5945b-a129-4269-a9e4-1d86d82084cc.png)
* Press OK
*The Bio-Formats plugin will prompt the import window. Select 'Hyperstack' as stack viewer and tick 'Split channels'. If you want to prevent this window from opening in the future, activate the windowless version of Bio-Formats in ImageJ.
![image](https://user-images.githubusercontent.com/38840043/222672367-9e25e26e-95ce-48be-aa54-545bd6a490df.png)
* Manually circle the cells you want to include in the analysis and add them to the ROI manager by pressing 't'. Outlining does not have to be perfect, but ensure no other cell is caught in the shape.
![image](https://user-images.githubusercontent.com/38840043/222729989-50f8c6d3-07fd-4e9e-9aa8-e92d6a84a9e2.png)
* When finished, press OK
* Navigate to the first in-focus stack of your current cell.
* Navigate to the last in-focus stack of your current cell.
* The macro will quantify the fraction of whole cell area that does not include mitochondrial area per Z-slice as a measure of extent of mitochondrial plasma membrane contact.
* Numeric data are saved in seperate files (.csv) 