import 'package:flutter_media_store/flutter_media_store_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';


abstract class FlutterMediaStorePlatformInterface extends PlatformInterface {
  FlutterMediaStorePlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static FlutterMediaStorePlatformInterface _instance = FlutterMediaStoreMethodChannel();

  static FlutterMediaStorePlatformInterface get instance => _instance;

  static set instance(FlutterMediaStorePlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> saveFileToMediaStore({
    required String rootFolderName,
    required String folderName,
    required String mimeType,
    required List<int> fileData,
    required String fileName,
    required Function(String filePath) onSuccess, // Callback for success
    required Function(String errorMessage) onError, // Callback for error
  });
}
