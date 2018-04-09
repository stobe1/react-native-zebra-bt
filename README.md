
# react-native-zebra-bt-printer

This library is built for react native to work with Portable Zebra Bluetooth Printers. This library uses the libraries provided by Zebra. It has been tested with the QLN220, but should work with other QLN series printers that have bluetooth (non BLE mode).

## Getting started

`$ npm install react-native-zebra-bt-printer --save`

### Mostly automatic installation

`$ react-native link react-native-zebra-bt-printer`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-zebra-bt-printer` and add `RCTZebraBTPrinter.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRCTZebraBTPrinter.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.cyclelution.RCTZebraBTPrinterPackage;` to the imports at the top of the file
  - Add `new RNMyFancyLibraryPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-zebra-bt-printer'
  	project(':react-native-zebra-bt-printer').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-zebra-bt-printer/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-zebra-bt-printer')
  	```


## Usage

You must pair your printer first with the device.

iOS requires the printer serial#.

Android requires the MAC ADDRESS.

```javascript
import ZebraBTPrinter from 'react-native-zebra-bt-printer';

const printLabel = async (userPrintCount, userText1, userText2, userText3) => {

  console.log('printLabel APP');

  if(userText1 === ''){
    Alert.alert('Your label seems to be missing content!');
    return false;
  }

  try {

    //Store your printer serial or mac, ios needs serial, android needs mac
    const printerSerial = await AsyncStorage.getItem('printerSerial');

    //check if printer is set
    if (printerSerial !== null && printerSerial !== '') {

      ZebraBTPrinter.printLabel(printerSerial, userPrintCount, userText1, userText2, userText3).then((result) => {
        
        console.log(result);

        if (result === false) {
          Alert.alert('Print failed, please check printer connection');
        }

      })
      .catch((err) => console.log(err.message));

    } else {

      Alert.alert('Print failed, no printer setup found');

    }

  } catch (error) {
    // Error retrieving data
    console.log('Async getItem failed');
  }

}

// TODO: What to do with the module?
RCTZebraBTPrinter;
```

See Example. Remember to npm i in example