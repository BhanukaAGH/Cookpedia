import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageInput extends StatelessWidget {
  final Uint8List? imageFile;
  final VoidCallback selectImage;
  final bool isError;

  const ImageInput({
    Key? key,
    this.imageFile,
    required this.selectImage,
    required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        onTap: selectImage,
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isError && imageFile == null
                  ? Colors.red
                  : Colors.transparent,
              width: isError && imageFile == null ? 1 : 0,
            ),
          ),
          child: ClipRRect(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: imageFile != null
                      ? MemoryImage(imageFile!)
                      : const AssetImage('assets/image_placeholder.jpg')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
