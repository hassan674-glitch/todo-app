import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../Model/book_class.dart';



class FirestoreService {
  final CollectionReference booksCollection = FirebaseFirestore.instance.collection('books');
  Future<void> createBook(Book book) async {
    await booksCollection.add(book.toMap());
  }

  Stream<List<Book>> readBooks() {
    return booksCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Book.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  Future<void> updateBook(Book book) async {
    await booksCollection.doc(book.id).update(book.toMap());
  }

  Future<void> deleteBook(String id) async {
    await booksCollection.doc(id).delete();
  }
}
