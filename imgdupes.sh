#!/bin/bash
#
# IMAGE DUPES FINDER v0.0.0..... a very first attempt
# for the given path, this script searches for duplicate images
# it creates 32x32 thumbnails of images and compares pairs. comparing is fuzzy so it should detect slightly changed images as the same
# works with imagemagick or graphicsmagick (graphicsmagick is way faster in my case)
# for imagemagick. you should have commands: convert, compare
# for graphicsmagick, you should have: gm convert, gm compare
#
# very first version, not dumb-proof! not much error checking!
#
# from: https://github.com/jdermont/miscsh
# you can use it whenever you want and however you want
#

usage() {
  echo "Image Dupes Finder v0.0.0..."
  echo "Usage:"
  echo "./imgdupes.sh dir		first looks for imagemagick, if not found then looks for graphicsmagick"
  echo "./imgdupes.sh -im dir		uses imagemagick"
  echo "./imgdupes.sh -gm dir		uses graphicsmagick"
  echo
  echo "Example 1: ./imgdupes.sh ."
  echo "Example 2: ./imgdupes.sh -gm /home/user/Pictures"
}

directory=""
mode=0

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  usage
  exit 1
elif [ $# = 1 ]; then
  directory="$1"
  if hash convert; then
    mode=1
    echo "Using imagemagick."
  elif hash gm; then
    mode=2
    echo "Using graphicsmagick."
  else
    echo "Neither 'convert' nor 'gm' found."
    exit 1
  fi
else
  if [ $1 = "-im" ]; then
    mode=1
    if ! hash convert; then
      echo "Imagemagick ('convert') not found."
      exit 1
    fi
   
  elif [ $1 = "-gm" ]; then
    mode=2
    if ! hash convert; then
      echo "Graphicsmagick ('gm') not found."
      exit 1
    fi
  else
    usage
    exit 1
  fi
  directory="$2"
fi

if [ ! -d "$directory" ]; then
  echo "$directory not found."
  exit 1
fi

trap clean_up SIGINT

clean_up()
{
  echo "Interrupted. Cleaning up..."
  IFS=$SAVEIFS
  find "$directory" -iname "*___thumb_duper.png" -exec rm -f {} \;
  exit 0
}

# find all images in specified path
ALL=`find "$directory" -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg"`
declare -a LIST

# some magic for spaces in names
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

len=0
for ONE in $ALL; do
  LISTA[$len]=$ONE
  let len=len+1
done

if [ $len = 0 ]; then
  echo "No images found. Exiting."
  exit 0
else
  echo "Found $len images."
fi

echo "Creating thumbs..."
don=0
for ((i = 0; i < $len; i++))
do
  echo -ne "Created $don thumbs.\r"
  if [ $mode = 1 ]; then
    convert "${LISTA[$i]}" -sample 32x32\! "${LISTA[$i]}___thumb_duper.png" 2>/dev/null
  else
    gm convert "${LISTA[$i]}" -sample 32x32\! "${LISTA[$i]}___thumb_duper.png" 2>/dev/null
  fi
  let don=don+1
done
echo "Thumbs created.     "

don=0
let pairs=$len*$(($len-1))/2
echo "$pairs pairs to check."
echo "Comparing..."
for (( i=0; $i < $len; i++ )) ; do
  for (( j=$(($i+1)); $j < $len; j++ )) ; do
    echo -ne "Checked $don pairs.\r"
    if [ $mode = 1 ]; then
	com=`compare -metric AE -fuzz 40% "${LISTA[$i]}___thumb_duper.png" "${LISTA[$j]}___thumb_duper.png" /dev/null 2>&1 >/dev/null`
	if [ $com == 0 ]; then
	  echo "Images probably the same: ${LISTA[$i]} ${LISTA[$j]}"
	fi
    else
	com=`gm compare -metric MSE "${LISTA[$i]}___thumb_duper.png" "${LISTA[$j]}___thumb_duper.png" 2>/dev/null | tail -n1 | awk '{ print $2 } '`
	com=`echo "$com<0.01" | bc`
	if [ $com == 1 ]; then
	  echo "Images probably the same: ${LISTA[$i]} ${LISTA[$j]}"
	fi
    fi
    let don=don+1
  done
done

# some cleanup
IFS=$SAVEIFS
find "$directory" -iname "*___thumb_duper.png" -exec rm {} \;
