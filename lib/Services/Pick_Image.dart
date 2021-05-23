import 'dart:ffi';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

File pickedImage;
Future pickImage() async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    pickedImage = File(pickedFile.path);
    print('Image Picked');
  } else {
    print('no image');
  }
}

Future captureImage() async {
  final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

  if (pickedFile != null) {
    pickedImage = File(pickedFile.path);
    print('Image Picked');
    return pickedFile;
  } else {
    print('no image');
  }
}
