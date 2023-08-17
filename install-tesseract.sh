# Adapted from https://gist.github.com/mdv3101/a1b75abd2ec09dc5f1fb4f7637738f8d
# Takes around 20-25 minutes
sudo yum -y --quiet update
sudo yum -y --quiet upgrade

# Compile leptonica
cd ~
sudo yum install clang -y --quiet
sudo yum install libpng-devel libtiff-devel zlib-devel libwebp-devel libjpeg-turbo-devel -y --quiet
wget --quiet https://github.com/DanBloomberg/leptonica/releases/download/1.75.1/leptonica-1.75.1.tar.gz
tar -xzf leptonica-1.75.1.tar.gz
cd leptonica-1.75.1
./configure && make && sudo make install

# Compile autoconf-archive
cd ~
wget --quiet http://mirror.squ.edu.om/gnu/autoconf-archive/autoconf-archive-2017.09.28.tar.xz
tar -xf autoconf-archive-2017.09.28.tar.xz
cd autoconf-archive-2017.09.28
./configure && make && sudo make install
sudo cp m4/* /usr/share/aclocal/

# Compile tesseract
cd ~
sudo yum install git-core libtool pkgconfig -y --quiet
git clone --depth 1  https://github.com/tesseract-ocr/tesseract.git tesseract-ocr
cd tesseract-ocr
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
./autogen.sh
./configure
make
sudo make install

# Get the orientation and script detection, and English data files
# https://tesseract-ocr.github.io/tessdoc/Data-Files.html
cd "/home/ec2-user/tesseract-ocr/tessdata"
wget --quiet https://github.com/tesseract-ocr/tessdata_fast/raw/main/osd.traineddata
wget --quiet https://github.com/tesseract-ocr/tessdata_fast/raw/main/eng.traineddata
cd ~

# Copy the tessdata folder to pwd
cd /home/ec2-user/SageMaker
cp -r /home/ec2-user/tesseract-ocr/tessdata .
