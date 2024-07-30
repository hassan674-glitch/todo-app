import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/utils/custom_snakbar.dart';
import 'package:todo_app/services/firestore_services.dart';
import '../../../Model/book_class.dart';
import '../../../constants.dart';

class DataEntryScreen extends StatelessWidget {
  final Book? book;
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field3Controller = TextEditingController();
  late String _title;
  late int _pages;

  DataEntryScreen({super.key, this.book}) {
    if (book != null) {
      _field1Controller.text = book!.bookName;
      _field3Controller.text = book!.pages.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: constraints.maxWidth < 600
                      ? Column(
                    children: _buildFormFields(context, constraints),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildFormFields(context, constraints)
                        .map((field) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: field,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildFormFields(BuildContext context, BoxConstraints constraints) {
    List<Widget> formFields = [
      TextFormField(
        controller: _field1Controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: 'Book Name'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onSaved: (value) => _title = value!,
      ),

      TextFormField(
        controller: _field3Controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: 'Pages'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          if (int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onSaved: (value) => _pages = int.parse(value!),
      ),
      ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final Timestamp currentTimestamp = Timestamp.now();

            Book saveBook = Book(
              id: book?.id ?? '',
              bookName: _title,
              date: currentTimestamp,
              pages: _pages,
              updatedOn: book == null ? null : currentTimestamp,
            );

              await _firestoreService.createBook(saveBook);


            Navigator.pop(context);
          showCustomSnackbar(context: context, message: "New Book aded", onUndoPressed: (){}, onCustomActionPressed:(){} );

          }
        },
        child: const Text('Submit'),
      ),
    ];

    return constraints.maxWidth < 600
        ? formFields
        .map((field) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: field,
    ))
        .toList()
        : formFields;
  }
}
