#!/usr/bin/env bash
# 安装 Times New Roman（msttcorefonts），清理 matplotlib 字体缓存，并验证
# 适用：Ubuntu/Debian 系

set -euo pipefail

echo "==> 检查 sudo 权限..."
if ! command -v sudo >/dev/null 2>&1; then
  echo "❌ 未找到 sudo，请以 root 运行或安装 sudo。"
  exit 1
fi

echo "==> 刷新 APT 索引..."
sudo apt-get update -y

echo "==> 预先接受 Microsoft 核心字体 EULA（避免交互）..."
# 预置 debconf 以非交互方式接受许可
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections || true
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula seen true"   | sudo debconf-set-selections || true

echo "==> 安装 Microsoft 核心字体（包含 Times New Roman）..."
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y ttf-mscorefonts-installer

echo "==> （可选）安装常见开源字体以增强兼容性..."
sudo apt-get install -y fonts-dejavu-core fonts-freefont-ttf || true

echo "==> 刷新系统字体缓存..."
sudo fc-cache -f -v >/dev/null 2>&1 || true

echo "==> 清理 matplotlib 字体缓存..."
rm -rf ~/.cache/matplotlib || true

echo "==> 简要验证系统是否识别到 Times New Roman..."
if fc-list | grep -qi "Times New Roman"; then
  echo "✅ 已检测到 Times New Roman 系统字体。"
else
  echo "⚠️ 未在 fc-list 中检测到 Times New Roman，但可能仍可用。"
  echo "   如果后续 matplotlib 仍报错，请重启 Python 解释器或终端后再试。"
fi

cat <<'PYCODE' > /tmp/_check_mpl_times.py
import matplotlib.pyplot as plt
plt.rcParams['font.family'] = 'Times New Roman'
print("matplotlib 当前 font.family:", plt.rcParams['font.family'])
PYCODE

echo "==> 使用 Python 验证 matplotlib 侧的字体设置（如有多环境，请在目标环境运行）..."
python3 /tmp/_check_mpl_times.py || echo "⚠️ Python 验证未执行（可能未安装 python3 或 matplotlib）。"

echo "==> 完成！如仍有缓存问题，可重启内核/终端后再次尝试绘图。"
