# Author: Sudeep Pillai (Sep 14, 2014)
project (numpy-opencv-converter)
cmake_minimum_required (VERSION 2.6.0)

# Include package config, boost-python
find_package(PkgConfig REQUIRED)
include(cmake/boost-python.cmake)

# configure opencv
pkg_check_modules(OpenCV opencv)
include_directories(${OpenCV_INCLUDE_DIRS})

# Include python (use -D flags instead)
if (NOT PYTHON_INCLUDE_DIRS OR NOT PYTHON_LIBRARY)
    SET(PYTHON_INCLUDE_DIRS "/usr/include/python2.7")
    SET(PYTHON_LIBRARY "/usr/lib/python2.7/config/libpython2.7.so")
endif()

# Build np<=>opencv converter library
boost_python_module(np_opencv_converter np_opencv_converter.cpp utils/conversion.cpp)
target_link_libraries(np_opencv_converter boost_system boost_python ${OpenCV_LDFLAGS})

# Build test library
boost_python_module(np_opencv_converter_test np_opencv_converter_test.cpp)
target_link_libraries(np_opencv_converter_test boost_system boost_python np_opencv_converter ${OpenCV_LDFLAGS})
