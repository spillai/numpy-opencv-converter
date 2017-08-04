# Author: Sudeep Pillai (Sep 14, 2014)
# Contributor: Wei Zhengyuan (Aug 4, 2017)
project (numpy-opencv-converter)
cmake_minimum_required (VERSION 2.6.0)

# Add find_package directory
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

# Include package
find_package(OpenCV REQUIRED)
find_package(PythonInterp REQUIRED)
find_package(PythonLibs REQUIRED)
find_package(NumPy REQUIRED)
if (${PYTHON_VERSION_MAJOR} EQUAL 3)
    find_package(Boost COMPONENTS python3 system REQUIRED)
else()
    find_package(Boost COMPONENTS python system REQUIRED)
endif()

include_directories(${Boost_INCLUDE_DIRS} ${PYTHON_INCLUDE_DIRS}
    ${PYTHON_NUMPY_INCLUDE_DIR})
link_libraries(${Boost_LIBRARIES} ${PYTHON_LIBRARIES} ${OpenCV_LIBS})

# Build np<=>opencv converter library
set(converter_src np_opencv_converter.cpp utils/conversion.cpp)
PYTHON_ADD_MODULE(np_opencv_converter ${converter_src})

# Build test library
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
set(module_src tests/np_opencv_module.cpp)
PYTHON_ADD_MODULE(np_opencv_module ${module_src} ${converter_src})

# Install to system
execute_process(COMMAND "${PYTHON_EXECUTABLE}" -c
    "from distutils.sysconfig import get_python_lib; print get_python_lib()"
    OUTPUT_VARIABLE PYTHON_SITE_PACKAGES_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
install(TARGETS np_opencv_converter np_opencv_module
        DESTINATION ${PYTHON_SITE_PACKAGES_DIR})

