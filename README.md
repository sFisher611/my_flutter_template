# My template



## IOS refresh
```
flutter clean
flutter pub get
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf Runner.xcworkspace

pod deintegrate
pod cache clean --all
pod install
cd ..
```
