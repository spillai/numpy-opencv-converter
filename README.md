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

## Build and Install
See dependencies below before building. 
```
git clone git@github.com:spillai/numpy-opencv-converter
mkdir build
cd build && cmake ../
make
```

## Usage

Make sure the built np_opencv_converter.so and np_opencv_converter_test.so
(currently in numpy-opencv-converter/build/) are in the $LD_LIBRARY_PATH
environment variable, before running the following in python/ipython. 

```python
In [1]: import numpy as np
In [2]: A = np.random.random((4,3))

In [3]: import np_opencv_converter_test as npcv
PYTHON TYPE CONVERTERS exported

In [4]: import np_opencv_converter_test as npcv

In [5]: B = npcv.test_np_mat(A)
in: [0.2793205402416998, 0.466896711918419, 0.3834843006535923;
  0.5374426625812107, 0.3737008026047054, 0.3685794034255524;
  0.993469313797578, 0.2619403678989528, 0.5700175530375297;
  0.5711496315041438, 0.3286727439294438, 0.1250325059375548]
sz: [3 x 4]

In [6]: print A.dtype, B.dtype
float64 float64
```

With default args
```python
In [7]: npcv.test_with_args(A, var1=0, var2=20.0, name='test_name2')

in: [0.27932054, 0.46689671, 0.3834843;
  0.53744268, 0.3737008, 0.36857942;
    0.9934693, 0.26194036, 0.57001758;
	  0.57114965, 0.32867274, 0.1250325]
sz: [3 x 4]
Returning transpose

Out[7]: 
array([[ 0.27932054,  0.53744268,  0.9934693 ,  0.57114965],
 	  [ 0.46689671,  0.3737008 ,  0.26194036,  0.32867274],
	  [ 0.3834843 ,  0.36857942,  0.57001758,  0.1250325 ]],
	  dtype=float32)
```

Finally, testing a wrapper class
```python
In [8]: gw = npcv.GenericWrapper(var_int=1, var_float=2.0, var_double=3.0, var_string='string')

In [9]: gw.process(A)

in: [0.2793205402416998, 0.466896711918419, 0.3834843006535923;
  0.5374426625812107, 0.3737008026047054, 0.3685794034255524;
    0.993469313797578, 0.2619403678989528, 0.5700175530375297;
	  0.5711496315041438, 0.3286727439294438, 0.1250325059375548]
sz: [3 x 4]
Returning transpose

Out[9]: 
array([[ 0.27932054,  0.53744266,  0.99346931,  0.57114963],
      [ 0.46689671,  0.3737008 ,  0.26194037,  0.32867274],
      [ 0.3834843 ,  0.3685794 ,  0.57001755,  0.12503251]])
				
```

## Dependencies
Currently only Linux is supported, although the code is pretty barebones that
should allow you to port it to Windows, or Mac OSX with relative ease. 
I personally wouldn't recommend installing opencv as indicated below, but I'll
assume you know how to deal with pkg-config and opencv to manage any
modifications to the CMakeLists.txt file. 

```
$ sudo apt-get install libboost-python-dev libopencv-dev
```
