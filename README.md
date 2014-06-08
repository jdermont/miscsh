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

Some random commands.
======

### normalize mp3 volume

mp3gain adjusts mp3 files volume so they should have the same volume level. Does it losslessly, so the process is reversible.
-r - apply Track gain automatically; -k - automatically lower Track gain to not clip audio

```sh
find -name "*.mp3" -exec mp3gain -r -k {} \;
```
Parallel version, -P N means N threads
```sh
find -name "*.mp3" -print0 | xargs -0 -P 4 -n 1 mp3gain -r -k
```

### dd with 'progress'

pv - pipe viewer

```sh
dd if=/dev/zero bs=1M | pv | dd of=some_file bs=1M
```

### ssh SOCKS tunnel + chromium proxy example

-T - disables pseudo-tty allocation, -N disables iteractive prompt, -D specifies local port

```sh
ssh -TND 8940 user@remote_server
```

Chromium

```sh
chromium --proxy-server="socks5://localhost:8940" --host-resolver-rules="MAP * 0.0.0.0 , EXCLUDE localhost"
```
or something to add to .bash.rc
```sh
function secure_chromium {
    port=8940
    export SOCKS_SERVER=localhost:$port
    export SOCKS_VERSION=5
    chromium &
    exit
}
```

### extract aac from youtube video downloaded by youtube-dl

This method extracts aac (audio) from youtube video (at least fairly new videos' audio is encoded in aac), then packs again to .m4a format. It is lossless (no further recompression after downloading video from youtube). In this example aac is put in #2 Track. To check what this video is made of, you may want to use mediainfo video.mp4

```sh
MP4Box -raw 2 video.mp4
MP4Box -add video_track2.aac#audio output.m4a
```

### bash history tweaks

There works until you close the tty. To make them permanent you should write to .bashrc

erase duplicate commands in your history
```sh
export HISTCONTROL="erasedups:ignoreboth"
```

increase history bash size
```sh
export HISTFILESIZE=100000
export HISTSIZE=10000
```

don't save to .bash_history. "incognito mode" for tty
```sh
unset HISTFILE
```

### filesize of directories, only files..., etc.

sum of file size from current directory (or recursively with -R switch), only files
```sh
ls -al . | grep -E '^-' | awk '{ SUM += $5} END { print "SUM: " SUM/1024/1024 " MiB" }'
```
using find
```sh
find . -maxdepth 1 -type f -exec ls -l {} \; | awk '{ SUM += $5} END { print "SUM: " SUM/1024/1024 " MiB" }'
```

size of entire directory
```sh
du -hs .
```

### images further lossless recompression

jpgcrush reduces jpeg size by about 5%~10%
```sh
find -regex ".*\.\(jpg\|jpeg\)$" -exec jpgcrush {} \;
```

optipng and/or pngcrush reduce png size up to 10%
pngcrush
```sh
find -iname "*.png" -exec pngcrush -brute {} {} \;
```
optipng
```sh
find -iname "*.png" -exec optipng -o7 {} \;
```

[packjpg](http://www.elektronik.htw-aalen.de/packjpg/) is jpeg lossless compressor which averagily reduces jpg files by 20%~25%. This is a kind of "zip" for jpg files.
```sh
find -regex ".*\.\(jpg\|jpeg\)$" -exec packjpg -np {} \;
```
to decompress
```sh
find -iname "*.pjg" -exec packjpg -np {} \;
```

parallel version example of the above commands (pngcrush would need some tweaks)
-P 4 - 4 threads, -n 1 - 1 file per thread, you might want to increase to e.x. -n 10 to get slightly more speed
```sh
find -regex ".*\.\(jpg\|jpeg\)$" -print0 | xargs -0 -P 4 -n 1 jpgcrush
```
