import 'package:image_picker/image_picker.dart';

class Utils {
  final ImagePicker _picker = ImagePicker();
  Future<String> imagePicker() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    return picked!.path;
  }
}
