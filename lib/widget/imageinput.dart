import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Imageinput extends StatefulWidget {
  const Imageinput({super.key, required this.onpickimage});
  final void Function(File image) onpickimage;
  @override
  State<Imageinput> createState() => _ImageinputState();
}

class _ImageinputState extends State<Imageinput> {
  File? selectedimage;
  void takepicture() async {
    final imagepicker = ImagePicker();
    final pickedimage =
        await imagepicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedimage == null) {
      return;
    }
    setState(() {
      selectedimage = File(pickedimage.path);
    });
    widget.onpickimage(selectedimage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: const Icon(Icons.camera),
      label: const Text('take picture'),
      onPressed: takepicture,
    );
    if (selectedimage != null) {
      content = GestureDetector(
        onTap: takepicture,
        child: Image.file(
          selectedimage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        )),
        height: 250,
        width: double.infinity,
        child: content);
  }
}
