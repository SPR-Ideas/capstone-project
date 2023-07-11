import 'package:flutter/material.dart';
import 'package:frontend/models/inventoryModels.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';

class NextOver extends StatelessWidget {
  // final List<BlowingStats> currentBlowerList;
  final List<BlowingStats> newBlowerList;


  // final Rx<BlowingStats> currentBl_;
  final Rx<BlowingStats> newBl_;


  late final List<String> currentlist;
  late final List<String> newlist;
  final RxString striker = RxString('');
  final RxString nonStriker = RxString('');
  final RxString bowler = RxString('');

  NextOver({
    // required this.currentBlowerList,
    required this.newBlowerList,
    // required this.currentBl_,
    required this.newBl_,
  }) {
    // currentlist = currentBlowerList.map((e) => e.displayNames).toList();
    newlist = newBlowerList.map((e) => e.displayNames).toList();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController currentBtController = new TextEditingController();
    TextEditingController newBtController = new TextEditingController();

    return AlertDialog(
      title: Text('Select Players'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          // TypeAheadField<String>(
          //   textFieldConfiguration: TextFieldConfiguration(
          //     onChanged: (value) {
          //       striker.value = value;
          //     },
          //     controller: currentBtController,
          //     decoration: InputDecoration(
          //       hintText: 'currentBlower',
          //     ),
          //   ),
          //   suggestionsCallback: (pattern) {
          //     return currentlist.where((player) {
          //       return player.toLowerCase().contains(pattern.toLowerCase());
          //     }).toList();
          //   },
          //   itemBuilder: (context, suggestion) {
          //     return ListTile(
          //       title: Text(suggestion),
          //     );
          //   },
          //   onSuggestionSelected: (suggestion) {
          //       currentBtController.text = suggestion;
          //     striker.value = suggestion;
          //   },
          // ),

          SizedBox(height: 16),

          TypeAheadField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              onChanged: (value) {
                nonStriker.value = value;
              },
              controller: newBtController,
              decoration: InputDecoration(
                hintText: 'New Blower',
              ),
            ),
            suggestionsCallback: (pattern) {
              return newlist
                  .where((player) =>
                      player.toLowerCase().contains(pattern.toLowerCase()))
                  .where((player) => player != striker.value)
                  .toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              newBtController.text = suggestion;
              nonStriker.value = suggestion;
            },
          ),

        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {

            // currentBl_.value = currentBlowerList.firstWhere((element) => element.displayNames == currentBtController.text);
            newBl_.value = newBlowerList.firstWhere((element) => (element.displayNames == newBtController.text));

            Get.back();
          },
        ),
      ],
    );
  }
}

