import 'package:flutter/material.dart';
import 'package:frontend/models/inventoryModels.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get_storage/get_storage.dart';

class PlayerSelectionDialog extends StatelessWidget {
  final List<BattingStats> batsmenList_;
  final List<BlowingStats> blowingList_;
  final Rx<BattingStats> striker_;
  final Rx<BattingStats> nonStriker_;
  final Rx<BlowingStats> blower_;

  late final List<String> batsmenList;
  late final List<String> bowlersList;
  final RxString striker = RxString('');
  final RxString nonStriker = RxString('');
  final RxString bowler = RxString('');

  PlayerSelectionDialog({
    required this.batsmenList_,
    required this.blowingList_,
    required this.striker_,
    required this.nonStriker_,
    required this.blower_,
  }) {
    batsmenList = batsmenList_.map((e) => e.displayName).toList();
    bowlersList = blowingList_.map((e) => e.displayNames).toList();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController strikerController = new TextEditingController();
    TextEditingController nonstrikerController = new TextEditingController();
    TextEditingController blowerController = new TextEditingController();
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
              controller: strikerController,
              decoration: InputDecoration(
                hintText: 'Striker',
              ),
            ),
            suggestionsCallback: (pattern) {
              return batsmenList.where((player) {
                return player.toLowerCase().contains(pattern.toLowerCase());
              }).toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
                strikerController.text = suggestion;
              striker.value = suggestion;
            },
          ),

          SizedBox(height: 16),

          TypeAheadField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              onChanged: (value) {
                nonStriker.value = value;
              },
              controller: nonstrikerController,
              decoration: InputDecoration(
                hintText: 'Non-striker',
              ),
            ),
            suggestionsCallback: (pattern) {
              return batsmenList
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
              nonstrikerController.text = suggestion;
              nonStriker.value = suggestion;
            },
          ),


          SizedBox(height: 16),
          // Text('Bowler:'),
          TypeAheadField<String>(
            textFieldConfiguration: TextFieldConfiguration(
              onChanged: (value) {
                bowler.value = value;
              },
               controller: blowerController ,
              decoration: InputDecoration(
                hintText: 'Select bowler',
              ),
            ),
            suggestionsCallback: (pattern) {
              return bowlersList.where((player) {
                return player.toLowerCase().contains(pattern.toLowerCase());
              }).toList();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              blowerController.text=suggestion;
              bowler.value = suggestion;

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
            final selectedStriker = striker.value;
            final selectedNonStriker = nonStriker.value;
            final selectedBowler = bowler.value;

            if (selectedStriker.isNotEmpty &&
                selectedNonStriker.isNotEmpty &&
                selectedBowler.isNotEmpty) {
              striker_.value = batsmenList_
                  .firstWhere((element) => element.displayName == striker.value);
              nonStriker_.value = batsmenList_
                  .firstWhere((element) => element.displayName == nonStriker.value);
              blower_.value = blowingList_
                  .firstWhere((element) => element.displayNames == bowler.value);
              // Perform the desired actions with the selected players
            }
            Get.back();
          },
        ),
      ],
    );
  }
}

