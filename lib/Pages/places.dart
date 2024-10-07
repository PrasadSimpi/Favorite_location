import 'package:favouritelocation/Pages/addplace.dart';
import 'package:favouritelocation/riverpod/userplaces.dart';
import 'package:favouritelocation/widget/placeslist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class placeslistscreen extends ConsumerStatefulWidget {
  const placeslistscreen({super.key});
  @override
  ConsumerState<placeslistscreen> createState() {
    return _placeslistscreenState();
  }
}

class _placeslistscreenState extends ConsumerState<placeslistscreen> {
  late Future<void> _placesfuture;
  @override
  void initState() {
    super.initState();
    _placesfuture = ref.read(Userplacesprovider.notifier).loadplaces();
  }

  @override
  Widget build(BuildContext context) {
    final userplaces = ref.watch(Userplacesprovider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your places'), 
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const Addplacescreen()));
            },
            icon: const Icon(Icons.add),
          )
        ]),
        body: Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
              future:_placesfuture,
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : Placeslist(
                          places: userplaces,
                        ),
            )));
  }
}
