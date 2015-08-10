#!/usr/bin/env bash
# Jess Robertson, Monday 25 June 2012
#
# Generate plots of stuff
#
# Usage: make_movie.sh file_list <gfv_file> <file_list>
# Note that the gfv file should be entered without the .gfv suffix
#
# Looks for an executable script called 'make_basename_list.sh'
# to obtain the names of the simulation snapshot files

# Set some variables
export GFSVIEW_BATCH=gfsview-batch3D
export GFV_FILE=$1

# Find the location of some folders and files
export ROOT_FOLDER=`pwd`
export SNAPSHOT_FOLDER=$ROOT_FOLDER
export IMAGE_FOLDER=${ROOT_FOLDER}/${GFV_FILE}_images
export BASENAME_LIST=$ROOT_FOLDER/basename_list.txt

# Generate a folder to store all the image files
mkdir -p $IMAGE_FOLDER

# Generate a list of basenames
(for i in `ls ${SNAPSHOT_FOLDER}/simulation_*.gfs`; do
    echo `basename $i .gfs`
done) > ${BASENAME_LIST}

# Export all images to folder
j=0; for gfsfile in `cat $BASENAME_LIST`; do
    j=$((j+1))
    newname=`echo $j | awk -F: '{ printf("%07.0f.ppm", $1) }'`
    if [ -e "$IMAGE_FOLDER/$newname" ]; then
        echo "File ${GFV_FILE}_images/$newname already exists, skipping $gfsfile.gfs..."
    else 
        echo "Generating image from $gfsfile, renaming to $newname"
        (cat ${gfsfile}.gfs
        echo "Save $IMAGE_FOLDER/$newname { width = 800 height = 600 }") | $GFSVIEW_BATCH $ROOT_FOLDER/$GFV_FILE.gfv
    fi
done

# Generate movie, copy back to root directory
cd $IMAGE_FOLDER
ffmpeg -r 10 -b 3000 -i %07d.ppm $GFV_FILE.mp4
mv $GFV_FILE.mp4 ../.
cd $ROOT_FOLDER