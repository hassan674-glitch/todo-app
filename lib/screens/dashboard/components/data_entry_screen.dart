import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/utils/custom_snakbar.dart';
import '../../../Model/book_class.dart';
import '../../../services/firestore_services.dart';
import '../../../utils/colors.dart';
import '../../../constants.dart';

class DataEntryScreen extends StatefulWidget {
  @override
  _DataEntryScreenState createState() => _DataEntryScreenState();
}

class _DataEntryScreenState extends State<DataEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String? _url;
  bool _isUploading = false;

  @override
  void dispose() {
    _bookNameController.dispose();
    _authorNameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<String> uploadPdf(String fileName, FilePickerResult file) async {
    final reference = FirebaseStorage.instance.ref().child("pdf/$fileName");
    UploadTask uploadTask;
    uploadTask = reference.putData(file.files.first.bytes!);
    await uploadTask.whenComplete(() {});
    final downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
  }

  void pickFile() async {
    setState(() {
      _isUploading = true;
    });

    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb,
    );

    if (pickedFile != null) {
      String filename = pickedFile.files.single.name;
      final downloadLink = await uploadPdf(filename, pickedFile);
      setState(() {
        _url = downloadLink;
        _isUploading = false;
      });
    } else {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_url == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload a PDF file')),
        );
        return;
      }

      final newBook = Book(
        id: '',
        bookName: _bookNameController.text,
        date: Timestamp.now(),
        category: _categoryController.text,
        authorName: _authorNameController.text,
        url: _url!,
      );

      await _firestoreService.createBook(newBook);

      Navigator.pop(context);
showCustomSnackbar(context: context, message:'Book added successfully',
    onUndoPressed: (){},
    onCustomActionPressed: (){});

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _bookNameController,
                decoration: InputDecoration(
                  labelText: 'Book Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the book name';
                  }
                  return null;
                },
              ),
              SizedBox(height: defaultPadding * 2),
              TextFormField(
                controller: _authorNameController,

                decoration: InputDecoration(
                  labelText: 'Author Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Author Name';
                  }
                  return null;
                },
              ),
              SizedBox(height: defaultPadding * 2),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the category';
                  }
                  return null;
                },
              ),
              SizedBox(height: defaultPadding * 2),
              _isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: pickFile,
                child: Text("Upload PDF"),
              ),
              SizedBox(height: defaultPadding * 2),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
