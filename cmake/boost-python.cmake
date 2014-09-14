function(boost_python_module NAME)
  find_package(Boost COMPONENTS python system REQUIRED)

  # message("Boost_INCLUDE_DIRS: " ${Boost_INCLUDE_DIRS} )
  # message("Boost_LIBRARIES: " ${Boost_LIBRARIES} )

  # For some odd reason, Boost_DIR is set to not found
  # http://stackoverflow.com/questions/18927970/boost-dir-notfound-on-cmake
  set (Boost_DIR "" CACHE INTERNAL "")
  find_package(PythonLibs REQUIRED)

  set(DEP_LIBS
    ${Boost_PYTHON_LIBRARY}
    ${PYTHON_LIBRARIES}
    )
  #these are required includes for every ecto module
  include_directories(
    ${PYTHON_INCLUDE_PATH}
    ${Boost_INCLUDE_DIRS}
    )
  add_library(${NAME} SHARED
    ${ARGN}
    )
  set_target_properties(${NAME}
    PROPERTIES
    OUTPUT_NAME ${NAME}
    COMPILE_FLAGS "${FASTIDIOUS_FLAGS}"
    LINK_FLAGS -dynamic
    PREFIX ""
    )
  if( WIN32 )
    set_target_properties(${NAME} PROPERTIES SUFFIX ".pyd")
  elseif( APPLE OR ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # on mac osx, python cannot import libraries with .dylib extension
    set_target_properties(${NAME} PROPERTIES SUFFIX ".so")
  endif()
  target_link_libraries(${NAME}
    ${DEP_LIBS}
    )
endfunction()