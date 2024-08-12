import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  String id;
  String bookName;
  Timestamp date;
  Timestamp? updatedOn;
  String category;
  String authorName;
  String? url;

  Book({
    required this.id,
    required this.bookName,
    required this.date,
    required this.category,
    this.updatedOn,
    required this.authorName,
    this.url
  });

  factory Book.fromMap(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,
      bookName: data['bookName'] ?? '',
      date: data['date'] ?? Timestamp.now(),
      category: data['category'] ?? '',
      updatedOn: data['updatedOn'],
      authorName: data['authorName'],
      url: data['url']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookName': bookName,
      'date': date,
      'category': category,
      'updatedOn': updatedOn,
      'authorName': authorName,
      'url':url
    };
  }
}
