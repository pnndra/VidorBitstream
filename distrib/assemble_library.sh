#!/bin/bash

LIB_NAME=$1
BASE_FOLDER=`dirname $0`

cd $BASE_FOLDER/../

declare -a libs=("FPGA_GFX_COUNT" "FPGA_SPI_INTERFACES_COUNT" "FPGA_I2C_INTERFACES_COUNT" "FPGA_UART_INTERFACES_COUNT" "FPGA_ENCODERS_COUNT" "FPGA_NEOPIXEL_COUNT" "FPGA_CAMERA_COUNT" )
declare -a folders=("Vidor_GFX" "VidorSPI" "VidorI2C" "VidorUART" "VidorEncoder" "VidorNeopixel" "VidorCamera")

mkdir -p ./distrib/$LIB_NAME/
rm -rf ./distrib/$LIB_NAME/*

cp -a $LIB_NAME/* ./distrib/$LIB_NAME/.

arraylength=${#libs[@]}

for (( i=0; i<${arraylength}; i++ ));
do
HAS_LIB=`cat $LIB_NAME/src/defines.h | grep ${libs[i]}  | expand | tr -s ' ' | cut -f3 -d' ' `

if [ x$HAS_LIB != x ] && [ $HAS_LIB != 0 ]
then
	cp ${folders[i]}/* ./distrib/$LIB_NAME/src/.
	if [ -d ${folders[i]}/examples/ ]; then
		mkdir -p ./distrib/$LIB_NAME/examples/
		cp -a ${folders[i]}/examples/* ./distrib/$LIB_NAME/examples/.
	fi
	case "`uname`" in
		Darwin*) find ./distrib/$LIB_NAME/examples/ -type f -exec sed -i "" -e "s/_INCLUDE_PARENT_LIB_/include \"${LIB_NAME}.h\"/g" {} \; ;;
		*) find ./distrib/$LIB_NAME/examples/ -type f -exec sed -i "s/_INCLUDE_PARENT_LIB_/include \"${LIB_NAME}.h\"/g" {} \;
	esac
fi

done

# default libraries (VidorCommon/VidorIO)
declare -a defaultlibs=("VidorIO" "VidorCommon")
arraylength=${#defaultlibs[@]}

for (( i=0; i<${arraylength}; i++ ));
do
	cp ${defaultlibs[i]}/* ./distrib/$LIB_NAME/src/.
	if [ -d ${defaultlibs[i]}/examples/ ]; then
		cp -a ${defaultlibs[i]}/examples/* ./distrib/$LIB_NAME/examples/.
	fi
done

# copy VidorUtils (not sure about this one)
cp -a VidorUtils/src/* ./distrib/$LIB_NAME/src/.
#don't copy examples