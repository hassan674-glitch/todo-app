import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String id;
  String bookName;
  Timestamp date;
  Timestamp? updatedOn;
  int pages;

  Book({required this.id, required this.bookName, required this.date, required this.pages,this.updatedOn});

  factory Book.fromMap(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,
      bookName: data['bookName'],
      date: data['Date'],
      pages: data['Pages'],
      updatedOn: data['updatedOn'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookName': bookName,
      'Date': date,
      'Pages': pages,
      'updatedOn':updatedOn
    };
  }
}
