import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermissions() async {
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
}
