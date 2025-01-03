import 'package:flutter_media_store/flutter_media_store_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class FlutterMediaStore {
  /// Save a file to the MediaStore with success and error handling.
  Future<void> saveFileToMediaStore({
    required List<int> fileData,
    required String mimeType,
    required String rootFolderName,
    required String folderName,
    required String fileName,
    required Function(String result) onSuccess, // Callback for success with file path
    required Function(String errorMessage) onError, // Callback for error with message
  }) async {

    if (!await _checkAndRequestPermissions()) {
      onError('Permission denied. Cannot save file.');
      return;
    }

    try {
      final result = await FlutterMediaStorePlatformInterface.instance.saveFileToMediaStore(
        fileData: fileData,
        fileName: fileName,
        mimeType: mimeType,
        rootFolderName: rootFolderName,
        folderName: folderName,
        onSuccess: onSuccess,
        onError: onError,
      );

      if (result.startsWith("IOException") || result.startsWith("Failed")) {
        // Failure, invoke onError with the error message
        onError(result);
      } else {
        // Success, invoke onSuccess with file path
        onSuccess(result);
      }
    } catch (e) {
      onError('Error: ${e.toString()}');
    }
  }

  /// Check and request necessary permissions
  Future<bool> _checkAndRequestPermissions() async {
    // Check for storage permissions (e.g., WRITE_EXTERNAL_STORAGE on Android)
    PermissionStatus status = await Permission.storage.request();

    // Check if permission is granted
    return status.isGranted;
  }
}
