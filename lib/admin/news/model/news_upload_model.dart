import 'package:image_picker/image_picker.dart';

class NewsUploadModel {
  final String source;
  final String title;
  final List<XFile?> images;

  NewsUploadModel({
    required this.source,
    required this.title,
    required this.images,
  });

}
