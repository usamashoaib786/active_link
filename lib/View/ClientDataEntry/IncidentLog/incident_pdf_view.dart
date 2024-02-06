import 'package:active_link/Utils/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class IncidentPDFView extends StatefulWidget {
  final String pdfPath;
  const IncidentPDFView({super.key, required this.pdfPath});

  @override
  State<IncidentPDFView> createState() => _IncidentPDFViewState();
}

class _IncidentPDFViewState extends State<IncidentPDFView> {
  late PDFViewController pdfViewController;
  @override
  Widget build(BuildContext context) {
    print("knfeknfkefkn${widget.pdfPath}");
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Behaviour Log PDF View",
        img: "assets/images/Vector.png",
      ),
      body: PDFView(
        filePath: widget.pdfPath,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        onError: (error) {
          print(error);
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController vc) {
          pdfViewController = vc;
        },
        onPageChanged: (int? page, int? total) {
          print('page change: $page/$total');
        },
      ),
    );
  }
}
