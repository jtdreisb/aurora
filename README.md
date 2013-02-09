
Building
==================

1. Install CocoaPods if you haven't already 

```
sudo gem install cocoapods; pod setup
```

2. Clone the Aurora repository

```
git clone https://github.com/jtdreisb/Aurora
```

3. Resolve Aurora's CocoaPod dependencies

```
cd Aurora; pod install
```

4. Open the Xcode Workspace document (NOT the Xcode project) 

```
open aurora.xcworkspace
```

5. Change the build target to Aurora: In Xcode, to the right of the Stop button, click the dropdown and choose Aurora.

6. Click Run.

*** Working on a locally checked out version 
```
pod 'DPHue', :local => '~/src/DPHue'
```


```
pod 'DPHue', :git => 'https://github.com/jtdreisb/DPHue.git'
```