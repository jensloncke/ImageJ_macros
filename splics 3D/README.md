# splics 3D

## Purpose of these scripts
This folder contains a script for **single channel** Z-stack confocal acquisitions, of cells expressing the MAM-sensor **SPLICS**. The 'splics 3D' script was designed to quantify ER-mitochondrial contact volume and numer of contact sites as well as whole cell volume on a single-cell basis. The macro requires a single channel .lsm Z-stack file.

To run this macro the VolumeJ plugin is used to 3D render from Z-stack slices. Install from: http://www.cyto.purdue.edu/cdroms/micro2/content/software/volumej.htm .
The Voxel Counter plugin is used to calculate cell volumes: https://imagej.nih.gov/ij/plugins/voxel-counter.html .

## How to operate splics 3D

* Run the macro
* Specify the required parameters
  * stack: path to your dual channel .nd2 acquisition
  * Folder_results: path to your output folder
![image](https://user-images.githubusercontent.com/38840043/223073093-9ac75014-47c3-429c-8881-0d025abda283.png)
* Press OK
*The Bio-Formats plugin will prompt the import window. Select 'Hyperstack' as stack viewer and tick 'Split channels'. If you want to prevent this window from opening in the future, activate the windowless version of Bio-Formats in ImageJ.
![image](https://user-images.githubusercontent.com/38840043/222672367-9e25e26e-95ce-48be-aa54-545bd6a490df.png)
* Manually circle the cells you want to include in the analysis based on the splics background signal or a corresponding Brighfield acquisition and add them to the ROI manager by pressing 't'.
![image](https://user-images.githubusercontent.com/38840043/223074933-b5e723b6-058e-4a94-be37-4aa75ad0e194.png)
* When finished, press OK
* Navigate to the first in-focus stack of your current cell.
* Navigate to the last in-focus stack of your current cell.
* The macro will quantify nu,ber of contact sites as well as contact volume per cell.
* Numeric data of mitochondria and whole cells are saved in seperate files (.csv) 