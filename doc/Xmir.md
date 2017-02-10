<h1>Ubuntu Touch/Phone with Mir Display Server</h1>

Erlang ex11 is tested on BQ Aquaris E4.5 Ubuntu Phone

First you have to create an additional root FS on the phone
```bash
wget http://cdimage.ubuntu.com/ubuntu-touch/vivid/daily-preinstalled/current/vivid-preinstalled-touch-armhf.tar.gz
mkdir myRoot
cd myRoot
sudo tar -zxvf ../vivid-preinstalled-touch-armhf.tar.gz
cd ..
sudo chroot myRoot/
echo "nameserver 127.0.1.1" > /etc/resolv.conf
exit
```
### Install Erlang in your new root FS
```bash
sudo chroot myRoot/
cd
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
exit
```
### Install ex11
```bash
sudo chroot myRoot/
cd
sudo apt-get install git
git clone https://github.com/skvamme/ex11.git
sudo apt-get install libjpeg8-dev
apt-get install xauth
xauth
add :0 . ab12cd34ef56fe78dc90ba1a2b3c4d5e6f
#(If there is any chance your system could be hacked, replace at least one of the random characters above)
exit
cd ex11
make
exit
```

From now on, every time you want to start an erlang app, first start an Xmir window session, then chroot
```bash
Xmir :0 --desktop_file_hint=/usr/share/applications/unity8.desktop &
sudo mount --bind /tmp myRoot/tmp
sudo chroot myRoot/
cd
cd ex11
```

### Compile ex11 util with:
```bash
cd util
erlc -I ../lib *.erl
```
#### Start util with:
```bash
erl -noshell -pa '../lib' -s clock init
```

### Compile widgets with:
```bash
cd widgets
erlc -I ../lib *.erl
```

#### Start widgets with:
```bash
sudo erl -pa '../lib'
```

#### In erlang console, type:
```erlang
main:start().
```


