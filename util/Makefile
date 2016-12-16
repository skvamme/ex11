#xauth
#add :1 . ab12cd34ef56fe78dc90ba1a2b3c4d5e6f
#	export XAUTHORITY="/home/pi/.Xauthority"

all:
	erlc -I ../lib *.erl
	erl -noshell -pa '../lib' -s clock init

lib:
	cd ../lib && rm *beam && make
