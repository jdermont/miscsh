#miscsh
Miscellaneous Bash Scripts
======

### Image Dupes Finder

Simple image duplicates finder. Uses imagemagick or graphicsmagicks.

Example run using the images.

```sh
./imgdupes.sh -gm images/
Found 12 images.
Creating thumbs...
Thumbs created.     
66 pairs to check.
Comparing...
Images probably the same: images/spaced name.jpg images/tumblr_kp2mi6ajzg1qzv5pwo1_500.jpg
Images probably the same: images/spaced dir/tumblr_m3plvr2gtgg1qjahcpo1_250.jpg images/spaced dir/tumblr_m3plvr2DHR1qjahcpo1_250.jpg
Images probably the same: images/spaced dir/tumblr_m3plvr2gtgg1qjahcpo1_250.jpg images/tumblr_m3plvr2DHR1qjahcpo1_250.jpg
Images probably the same: images/spaced dir/tumblr_m3plvr2DHR1qjahcpo1_250.jpg images/tumblr_m3plvr2DHR1qjahcpo1_250.jpg
Images probably the same: images/tumblr_m311112xhc1qath333_1280.jpg images/dir/tumblr_m3pua02xhc1qathi4o1_1280.jpg
```