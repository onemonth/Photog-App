# Photog-App

##Setup

1. Install the latest version of [Xcode](https://developer.apple.com/xcode/downloads/) (Xcode 6.3.2 at the time of writing this)

1. Run `git clone git@github.com:onemonth/Photog-App.git` or download the zip from Github

1. Open the project in Xcode

1. In the `setupParse()` function at the bottom of the `AppDelegate.swift` file, replace the placeholder values with your Parse "Application ID" and "Client Key":

```
Parse.setApplicationId("YOUR_APPLICATION_ID", clientKey:"YOUR_CLIENT_KEY")
```

