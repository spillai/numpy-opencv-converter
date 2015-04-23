#!/bin/bash
my_module="np_opencv_module"
python -c "import $my_module"
exit_code=$?
if [ $exit_code -ne 0 ]; then
	echo "*** $my_module loading unsuccessful"
	exit $exit_code
fi
