echo "Making Directories"
echo "================================="
mkdir ~/log ~/files ~/backup ~/cache ~/storage ~/webserver


echo "Installing Packages"
echo "================================="
sudo apt-get install build-essential -y
sudo apt-get install zlib1g-dev
sudo apt-get install ruby1.8 -y
sudo apt-get install ruby -y
sudo apt-get install ruby1.8-dev  -y
sudo apt-get install postgresql -y
sudo apt-get install liblam4  -y
sudo apt-get install libsox-dev libsox-fmt-all libsox-fmt-mp3  -y
sudo apt-get install sox -y
sudo apt-get install lame -y
sudo apt-get install vim -y
sudo apt-get install imagemagick -y
sudo apt-get install libpq-dev -y
sudo apt-get install libopenssl-ruby -y
sudo apt-get install git-core -y
sudo apt-get install vorbis-tools madplay flac faad 
sudo apt-get install rubygems -y
sudo apt-get install libjpeg62-dev -y
sudo apt-get install zlib1g-dev -y
sudo apt-get install libfreetype6-dev -y
sudo apt-get install liblcms1-dev -y
sudo apt-get install python-dev -y
sudo apt-get install python-dev python-numpy python-setuptools libsndfile-dev -y
sudo apt-get install libasound2-dev -y

echo "Installing Gems"
echo "================================="
sudo gem install activesupport -v=2.3.5
sudo gem install activerecord -v=2.3.5
sudo gem install xml-simple -v=1.0.12
sudo gem install builder -v=2.1.2
sudo gem install mime-types -v=1.16
sudo gem install aws-s3 -v=0.6.2
sudo gem install daemons -v=1.0.10
sudo gem install eventmachine -v=0.12.10
sudo gem install fastthread -v=1.0.7
sudo gem install rake -v=0.8.7
sudo gem install json_pure -v=1.2.0
sudo gem install rubyforge -v=2.0.3
sudo gem install hoe -v=2.4.0
sudo gem install json -v=1.2.0
sudo gem install rack -v=1.0.1
sudo gem install passenger -v=2.2.10
sudo gem install pg -v=0.8.0
sudo gem install tmail -v=1.2.3.1
sudo gem install pony -v=0.5
sudo gem install ruby-hmac -v=0.4.0
sudo gem install rubygems-update -v=1.3.5
sudo gem install sinatra -v=0.9.4


