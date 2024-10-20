git clone https://gitlab.com/sdm845-mainline/linux.git --depth 1 linux 
cd linux
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig sdm845.config
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
_kernel_version="$(make kernelrelease -s)"
mkdir ../linux-oneplus-enchilada/boot
cp arch/arm64/boot/Image.gz ../linux-oneplus-enchilada/boot/vmlinuz-$_kernel_version
cp arch/arm64/boot/dts/qcom/sdm845-oneplus-enchilada.dtb ../linux-oneplus-enchilada/boot/dtb-$_kernel_version
sed -i "s/Version:.*/Version: ${_kernel_version}/" ../linux-oneplus-enchilada/DEBIAN/control
rm -rf ../linux-oneplus-enchilada/lib
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=../linux-oneplus-enchilada modules_install
rm ../linux-oneplus-enchilada/lib/modules/**/build
cd ..
rm -rf linux

dpkg-deb --build --root-owner-group linux-oneplus-enchilada
dpkg-deb --build --root-owner-group firmware-oneplus-enchilada
dpkg-deb --build --root-owner-group alsa-oneplus-enchilada
