# USBDeviceDetecotrApp

**Still being implemented.**

This is an application that toggles the mute state of existing audio devices when the USB device specified by name is connected/removed.

## Observing a USB Device

A USB device to be observed is specified by `Trigger Device Name` key in this app's UserDefaults. 

If you want to observe a USB device named `Microsoft® 2.4GHz Transceiver v9.0`, set the name to the value of `Trigger Device Name` key using the following command.

```
defaults write jp.ez-net.USBDeviceDetectorApp "Trigger Device Name" "Microsoft® 2.4GHz Transceiver v9.0"
```
