import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFScreen extends StatefulWidget {
  final String pdfAssetPath;

  PDFScreen({required this.pdfAssetPath});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  late PdfViewerController _pdfViewerController;
  late PdfTextSearchResult _searchResult;
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _loadLastReadPage();
  }

  Future<void> _loadLastReadPage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentPage = prefs.getInt('lastReadPage') ?? 0;
    });
    _pdfViewerController.jumpToPage(_currentPage + 1);
  }

  Future<void> _saveLastReadPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastReadPage', page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Stack(
        children: [
          SfPdfViewer.asset(
            widget.pdfAssetPath,
            controller: _pdfViewerController,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                _totalPages = details.document.pages.count;
                _isReady = true;
              });
            },
            onPageChanged: (PdfPageChangedDetails details) {
              setState(() {
                _currentPage = details.newPageNumber - 1;
                _saveLastReadPage(_currentPage);
              });
            },
            onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
              // Handle text selection if needed
            },
          ),
          if (_errorMessage.isNotEmpty)
            Center(child: Text(_errorMessage)),
          if (!_isReady)
            Center(child: CircularProgressIndicator()),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.0,
            left: 16.0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                'Page ${_currentPage + 1} of $_totalPages',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
