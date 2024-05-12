import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:active_link/Utils/utils.dart';
import 'package:active_link/View/ClientDataEntry/behaviourLog/behaviours_pdf_view.dart';
import 'package:active_link/config/app_urls.dart';
import 'package:active_link/config/dio/app_dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class IncidentApiServices {
  Future<File?> incidentLogs({required AppDio dio, required BuildContext context}) async {
    try {
      final response = await dio.get(path: AppUrls.incidentLogList);
      var appDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      if (response.data["status"] == true) {
        String tempPath = appDir!.path;
        final String fileName = '${DateTime.now().microsecondsSinceEpoch}-akt.pdf';
        File file = File('$tempPath/$fileName');
        showSnackBar(context, "File Save Successfully");

        if (!await file.exists()) {
          await file.create();
        }

        final pdf = pw.Document();

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Table.fromTextArray(
              cellAlignment: pw.Alignment.centerLeft,
              headerAlignment: pw.Alignment.centerLeft,
              cellHeight: 30,
              headerHeight: 40,
              // cellWidth: 50,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              headers: ['Reference', 'Client', 'Created By', 'Entry Date'],
              data: List<List<String>>.generate(
                response.data['incidents'].length,
                    (index) {
                  final behavior = response.data['incidents'][index];
                  return [
                    behavior['client_incident_id'].toString(),
                    "${behavior['f_name']} ${behavior['l_name']}",
                    "Admin",
                    behavior['incident_created'].toString(),
                  ];
                },
              ),
            ),
          ),
        );

        await file.writeAsBytes(await pdf.save());
        push(context, BehavioursPDFView(pdfPath: file.path));

        return file;
      } else {
        print(response.data["message"]);
      }
    } catch (error) {
      print("catch_error: $error");
    }
    return null;
  }
}
