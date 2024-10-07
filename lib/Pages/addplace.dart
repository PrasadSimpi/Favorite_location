import 'dart:io';

import 'package:favouritelocation/models/place.dart';
import 'package:favouritelocation/riverpod/userplaces.dart';
import 'package:favouritelocation/widget/imageinput.dart';
import 'package:favouritelocation/widget/locationinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Addplacescreen extends ConsumerStatefulWidget {
  const Addplacescreen({super.key});

  @override
  ConsumerState<Addplacescreen> createState() {return _AddplacescreenState();
}}

class _AddplacescreenState extends ConsumerState<Addplacescreen> {
  final titlecontroller = TextEditingController();
  File? selectedimage;
  Placelocation? selectedlocation;
  void savePlace() {
    final enteredtitle = titlecontroller.text;
    if (selectedimage == null || enteredtitle.isEmpty || selectedlocation == null) {
      return;
    }
    ref
        .read(Userplacesprovider.notifier)
        .addplaces(enteredtitle, selectedimage!,selectedlocation!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new Place'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextField(
                controller: titlecontroller,
                decoration: const InputDecoration(labelText: 'title'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Imageinput(
                onpickimage: (image) {
                  selectedimage = image;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Locationinput(
                onselectlocation: (location) {
                  selectedlocation = location;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  onPressed: savePlace,
                  label: const Text('add Place'))
            ],
          ),
        ));
  }
}
