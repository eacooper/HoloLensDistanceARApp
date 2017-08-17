# HoloLens App for displaying distance-based shaders

## Requirements
This application is based of the MS HoloToolkit and in particular it uses the spatial mapping abilities. Basic familiarity with developing and deploying for MS HoloLens is assumed. 

To get started with HoloLens, follow tutorials on the HoloAcademy website (Holograms 101, 212, and 230 in particular): https://developer.microsoft.com/en-us/windows/mixed-reality/academy 

For ease of use, some assets from the HoloToolkit are included.

### Software
See MS installation checklist: https://developer.microsoft.com/en-us/windows/mixed-reality/install_the_tools 

builds with:

Visual Studio 2015 Update 3

Unity 5.4.0f3

make sure project is set up to work with Github:
http://www.studica.com/blog/how-to-setup-github-with-unity-step-by-step-instructions

### Hardware
- MS HoloLens enabled for developer mode: https://developer.microsoft.com/en-us/windows/mixed-reality/Using_Visual_Studio.html#enabling_developer_mode 
- Bluetooth clicker (toggles augmentation on and off)
- Bluetooth keyboard (needed to cycle through the different augmentations)

## Deploying the app
1. Clone repo to your computer 
2. Open project in Unity (make sure that the CCShader scene is loaded)
3. Build and Deploy (see HoloAcademy for tutorials)

## Using the app
### General App description
The app simplifies a visual scene by overlaying colored augmentations. The application measures the distance of surfaces and objects in the environment 
from the user by accessing the HoloLens's spatial mesh. Distances are then discretized and mapped into a set of bands, each with a unique color value. 
The bands are directly overlaid semi-transparently on the environment in stereoscopic 3D when viewed through the displays 
### Clicker and keyboard commands
* **Toggle augmentations**: The user can toggle the augmentations by using a paired Bluetooth clicker, airtapping or with the Q and Z key on a paired keyboard.
* **Select augmentations**: The user can select the different variations of augmentations using the keyboard:
	* Q	->	Shader Off
	* W	->	Red to Blue
	* E	->	Blue to Red
	* R ->	Bright Red to Blue
	* T	->	Bright Blue to Red
	* Y	->	Orange to Purple
	* U	->	Purple to Orange
	* I	->	Yellow to Blue
	* O	->	Blue to Yellow
	* P	->	Blue Luminance
	* A	->	Red Luminance
	* S	->	Green Luminance
	* D	->	Blue to White
	* F	->	White to Blue
	* G	->	Red to White
	* H	->	White to Red
	* J	->	Green to White
	* K	->	White to Green





