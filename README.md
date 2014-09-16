## NUMPY <=> OpenCV's cv::Mat converter
[Sudeep Pillai](http://people.csail.mit.edu/spillai) (spillai@csail.mit.edu) Sep 14, 2014

A convenience library that registers a boost::python converter to implicitly
convert between OpenCV's popular cv::Mat datatype and NumPy's popular
np.array() datatype. This allows a developer to go back and forth between their
OpenCV C++ API and Python API written using NumPy with relative ease, avoiding the need to
write additional wrappers that handle PyObjects being passed around or returned. 

This work was mostly inspired by
https://github.com/yati-sagade/opencv-ndarray-conversion. 

**BSD License**

## A simple example

Imagine writing a C++ API using OpenCV as so: 
```c++
cv::Mat process_mat(const cv::Mat& in) { 
   // process matrix, or just plain-simple cloning!
   cv::Mat out = in.clone();
   return out;
}
```

Wrap it using Boost::Python in say, cv_module.cpp: 
```python
boost::python::def("process_mat", &process_mat);
```	

Call it from Python: 
```python
import numpy as np
from cv_module import process_mat
A = np.random.random(shape=(4,3))
B = process_mat(A)
```												

As simple as that! Hope you find it useful!

## Build and Install
See dependencies below before building. 
```
git clone git@github.com:spillai/numpy-opencv-converter
mkdir build
cd build && cmake ..
make
```

## Usage

Make sure the built np_opencv_converter.so and np_opencv_module.so
(currently in numpy-opencv-converter/build/) are in the $LD_LIBRARY_PATH
environment variable, before running the following in python/ipython. 

```python
In [1]: import np_opencv_module as npcv
PYTHON TYPE CONVERTERS exported
```
On succesful import, the cv::Mat <=> np.ndarray converters are exported. 

We then test  a simple function that takes in a cv::Mat (appropriately converted
from np.ndarray A) as an argument and returns
another cv::Mat (again appropriately converted back to np.ndarray B).  

```python
In [2]: import numpy as np
In [3]: A = np.random.random((4,3))
In [4]: B = npcv.test_np_mat(A)
in: [0.2793205402416998, 0.466896711918419, 0.3834843006535923;
  0.5374426625812107, 0.3737008026047054, 0.3685794034255524;
  0.993469313797578, 0.2619403678989528, 0.5700175530375297;
  0.5711496315041438, 0.3286727439294438, 0.1250325059375548]
sz: [3 x 4]
 
In [5]: print A.dtype, B.dtype
float64 float64
```

With default args
```python
In [6]: npcv.test_with_args(A, var1=0, var2=20.0, name='test_name2')
in: [0.27932054, 0.46689671, 0.3834843;
  0.53744268, 0.3737008, 0.36857942;
    0.9934693, 0.26194036, 0.57001758;
	  0.57114965, 0.32867274, 0.1250325]
sz: [3 x 4]
Returning transpose

Out[6]: 
array([[ 0.27932054,  0.53744268,  0.9934693 ,  0.57114965],
 	  [ 0.46689671,  0.3737008 ,  0.26194036,  0.32867274],
	  [ 0.3834843 ,  0.36857942,  0.57001758,  0.1250325 ]],
	  dtype=float32)
```

Finally, testing a wrapper class
```python
In [7]: gw = npcv.GenericWrapper(var_int=1, var_float=2.0, var_double=3.0, var_string='string')
In [8]: gw.process(A)

in: [0.2793205402416998, 0.466896711918419, 0.3834843006535923;
  0.5374426625812107, 0.3737008026047054, 0.3685794034255524;
    0.993469313797578, 0.2619403678989528, 0.5700175530375297;
	  0.5711496315041438, 0.3286727439294438, 0.1250325059375548]
sz: [3 x 4]
Returning transpose

Out[8]: 
array([[ 0.27932054,  0.53744266,  0.99346931,  0.57114963],
      [ 0.46689671,  0.3737008 ,  0.26194037,  0.32867274],
      [ 0.3834843 ,  0.3685794 ,  0.57001755,  0.12503251]])
```

## Dependencies
Currently only Linux is supported, although the code is pretty barebones that
should allow you to port it to Windows, or Mac OSX with relative ease. 
I personally wouldn't recommend installing opencv as indicated below, but I'll
assume you know how to deal with pkg-config and opencv to make any
modifications to the CMakeLists.txt file. 

```
$ sudo apt-get install libboost-python-dev libopencv-dev
```
