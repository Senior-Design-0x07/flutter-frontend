#!/bin/sh

# Author : Anthony Bartman
# Description : This will copy our flutter web build files to our connected beaglebone
# board directory.

echo ""
echo "Copying and building Flutter web build files to /etc/hobby-hub"
echo " * Make sure BeagleBone is connected *"
echo ""

#Go to project and remove initial frontend directory
cd ../ && ssh debian@192.168.7.2 'rm -r /home/debian/the-hobby-hub/files/web/frontend'

#Building web
echo ""
echo "-> Building Web Files in /build/web"
echo ""
flutter build web

#Copy files over to connected BeagleBone
echo ""
echo "-> Copying Web Files to 'the-hobby-hub/files/web/frontend'"
echo ""
scp -r build/web debian@192.168.7.2:the-hobby-hub/files/web/frontend

echo ""
echo "DONE! Start backend server up on board to view changes"
