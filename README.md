# Projection Mapping
## IAAC MRAC 19-20 | Hardware 2 | Group 2

### Description

A framework for physical interaction with graphical systems running in the Processing environment, using a Kinect for input and a basic homography system to to project accurate around the user.
The goal originally involved only projection mapping onto the user as a display surface, and expanded to employ the users movement in a larger visual field.

The featured interactive system lets up to four users carve and push a wall-sized field of vectors using their hands. Each user's influence is also highlighted with a specific color.  
The initial demo placed the users between the projector/camera and the wall, although better results may be achieved with a short-thow projector between the wall and the users.  
Finally clapping will reset the field.

### Setup and Use

## Installation
The framework was tested using a Kinect 2 on Windows 10.
First install the SDK for the camera being used, and Spout if choosing to use an external homography solution.

Within Processing, the following external libraries are used:
- **Kinect v2 For Processing** or **Intel Realsense for Processing** : Reading the depth camera
- **OpenCV for Processing** : Working with the depth camera input
- **G4P** : Allows the creation of multiple windows, used for calibration
- **Spout** : Streams video between local applications, if using an external homography solution
- **Sound** : Listens to the Kinect's microphone to track claps

The attached projector should be set as an extended display

## Calibration
Running the sketch with the 'calibrate' variable set to 'true' will allow the user to adjust the quadrilateral transformation of the output on the second window. Pressing the 1-4 keys will select each vertex of the canvas, and the user can click and drag to adjust its position. Pressing 's' will save the current calibration to a file, and pressing 'l' will reload the file's calibration. 


### Development

![Result](./doc/Feathers2.jpg)

![History](./doc/History.jpg)

### Process Description

**Software workflow:**

![workflow](./doc/workflow.jpg)

Calibration of the setting:
![calibration](./doc/calibration.jpg)


**Documentation:**

**1)** Blobs from OpenCV --> [link video](https://www.youtube.com/watch?v=LoU_e9nNRB8)
![First_Step](./doc/1.jpg)

**1.1)** *Blob Quality*
![First_Step](./doc/Blob_Quality.jpg)

**2)** *Clean Outlines* --> [link video](https://www.youtube.com/watch?v=uaYo_nu1j8A)
![Second_Step](./doc/2.jpg)

**3)** Calibration Homography --> [link video](https://www.youtube.com/watch?v=-CA7zrLlXVk)
![Third_Step](./doc/3.jpg)

**3.1)** *Calibration through Spout and Resolume Arena*
![Calibration](./doc/Delay_Test.jpg)

**3.1)** *Speed Test* --> [link video](https://www.youtube.com/watch?v=fbgv05gPEUY)
![Speed_Test](./doc/IMG_20200212_131307.jpg)

**3.2)** *Delay Test* --> [link video](https://www.youtube.com/watch?v=lHEGZzV15lw)
![Speed_Test](./doc/Delay_Test2.jpg)

**4)** *Clean Outlines Offsets* --> [link video](https://www.youtube.com/watch?v=eJJTYA-iC-M)
![Fourth_Step](./doc/4.jpg)

**5)** *Physics Engine Implementation* --> [link video](https://www.youtube.com/watch?v=-C0LxvOYOOE)
![Fifth_Step](./doc/5.jpg)

#### Graphics Exploration

**6)** Vector Fields V1
.
.

![Vector1](./doc/v1-tot.jpg)

.
.

Vector Fields V2

![Vector2](./doc/v2.jpg)

.
.

Vector Fields V3

![Vector2](./doc/v3.jpg)

.
.

Vector Fields V4

![Vector4](./doc/v4.jpg)

.
.

Vector Fields V5

![Vector5](./doc/v5.jpg)

.
.

Vector Fields V6

![Vector6](./doc/v61.jpg)

![Vector6](./doc/v62.jpg)

.
.

Vector Fields V7

![Vector6](./doc/v7.jpg)

.
.

**7)** *Vector Field Implementation* --> [link video](https://www.youtube.com/watch?v=Rx-mc5FtOwc)
![Fifth_Step](./doc/Feathers.jpg)

### Requirements

**Processing Libraries:**

* *opencv*

* *KinectPV2*

* *Sound*

* *g4p_controls*

* *spout**

* *realSense**

**Optional functionality depending on available hardware*


#### Electronics and Hardware

Input and Output
![Workflow](./doc/diagram.jpg)

Kinect2 + Video Projector Casio xj-a242
 *   ![hardware](./doc/hardw.jpg)


### References:

* [Withouttitle-interactive, generative Online Application](https://www.liaworks.com/theprojects/withouttitle/)
* [Vector Field by tsulej](https://generateme.wordpress.com/2016/04/24/drawing-vector-field/)

 **Credits**


 _Based on IAAC publishing guidelines:
 (Projection Mapping) is a project of IaaC, Institute for Advanced Architecture of Catalonia. developed at Master in Robotics and Advanced Construction in 2019-2020 by:
 Students: (Anna Batalle, Matt Gordon, Lorenzo Masini, Roberto Vargas)
 Faculty: (Angel Muñoz)_
