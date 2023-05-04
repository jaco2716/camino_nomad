# Camino Nomad

Flutter SDK: v3.7.12
24/04/2023

## Commands
### Build JsonSerializable model classes:
```yaml
dependencies:
  json_annotation: ^4.8.0 #use @command:dart.addDependency

dev_dependencies:
  build_runner: ^2.3.3 #use @command:dart.addDevDependency
  json_serializable: ^6.6.0 #use @command:dart.addDevDependency
```

```dart
//Imports: Replace FILENAME
import 'package:json_annotation/json_annotation.dart';
part 'FILENAME.g.dart';
//Add above class
@JsonSerializable()
//Replace NAME with class
factory NAME.fromJson(Map<String, dynamic> json) => _$NAMEFromJson(json);
Map<String, dynamic> toJson() => _$NAMEToJson(this);
```
* flutter pub run build_runner build
* flutter pub run build_runner watch
---
### Launcher Icons
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

# Add Launcher icon run: flutter pub run flutter_launcher_icons
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
```
* flutter pub run flutter_launcher_icons
### Build iOS/Android Archive: 
Remember to change version! (version: 1.0.0+1 -> 1.0.1+2)
* flutter build ipa
* flutter build appbundle
---
## Useful config setup

### IOS  - NonExemptEncryption:false
```plist 
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
``` 

<details>
<summary>Screen Orientaion (Portrait olnly)</summary>

Input in main.dart -> MyApp -> after `Widget build(BuildContext context) {`
```dart
SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
```
For iOS (To work on iPad)
```plist
<array>
  <string>UIInterfaceOrientationPortrait</string>
</array>
```
</details>

<details>
<summary>IOS Setup for Bluetooth, Location and Wifi info</summary>

In Targets->Runner -> Signing & Capabilities -> +Capability -> Access Wifi information

In info.plist set: 
| Desc | Field Name | Value |
| --- | --- | --- |
| No encryption |App Uses Non-Exempt Encryption | NO |
| Set app Name | Bundle display name | APP_NAME |
| Use bluetooth | Privacy - Bluetooth Peripheral Usage Description |Bluetooth is required for some features|
| Use Bluetooth | Privacy - Bluetooth Always Usage Description | Bluetooth is required for some features
| Use location | Privacy - Location Always Usage Description | Location is required for some features
| Use location |Privacy - Location When In Use Usage Description | Location is required for some features
| Use location | Privacy - Location Always and When In Use Usage Description | Location is required for some features
| Use location | Privacy - Local Network Usage Description | Location is required for some features
| Use location | Privacy - Location Usage Description | Location is required for some features

Paste in info.plist for location and bluetooth (Location needed for WIFI info and connection to IOT device):
```plist
<key>NSBluetoothPeripheralUsageDescription</key>  
<string>Bluetooth is required for some features</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Bluetooth is required for some features</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Location is required for some features</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location is required for some features</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Location is required for some features</string>
<key>NSLocationUsageDescription</key>
<string>Location is required for some features</string>
<key>NSLocalNetworkUsageDescription</key>
<string>Local Network is required for some features</string>
```
</details>


<details>
<summary>Android Setup for Bluetooth, Location and Wifi info</summary>

* Find `minSdkVersion`=16, `compileSdkVersion`=33, `targetSdkVersion`=33 -> /FlutterSDK/flutter/packages/flutter_tools/gradle/flutter.gradle
* See guide for `permission_handler` [Here](https://pub.dev/packages/permission_handler)

</details>
---
