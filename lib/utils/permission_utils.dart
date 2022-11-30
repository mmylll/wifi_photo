import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {

  /**
   * 所有
   */
  static Future requestAllPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.camera,
      Permission.photos,
      Permission.speech,
      Permission.storage,
      Permission.location,
      Permission.phone,
      Permission.notification,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.manageExternalStorage,
    ].request();

    if (await Permission.photos.isGranted) {
      print("照片权限申请通过");
    } else {
      print("照片权限申请失败");
    }

    if (await Permission.speech.isGranted) {
      print("语音权限申请通过");
    } else {
      print("语音权限申请失败");
    }

    if (await Permission.storage.isGranted) {
      print("文件权限申请通过");
    } else {
      print("文件权限申请失败");
    }

    if (await Permission.location.isGranted) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请失败");
    }

    if (await Permission.phone.isGranted) {
      print("手机权限申请通过");
    } else {
      print("手机权限申请失败");
    }

    if (await Permission.notification.isGranted) {
      print("通知权限申请通过");
    } else {
      print("通知权限申请失败");
    }

    if (await Permission.bluetooth.isGranted) {
      print("蓝牙权限申请通过");
    } else {
      print("蓝牙权限申请失败");
    }

    if (await Permission.bluetoothScan.isGranted) {
      print("bluetoothScan权限申请通过");
    } else {
      print("bluetoothScan权限申请失败");
    }

    if (await Permission.bluetoothConnect.isGranted) {
      print("bluetoothConnect权限申请通过");
    } else {
      print("bluetoothConnect权限申请失败");
    }

    if (await Permission.bluetoothAdvertise.isGranted) {
      print("bluetoothAdvertise权限申请通过");
    } else {
      print("bluetoothAdvertise权限申请失败");
    }

    if (await Permission.manageExternalStorage.isGranted) {
      print("外存权限申请通过");
    } else {
      print("外存权限申请失败");
    }
  }

  static Future requestCameraPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.camera,
    ].request();

    if (await Permission.camera.isGranted) {
      print("相机权限申请通过");
    } else {
      print("相机权限申请失败");
    }
  }

  static Future requestPhotosPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.photos,
    ].request();

    if (await Permission.photos.isGranted) {
      print("照片权限申请通过");
    } else {
      print("照片权限申请失败");
    }

  }

  static Future requestSpeechPermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.speech,
    ].request();



    if (await Permission.speech.isGranted) {
      print("语音权限申请通过");
    } else {
      print("语音权限申请失败");
    }

  }

  static Future requestStoragePermission() async {
    Map<Permission, PermissionStatus> permission = await [
      Permission.storage,
    ].request();

    if (await Permission.storage.isGranted) {
      print("文件权限申请通过");
    } else {
      print("文件权限申请失败");
    }
  }

  static Future requestLocationPermission() async {
    Map<Permission, PermissionStatus> permission = await [

      Permission.location,
    ].request();

    if (await Permission.location.isGranted) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请失败");
    }

  }

  static Future requestPhonePermission() async {
    Map<Permission, PermissionStatus> permission = await [

      Permission.phone,
    ].request();

    if (await Permission.phone.isGranted) {
      print("手机权限申请通过");
    } else {
      print("手机权限申请失败");
    }

  }

  static Future requestNotificationPermission() async {
    Map<Permission, PermissionStatus> permission = await [

      Permission.notification,
    ].request();

    if (await Permission.notification.isGranted) {
      print("通知权限申请通过");
    } else {
      print("通知权限申请失败");
    }
  }

}