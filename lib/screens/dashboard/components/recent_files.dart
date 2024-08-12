import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/resuable_text_widget.dart';
import 'package:todo_app/utils/colors.dart';
import '../../../Model/book_class.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../../services/firestore_services.dart';
import '../../../utils/custom_snakbar.dart';
import 'data_entry_screen.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({Key? key}) : super(key: key);

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService bookService = FirestoreService();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  Future<void> updateBook(Book book) async {
    _bookNameController.clear();
    _authorNameController.clear();
    _categoryController.clear();

    _bookNameController.text = book.bookName;
    _authorNameController.text = book.authorName ?? '';
    _categoryController.text = book.category;

    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
          ),
          child: AlertDialog(
            title: const Text('Update Book'),
            content: SingleChildScrollView(
              child: Container(
                width: 400,
                height: 300,
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _bookNameController,
                            decoration: const InputDecoration(labelText: 'Book Name'),
                          ),
                          TextFormField(
                            controller: _authorNameController,
                            decoration: const InputDecoration(labelText: 'Author Name'),
                          ),
                          TextFormField(
                            controller: _categoryController,
                            decoration: const InputDecoration(labelText: 'Category'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  final Timestamp currentTimestamp = Timestamp.now();
                  final updatedBook = Book(
                    id: book.id,
                    bookName: _bookNameController.text,
                    date: book.date,
                    updatedOn: currentTimestamp,
                    authorName: _authorNameController.text,
                    category: _categoryController.text,
                    url: book.url,
                  );

                  await bookService.updateBook(updatedBook);

                  Navigator.of(context).pop();
                  showCustomSnackbar(
                    context: context,
                    message: "Book Updated Successfully",
                    onUndoPressed: () {},
                    onCustomActionPressed: () {},
                  );
                  setState(() {});
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

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
    return StreamBuilder(
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
        List<Book> books = snapshot.data ?? [];
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.dashBoardColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent Files",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final newFile = await Navigator.push<Book>(
                        context,
                        MaterialPageRoute(builder: (context) => DataEntryScreen()),
                      );
                      if (newFile != null) {
                        bookService.createBook(newFile);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add New"),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: defaultPadding - 8,
                  columns: const [
                    DataColumn(
                      label: Text(
                        "No",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Title",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Author Name",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),

                    DataColumn(
                      label: Text(
                        "Last Updated",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Actions",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  rows: books.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    Book book = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            index.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        DataCell(
                          Tooltip(
                            message: book.bookName,
                            child: ResuableTextWidgetWidget(bookTitle: book.bookName,),
                          ),
                        ),
                        DataCell(
                          Text(
                            book.authorName ?? "Unknown",
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 12),
                          ),
                        ),

                        DataCell(
                          Text(
                            DateFormat("dd MMM, yyyy").format(book.updatedOn?.toDate() ?? book.date.toDate()),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        DataCell(
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    updateBook(book);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.BlueColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2,),
                                InkWell(
                                  onTap: () {
                                    confirmDelete(book);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.BrownColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
