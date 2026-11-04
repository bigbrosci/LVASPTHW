git add .
git commit -m "$*"
git push origin main

# 第二段只在 LVASPTHW_com 本身就是 git 仓库时才跑。
# rsync 的 * 不含隐藏文件，不会把 .git 拷过去，所以一个普通拷贝目录跑 git 必然报 not a git repository。
if [ -d ../LVASPTHW_com/.git ]; then
  rsync -aWv * --exclude='gpush.sh' ../LVASPTHW_com/
  cd ../LVASPTHW_com/
  git add .
  git commit -m "$*"
  git push origin main
else
  echo "跳过第二段：../LVASPTHW_com 不是 git 仓库"
fi
