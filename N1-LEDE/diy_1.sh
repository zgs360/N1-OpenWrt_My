#!/bin/bash
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Add packages
#添加科学上网源

# => openclash
git clone --depth=1 https://github.com/vernesong/OpenClash.git package/luci-app-openclash

# => passwall2
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git -b main package/passwall_package
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2.git package/passwall2

# Remove packages
#删除lean库中的插件，使用自定义源中的包。
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/luci/applications/luci-app-mosdns


# Modify default IP
sed -i 's/192.168.1.1/192.168.2.3/g' package/base-files/files/bin/config_generate

#修改密码
sed -i 's/^root:.*:/root:$1$/CMrDMda$DtkE3eQ4LVs9H2kwcRWF5/:19664:0:99999:7:::/g' package/base-files/files/etc/shadow


#修改默认时间格式
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")

