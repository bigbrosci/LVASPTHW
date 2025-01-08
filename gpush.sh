git  add .
git commit  -m  "$*"
git push origin  main

rsync    -aWv * --exclude='gpush.sh' ../LVASPTHW_com/
