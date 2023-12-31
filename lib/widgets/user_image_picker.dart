import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onImagePicked});

  final void Function(File pickedImage) onImagePicked;

  @override
  State<StatefulWidget> createState() {
    return _ImagePickerState();
  }
}

class _ImagePickerState extends State<UserImagePicker> {
  File? _pickedImagefile;

  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 50);
    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImagefile = File(pickedImage.path);
    });
    widget.onImagePicked(_pickedImagefile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImagefile != null ? FileImage(_pickedImagefile!) : null,
        ),
        TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: Text(
              "Add Image",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ))
      ],
    );
  }
}
