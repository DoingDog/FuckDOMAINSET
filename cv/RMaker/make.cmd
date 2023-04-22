::init
@echo off
cd %~dp0
chcp 65001

::start download files in rule-list
for /f "eol=# tokens=1,2 delims= " %%i in (rule-list.ini) do (
wget -q --no-hsts --local-encoding=UTF-8 --remote-encoding=UTF-8 --restrict-file-names=nocontrol --no-cookies -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4937.0 Safari/537.36" --no-check-certificate -t 2 -T 30 -O down%%i.txt %%j
sed -i -E --posix "/^$/d" down%%i.txt
sed -i -E --posix "/^\#.*$/d" down%%i.txt
sed -i -E --posix "/^HOST-WILDCARD/d" down%%i.txt
sed -i -E --posix "s/,no-resolve$//g" down%%i.txt
sed -i -E --posix "s/^HOST/DOMAIN/g" down%%i.txt
sed -i -E --posix "s/^IP6-CIDR/IP-CIDR6/g" down%%i.txt
sed -i -E --posix "s/,[^,]+$//g" down%%i.txt

sed -n "/IP-CIDR/p" down%%i.txt>>fpip.txt
sed -i "/IP-CIDR/d" down%%i.txt
sed -i -E --posix "s/$/,no-resolve/g" fpip.txt
type fpip.txt>>down%%i.txt
del /f /q fpip.txt
echo #%date%>>down%%i.txt
)

::move file out
del /f /q ..\*.txt
copy /y .\*.txt ..\

::end cleanup
del /f /q *.txt&exit
