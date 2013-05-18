echo "Downloading cocos-2d (can take a while)"

cd ..

git clone git://github.com/cocos2d/cocos2d-iphone.git

mkdir deps

echo "Linking cocos-2d to bomber"

ln -s cocos2d-iphone deps/

cd cocos2d-iphone

git checkout release-2.0

cd ..

open bomber/Bomber.xcodeproj 
