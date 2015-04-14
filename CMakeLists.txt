# Author: Sudeep Pillai (Sep 14, 2014)
project (numpy-opencv-converter)
cmake_minimum_required (VERSION 2.6.0)

# Include package config, boost-python
find_package(PkgConfig REQUIRED)
include(cmake/boost-python.cmake)

# configure opencv
pkg_check_modules(OpenCV opencv)
include_directories(${OpenCV_INCLUDE_DIRS})

include(FindPythonLibs)
find_package(PythonLibs REQUIRED)
# Include python (use -D flags instead)
if (NOT PYTHON_INCLUDE_DIRS OR NOT PYTHON_LIBRARY)
    SET(PYTHON_INCLUDE_DIRS "/usr/include/python2.7")
    SET(PYTHON_LIBRARY "/usr/lib/python2.7/config/libpython2.7")
endif()

# not including this causes compilation error later, as the compiler cannot find the NumPy C headers location
if (NOT NUMPY_INCLUDE_DIRS)
	execute_process( COMMAND "${PYTHON_EXECUTABLE}" "-c" "import numpy; print numpy.get_include();" OUTPUT_VARIABLE NUMPY_INCLUDE_DIRS OUTPUT_STRIP_TRAILING_WHITESPACE )
endif()
include_directories(${NUMPY_INCLUDE_DIRS})

# Build np<=>opencv converter library
boost_python_module(np_opencv_converter np_opencv_converter.cpp utils/conversion.cpp)
target_link_libraries(np_opencv_converter boost_system boost_python ${OpenCV_LDFLAGS})

# Build test library
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
boost_python_module(np_opencv_module tests/np_opencv_module.cpp)
target_link_libraries(np_opencv_module boost_system boost_python np_opencv_converter ${OpenCV_LDFLAGS})
