# AstraLib

[![CI Status](https://img.shields.io/travis/Cung Truong/AstraLib.svg?style=flat)](https://travis-ci.org/Cung Truong/AstraLib)
[![Version](https://img.shields.io/cocoapods/v/AstraLib.svg?style=flat)](https://cocoapods.org/pods/AstraLib)
[![License](https://img.shields.io/cocoapods/l/AstraLib.svg?style=flat)](https://cocoapods.org/pods/AstraLib)
[![Platform](https://img.shields.io/cocoapods/p/AstraLib.svg?style=flat)](https://cocoapods.org/pods/AstraLib)

## Features

- In-App Purchase
- Remote notification
- Adjust tracking
- Firebase tracking
- Facebook tracking


## Requirements

| iOS |
| --- |
| 13.0 |


## Cocoapods

AstraLib is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
use_frameworks!

pod 'AstraLib'
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Document

### Tutorials 

- [Adjust](https://github.com/adjust/ios_sdk)
- [Firebase](https://firebase.google.com/docs/analytics/get-started?platform=ios)
- [Facebook](https://developers.facebook.com/docs/app-events/getting-started-app-events-ios)

### AstraLib+Custom

Copy "AstraLib+Custom" folder to your project, edit content inside this folder

### AppDelegate.swift

```swift

class AppDelegate: UIResponder, UIApplicationDelegate { 

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupAstraLib(application, launchOptions: launchOptions)

        
        return true
    }
}

```

## Author

Cung Truong, vancungtruong@gmail.com

## License

AstraLib is available under the MIT license. See the LICENSE file for more info.
