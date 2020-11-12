# Modernized version of http://www.cmake.org/pipermail/cmake/2011-January/041666.html
# Usage: find_python_module(<name> [REQUIRED])
# Sets PY_<NAME> to the location of the module if available
# With REQUIRED, sends error when the module is not available.
#
function(find_python_module module)
    string(TOUPPER ${module} module_upper)
    if (NOT PY_${module_upper})
	if(ARGC GREATER 1 AND ARGV1 STREQUAL "REQUIRED")
	    set(_${module}_FIND_REQUIRED TRUE)
	else ()
	    set(_${module}_FIND_REQUIRED FALSE)
	endif ()
	# A module's location is usually a directory, but for binary modules
	# it's a .so file.
	execute_process(COMMAND "${PYTHON_EXECUTABLE}" "-c"
	    "import re, ${module}; print(re.compile('/__init__.py.*').sub('',${module}.__file__))"
	    RESULT_VARIABLE _${module}_status
	    OUTPUT_VARIABLE _${module}_location
	    ERROR_QUIET
	    OUTPUT_STRIP_TRAILING_WHITESPACE)
	if (${_${module}_status} GREATER 0 AND ${_${module}_FIND_REQUIRED})
	    message(SEND_ERROR "find_python_module: required module ${module} not installed")
	endif ()
	if (NOT _${module}_status)
	    set(PY_${module_upper} ${_${module}_location} CACHE STRING
		"Location of Python module ${module}")
	endif (NOT _${module}_status)
    endif (NOT PY_${module_upper})
    find_package_handle_standard_args(PY_${module_upper} DEFAULT_MSG PY_${module_upper})
endfunction(find_python_module)
