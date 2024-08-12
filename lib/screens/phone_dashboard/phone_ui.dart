import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_app/screens/dashboard/components/data_entry_screen.dart';
import 'package:todo_app/screens/phone_dashboard/phone_eidt_screen.dart';
import 'package:todo_app/utils/resuable_text_widget.dart';
import 'package:todo_app/utils/size.dart';
import '../../Model/book_class.dart';
import '../../constants.dart';
import '../../services/firestore_services.dart';
import '../../utils/colors.dart';
import '../../utils/custom_snakbar.dart';
import 'add_new_book.dart';

class PhoneUi extends StatefulWidget {
  const PhoneUi({super.key});

  @override
  State<PhoneUi> createState() => _PhoneUiState();
}

class _PhoneUiState extends State<PhoneUi> {
  final FirestoreService bookService = FirestoreService();

  Future<void> confirmDelete(Book book) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Book'),
          content: const Text('Are you sure you want to delete this book?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final storageRef = FirebaseStorage.instance.refFromURL(book.url!);
                  await storageRef.delete();
                  await bookService.deleteBook(book.id);
                  Navigator.of(context).pop();
                  showCustomSnackbar(
                    context: context,
                    message: "Book Deleted Successfully",
                    onUndoPressed: () {},
                    onCustomActionPressed: () {},
                  );
                  setState(() {});
                } catch (e) {
                  Navigator.of(context).pop();
                  showCustomSnackbar(
                    context: context,
                    message: "Error deleting book: $e",
                    onUndoPressed: () {},
                    onCustomActionPressed: () {},
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<List<Book>>(
      stream: bookService.readBooks(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == null) {
          return Center(child: Text("Enter Book"));
        }
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final List<Book> books = snapshot.data!;
        return Expanded(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Hi Admin!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "Welcome to Your Panel.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ResuableTextWidgetWidget(
                      bookTitle: "Book List",
                      size: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (BuildContext context, int index) {
                        final book = books[index];
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.listTileColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditBookScreen(book: book),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.lightBlueColor,
                                    ),
                                  ),
                                  SizedBox(width: 1),
                                  IconButton(
                                    onPressed: () {
                                      confirmDelete(book);
                                    },
                                    icon: Icon(
                                      CupertinoIcons.delete,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                              leading: SvgPicture.asset(
                                "assets/svgs/book.svg",
                                width: 30,
                                height: 30,
                              ),
                              title: ResuableTextWidgetWidget(
                                bookTitle: book.bookName,
                                color: AppColors.lightBlueColor,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Author: ${book.authorName}",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 8,
                                    ),
                                  ),
                                  Text(
                                    "Category: ${book.category}",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: screenHeight * 0.77,
                right: screenWidth * 0.040,
                child: FloatingActionButton(
                  onPressed: () {
                    Get.to(AddNewScreen());
                  },
                  child: Icon(CupertinoIcons.plus),
                  backgroundColor: AppColors.BlueColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
