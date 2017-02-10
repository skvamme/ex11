<h1>Ubuntu Touch/Phone with Mir Display Server</h1>

Erlang ex11 is tested on BQ Aquaris E4.5 Ubuntu Phone

First you have to install an additional root FS on the phone
```bash
wget http://cdimage.ubuntu.com/ubuntu-touch/vivid/daily-preinstalled/current/vivid-preinstalled-touch-armhf.tar.gz
mkdir myRoot
cd myRoot
sudo tar -zxvf ../vivid-preinstalled-touch-armhf.tar.gz
cd ..
sudo mount --bind /tmp myRoot/tmp
cd myRoot
sudo chroot .
echo "nameserver 127.0.1.1" > /etc/resolv.conf
apt-get install xauth
xauth
add :0 . ab12cd34ef56fe78dc90ba1a2b3c4d5e6f
exit
exit
```
From now on, every time you want to start an erlang app, start an Xmir window session
```bash
Xmir :0 --desktop_file_hint=/usr/share/applications/unity8.desktop &
cd myRoot
sudo chroot .
cd
```
### Install Erlang
```bash
sudo apt-get update
sudo apt-get install wget
sudo apt-get install libssl-dev
sudo apt-get install ncurses-dev
wget http://www.erlang.org/download/otp_src_19.2.tar.gz
tar -xzvf otp_src_19.2.tar.gz
cd otp_src_19.2/
./configure
make
sudo make install
cd ..
rm otp_src_19.2.tar.gz
```
### Install ex11
```bash
sudo apt-get install git
git clone https://github.com/skvamme/ex11.git
sudo apt-get install libjpeg8-dev
xauth
add :0 . ab12cd34ef56fe78dc90ba1a2b3c4d5e6f
#(If there is any chance your system could be hacked, replace at least one of the random characters above)
exit
cd ex11
make
```
### Compile util with:
```bash
cd util
erlc -I ../lib *.erl
```

### Start util with:
```bash
erl -noshell -pa '../lib' -s clock init
```

### Compile widgets with:
```bash
cd widgets
erlc -I ../lib *.erl
```

### Start widgets with:
```bash
sudo erl -pa '../lib'
```

### In erlang console, type:
```erlang
main:start().
```


