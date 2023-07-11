import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../models/inventoryModels.dart';

class MemberSelectionDialog extends GetWidget {
      final List<String> usernameSuggestions;

  MemberSelectionDialog({required this.usernameSuggestions});

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Username'),
      content: TypeAheadField<String>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Username',
          ),
        ),
        suggestionsCallback: (pattern) {
          return usernameSuggestions.where((username) {
            return username.toLowerCase().contains(pattern.toLowerCase());
          }).toList();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        onSuggestionSelected: (suggestion) {
          _textEditingController.text = suggestion;
        },
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
            final enteredUsername = _textEditingController.text.trim();
            // Perform the desired action with the entered username
            if (enteredUsername.isNotEmpty) {
              print('Entered username: $enteredUsername');
              // Additional logic or validation can be performed here
            }
            Get.back();
          },
        ),
      ],
    );
  }

}
