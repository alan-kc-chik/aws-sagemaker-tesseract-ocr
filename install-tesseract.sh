# Update and upgrade in one step
sudo yum -y --quiet update && sudo yum -y --quiet upgrade

# Install all necessary packages in one step
sudo yum install -y --quiet clang libpng-devel libtiff-devel zlib-devel libwebp-devel libjpeg-turbo-devel git-core libtool pkgconfig

# Compile leptonica
cd ~
wget --quiet https://github.com/DanBloomberg/leptonica/releases/download/1.75.1/leptonica-1.75.1.tar.gz
tar -xzf leptonica-1.75.1.tar.gz
cd leptonica-1.75.1
./configure && make -j$(nproc) && sudo make install

# Compile autoconf-archive
cd ~
wget --quiet http://mirror.squ.edu.om/gnu/autoconf-archive/autoconf-archive-2017.09.28.tar.xz
tar -xf autoconf-archive-2017.09.28.tar.xz
cd autoconf-archive-2017.09.28
./configure && make -j$(nproc) && sudo make install
sudo cp m4/* /usr/share/aclocal/

# Compile tesseract
cd ~
git clone --depth 1  https://github.com/tesseract-ocr/tesseract.git tesseract-ocr
cd tesseract-ocr
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
./autogen.sh
./configure
make -j$(nproc)
sudo make install

# Get the data files
cd "/home/ec2-user/tesseract-ocr/tessdata"
echo "https://github.com/tesseract-ocr/tessdata_fast/raw/main/osd.traineddata
https://github.com/tesseract-ocr/tessdata_fast/raw/main/eng.traineddata" > list.txt
wget --quiet -i list.txt

# Copy the tessdata folder
cd /home/ec2-user/SageMaker
cp -r /home/ec2-user/tesseract-ocr/tessdata .
