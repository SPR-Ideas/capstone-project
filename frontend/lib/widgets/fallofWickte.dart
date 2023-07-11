import 'package:flutter/material.dart';
import 'package:frontend/models/inventoryModels.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';

class fallofWicket extends StatelessWidget {
  final List<BattingStats> currentBatsmenList;
  final List<BattingStats> newBatsmenList;


  final Rx<BattingStats> currentBt_;
  final Rx<BattingStats> newBt_;


  late final List<String> currentlist;
  late final List<String> newlist;
  final RxString striker = RxString('');
  final RxString nonStriker = RxString('');
  final RxString bowler = RxString('');

  fallofWicket({
    required this.currentBatsmenList,
    required this.newBatsmenList,
    required this.currentBt_,
    required this.newBt_,
  }) {
    currentlist = currentBatsmenList.map((e) => e.displayName).toList();
    newlist = newBatsmenList.map((e) => e.displayName).toList();
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

          TypeAheadField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              onChanged: (value) {
                striker.value = value;
              },
              controller: currentBtController,
              decoration: InputDecoration(
                hintText: 'currentBatsmen',
              ),
            ),
            suggestionsCallback: (pattern) {
              return currentlist.where((player) {
                return player.toLowerCase().contains(pattern.toLowerCase());
              }).toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
                currentBtController.text = suggestion;
              striker.value = suggestion;
            },
          ),

          SizedBox(height: 16),

          TypeAheadField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              onChanged: (value) {
                nonStriker.value = value;
              },
              controller: newBtController,
              decoration: InputDecoration(
                hintText: 'New Batsmen',
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

            currentBt_.value = currentBatsmenList.firstWhere((element) => element.displayName == currentBtController.text);
            newBt_.value = newBatsmenList.firstWhere((element) => (element.displayName == newBtController.text));

            Get.back();
          },
        ),
      ],
    );
  }
}

