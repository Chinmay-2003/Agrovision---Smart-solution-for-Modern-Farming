import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  // Function to request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      return true;  // Permission granted
    } else {
      return false;  // Permission denied
    }
  }

  // Function to check microphone permission status
  static Future<bool> checkMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.status;
    return status.isGranted;
  }
}
