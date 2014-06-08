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

### Normalize mp3 volume

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
