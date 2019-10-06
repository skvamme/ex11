<h1>Raspberry Pi</h1>

Install with a fresh Raspbian (even Light will do but remember to run raspi-config to expand your file system to fill your memory card).

## Erlang
```bash
https://elinux.org/Erlang
```
## xserver (only on Raspbian Light)
```bash
sudo apt-get install xserver-xorg
```

## ex11
```bash
sudo apt-get install git
git clone https://github.com/skvamme/ex11.git
sudo apt-get install libjpeg8-dev
xauth
add :0 . ab12cd34ef56fe78dc90ba1a2b3c4d5e6f
#(If there is any chance your system could be hacked, replace at least one of the random characters above)
exit
#Add the folling two lines to ~/.profile
export DISPLAY="localhost:0.0"
export XAUTHORITY="/home/pi/.Xauthority"

cd ex11
make
```
## start Xorg (only on Raspbian Light)
```bash
sudo Xorg -s 0 dpms &
```
(Press enter and you will get the command prompt back. Xorg can be automatically started at boot, Google it up)


## Compile util with:
```bash
cd util
erlc -I ../lib *.erl
```
## Start util with:
```bash
erl -noshell -pa '../lib' -s clock init
```

## Compile widgets with:
```bash
cd widgets
erlc -I ../lib *.erl
```
## Start widgets with:
```bash
sudo erl -pa '../lib'
```
## In erlang console, type:
```erlang
main:start().
```

Remember you have to have your Xserver running. On Raspberry Pi it's automatically started, or on Raspbian Lite it's sudo Xorg -s 0 dpms & 



