::init
@echo off
cd /d %~dp0
chcp 65001
::set https_proxy=172.16.0.6:8899
::start download files in rule-list
for /f "eol=# tokens=1,2 delims= " %%i in (rule-list.ini) do (
wget -q --no-hsts --local-encoding=UTF-8 --remote-encoding=UTF-8 --restrict-file-names=nocontrol --no-cookies -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4937.0 Safari/537.36" --no-check-certificate -t 2 -T 30 -O down%%i.txt %%j
sed -i -E --posix "/^$/d" down%%i.txt
sed -i -E --posix "/^\#.*$/d" down%%i.txt
)
for %%i in (down*.txt) do (
for /l %%s in (0,1,8) do (
sed -n "1,20000p" %%i>>%%i-s%%s.txt
sed -i "1,20000d" %%i
)
ren %%i %%i-s9.txt
)
::move file out
del /f /q ..\*.txt
copy /y .\*.txt ..\
::end cleanup
del /f /q *.txt&exit
