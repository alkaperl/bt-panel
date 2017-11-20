#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
setup_path=/www
CN='125.88.182.172'
HK='103.224.251.79'
HK2='103.224.251.67'
US='128.1.164.196'
sleep 0.5;
CN_PING=`ping -c 1 -w 1 $CN|grep time=|awk '{print $7}'|sed "s/time=//"`
HK_PING=`ping -c 1 -w 1 $HK|grep time=|awk '{print $7}'|sed "s/time=//"`
HK2_PING=`ping -c 1 -w 1 $HK2|grep time=|awk '{print $7}'|sed "s/time=//"`
US_PING=`ping -c 1 -w 1 $US|grep time=|awk '{print $7}'|sed "s/time=//"`

echo "$HK_PING $HK" > ping.pl
echo "$HK2_PING $HK2" >> ping.pl
echo "$US_PING $US" >> ping.pl
echo "$CN_PING $CN" >> ping.pl
nodeAddr=`sort -n -b ping.pl|sed -n '1p'|awk '{print $2}'`
if [ "$nodeAddr" == "" ];then
	nodeAddr=$HK
fi

download_Url=https://github.com/Vultur/bt-panel

wget -T 5 -O panel.zip $download_Url/archive/bt-panel-$1.zip

unzip -o panel.zip -d $setup_path/server/ > /dev/null
mv -f $setup_path/server/bt-panel-$github_Tag/* $setup_path/server/panel
rm -rf $setup_path/server/bt-panel-$github_Tag
rm -f panel.zip
cd $setup_path/server/panel/
python -m compileall $setup_path/server/panel/
python -m compileall $setup_path/server/panel/main.py
python -m compileall $setup_path/server/panel/task.py
python -m compileall $setup_path/server/panel/tools.py
if [ -f "main.py" ];then
	python -m py_compile main.py
fi
if [ -f "task.py" ];then
	python -m py_compile task.py
fi
if [ -f "tools.py" ];then
	python -m py_compile tools.py
fi

service bt restart