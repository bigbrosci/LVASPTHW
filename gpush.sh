git  add .
git commit  -m  "$*"
git push origin  main

rsync    -aWv * --exclude='gpush.sh' ../LVASPTHW_com/

cd ../LVASPTHW_com/
git  add .
git commit  -m  "$*"
git push origin  main
