# macruby_deploy --compile --embed --stdlib time --stdlib json ~/Library/Developer/Xcode/DerivedData/CIMenu-einanuhgnxlcuseawaeqrkxhpgis/Build/Products/Debug/CIMenu.app
# UDZO -zlib UDBZ -bz2 (10.4+)
# hdiutil create -srcfolder "/Users/nicck/Desktop/CIMenu.app" -volname "CIMenu" -imagekey zlib-level=9 -format UDZO "CIMenu.dmg"
hdiutil create -srcfolder "/Users/nicck/Desktop/CIMenu.app" -volname "CIMenu" -format UDBZ "CIMenu.dmg"
hdiutil internet-enable -yes "CIMenu.dmg"
