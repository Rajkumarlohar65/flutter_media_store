import 'package:flutter/services.dart';
import 'package:flutter_media_store/flutter_media_store_platform_interface.dart';

class FlutterMediaStoreMethodChannel
    extends FlutterMediaStorePlatformInterface {
  final MethodChannel _channel =
      const MethodChannel('com.example.flutter_media_store/media_store');

  @override
  Future<int> getAndroidSdkVersionNative() async {
    final result = await _channel.invokeMethod<int>('getAndroidSdkVersion');

    return result ?? 0;
  }

  @override
  Future<String> saveFileToMediaStore({
    required List<int> fileData,
    required String mimeType,
    required String rootFolderName, // Accept rootFolderName as input
    required String folderName,
    required String fileName, // Make fileName optional
    required Function(String uri, String filePath)
        onSuccess, // Update to accept both URI and filePath
    required Function(String errorMessage) onError, // Callback for error
  }) async {
    final result = await _channel.invokeMethod<String>(
      'saveFileToMediaStore',
      {
        'fileData': fileData,
        'fileName': fileName, // Pass the generated or user-provided fileName
        'mimeType': mimeType,
        'rootFolderName': rootFolderName, // Pass rootFolderName here
        'folderName': folderName, // Pass rootFolderName here
      },
    );
    return result ?? "Failed";
  }

  /// Append data to an existing file in the MediaStore
  @override
  Future<String> appendDataToMediaStore({
    required String uri,
    required List<int> fileData,
    required Function(String result)
        onSuccess, // Callback for success with result
    required Function(String errorMessage)
        onError, // Callback for error with message
  }) async {
    final result =
        await _channel.invokeMethod<String>('appendDataToMediaStore', {
      'uri': uri,
      'fileData': fileData,
    });

    return result ?? "Failed";
  }

  @override
  Future<List<String>> pickFile({
    required bool multipleSelect,
    required Function(List<String> uris) onFilesPicked,
    required Function(String errorMessage) onError,
  }) async {
    try {
      // Call the native platform method to pick files
      final result = await _channel.invokeMethod('pickFile', {
        'multipleSelect': multipleSelect,
      });

      // Check if the result is a List<Object?> and safely cast to List<String>
      if (result is List) {
        // Safely cast the result to List<String>
        List<String> uris = List<String>.from(result);
        return uris;
      } else {
        onError("Expected a list of URIs but got something else.");
        return [];
      }
    } catch (e) {
      onError('Error: ${e.toString()}');
      return [];
    }
  }
}
