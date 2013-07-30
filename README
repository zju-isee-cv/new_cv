This program is based on the Toolbox written by Christopher Mei and the files related to calibration with C.Mei model stay under his own right, the rest of the program is under the GPL license version 2, please read GPL.txt for more information.


## 1.Introduction of the Toolbox

The Non-central Catadioptric Camera Toolbox for matlab allows the user to calibrate not only any central omnidirectioanal camera (any panoramic camera having a single effective viewpoint) but also non-central camera due to the misalignment between the reflective mirror and the camera.
The Toolbox implements the procedure described in the paper which proposed a novel model for non-central catadioptric cameras and give out a method for calibration. 
The Toolbox permits easy and practical calibration of the omnidirectional camera through two steps. At first, it requires the user to take a few pictures of a checkerboard shown at different position and orientations. Then, the user is asked to click manually on the corner points. After these two steps, calibration is completely automatically performed. After calibration, the Toolbox provides the relation between a given pixel point and 3D vector emanating from the single effective view point. This relation clearly depends on the mirror shape and on the intrinsic parameters of the camera.The novel aspects of the Non-central Catadioptric Camera Toolbox with aspect to other implementations are following:
* The Toolbox does not require a priori knowledge about the mirror shape.
* It does not require calibrating separately the perspective camera: the system camera and mirror is treated as a unique compact system.
*  The calibration of the central or non-central systems can be treated with equal simplicity.

The calibration performed by the Non-central Catadioptric Camera Toolbox can lead to an equally simple calibration for both central and non-central systems. In fact, the Toolbox is able to provide an optimal solution even when the misalignment between the reflective and the camera is severe.

The calibration will estimate:
1 the extrinsic parameters corresponding to the rotation (quaternion : Qw) and translation (Tw) between the grid and the mirror
2 the parameters describing the mirror shape (xi)
3 the distortion induced by the lens (eg. telecentric) (kc)
4 the intrinsic parameters of the generalised camera : skew (alpha_c), generalised focal lengths (gamma1,gamma2) and principal points (cc)
5 the vector (-xi1,-xi2,-xi3): denote the position of the original projection center.

## 2.Software requirements
The Non-central Catadioptric Camera Toolbox for Matlab has been successfully tested under Matlab, version 2009b and 2010b for Windows.
The Calibration Refinement routine requires the Matlab Optimization Toolbox, in particular the function lsqnonlin, which you should have by default.

## 3.Download, install and run the Toolbox
You can download the Non-central Catadioptric Camera Toolbox from here: [ToolBox](https://github.com/zju-isee-cv/new_cv) Unzip the file, run Matlab (it’s better to add the path of this Toolbox to matlab’s set path), and type ocam_calib_gui

## 4.Startup
Please edit the ‘SETTINGS.m’ file first. Start the toolbox in Matlab:
`omni_calib_gui`

## 5.Mirror type
This step is only to constrain the minimization in the parabolic case (xi=1) and to avoid trying to extract the mirror border in the dioptric.

## 6.Loading images
“Load images” will ask you for the base name of the images in the current directory and their format

## 7.Estimating the intrinsic parameters with the mirror border
By pressing on `Estimate camera intri`, we will calculate an estimate of the intrinsic parameter of the underlying camera (generalized focal length and center). In the case of a catadioptric sensor, the user is asked to click on the center of the mirror

When then estimate the generalized focal length from points on a line image

## 8.Extracting grid corners
We are now ready to extract the grid corners which will be used during the minimization, press on `Extract grid corners1`

Sub-pixel extraction in the catadioptric case is less tolerant and we should try and keep the window size down.

This extraction is semiautomatic written by C.Mei. It works well under slight misalignment. But under severe misalignment, it work not so good. That why we need manual extraction as is showed in 9.

## 9.Extracting grid corners manually
Generally you can use the grid corners extracted automatically in Step 8.But when the misalignment between the reflective mirror and the camera is severe; there is much error in the extraction. So this function allows you to extract the corners manually. Press on `Extracting grid corners manually`

You need to manually extract every grid corners of the images which you are asked to choose in Step 8. This task may be a little bit time-consuming and boring, so you should be more patient and careful.

## 10.Change_corners
We now have two sets of coordinates of grid corners. By pressing on `Change_corners`, we can use the grid corners which are extracted automatically or manually for further optimization. In order to verify the type of the grid corners, we set a variable “manual” in the “gridInfo” struct. It means the grid corners is extracted manually when “manual” is 1 and automatically when “manual” is 0.

## 11.InitializeRT
After extracting the corner grids, it is better to obtain an initial estimate for the extrinsic parameters to further stabilize the optimization. The initialization of R and T are both stored in ‘paramEst.Qw_est{i}’, ‘paramEst.Tw_est{i}’ and ‘paramEst3D_Qw_est{i}’, ‘paramEst.Tw_est{i}’.

## 12.AssignRTest
Pressing on `AssignRTest` will assign the initialization of extrinsic parameters which are initialized in Step 11 to ‘paramEst.Qw’ and ‘paramEst.Tw’ and we now have the initial values of the optimization.

## 13.Calibration of two methods
Pressing on `Calibration of two methods` will start the minimization with two models, one is C.mei’s model and the other is our improved model.

## 14.Analysis_angle
To further verify the performance of our model quantitatively, we employed a trithedral object composed of three orthogonal planes and the angles between the planes are calculated from the calibrated extrinsic parameters RwQw.

## 15.Other buttons
1 "Calib new RT"computes the extrinsic parameters in the case of known intrinsic parameters.
2 "Show calib results" show the calibration values and errors
3 "Save" saves the extrinsic and intrinsic parameters, the grid points, ...
4 "Load" loads the values obtained during the calibration
5 "Exit" quits the program


*References*

1 Zhiyu Xiang, Xing Dai and Xiaojin Gong, Noncentral catadioptric camera calibration using a generalized unified model, Optics Letters, Vol.38 (9), 1367-1369, 2013
2 Geyer, Christopher, and Kostas Daniilidis. "A unifying theory for central panoramic systems and practical implications." Computer Vision—ECCV 2000. Springer Berlin Heidelberg, 2000. 445-461.
3 Mei, Christopher, and Patrick Rives. "Single view point omnidirectional camera calibration from planar grids." Robotics and Automation, 2007 IEEE International Conference on. IEEE, 2007.
4 Grossberg, Michael D., and Shree K. Nayar. "The raxel imaging model and ray-based calibration." International Journal of Computer Vision 61.2 (2005): 119-137.
5 Gonçalves, Nuno, and Helder Araújo. "Estimating parameters of non-central catadioptric systems using bundle adjustment." Computer Vision and Image Understanding 113.1 (2009): 11-28.
6 Xiang, Zhiyu, Bo Sun, and Xing Dai. "The camera itself as a calibration pattern: A novel self-calibration method for non-central catadioptric cameras." Sensors 12.6 (2012): 7299-7317.
7 OmnidirectionalCalibration Toolbox,http://homepages.laas.fr/~cmei/index.php/Toolbox
