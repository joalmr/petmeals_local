import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:petmeals_local/src/core/error/failure.dart';

Future<String> uploadImage(File image, String petId) async {
  try {
    File? img;
    // Get the application folder directory
    final directory = await getApplicationCacheDirectory();

    // Copy Image to the directory
    img = await File(image.path).copy('${directory.path}/$petId');

    Logger().w(img.path.toString());

    return img.path.toString();
  } on Exception catch (e) {
    throw LocalFailure(message: e.toString());
  }
}

void deleteImage(String pathImage) async {
  try {
    // final deleteFile =
    File(pathImage).delete();
  } on Exception catch (e) {
    throw LocalFailure(message: e.toString());
  }
}
