Install erlang version 19 or later from source http://erlang.org

Download XQuartz.app (free from app store). Install it and change in Preferences - Security - Allow connections from network clients.

Start XQuartz

Compile ex11
```bash
cd ex11
make
```
Compile util with:
```bash
cd util
erlc -I ../lib *.erl
```
Start util with:
```bash
erl -noshell -pa '../lib' -s clock init
```

Compile widgets with:
```bash
cd widgets
erlc -I ../lib *.erl
```
Start widgets with:
```bash
sudo erl -pa '../lib'
```
In erlang console, type:
```erlang
main:start().
```

Remember you have to have your XQuartz running. 

