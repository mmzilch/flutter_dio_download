import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFile extends StatefulWidget {
  final String link;
  DownloadFile({this.link});
  @override
  _DownloadFileState createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  Future<void> openFile() async {
    var dir = await getExternalStorageDirectory();
    final filePath = "${dir.path}/livinginthelight.pdf";
    print("${dir.path}/test.pdf");
    final result = await OpenFile.open(filePath);
    print(result);
  }

  String downloadMessage = " ";
  bool _isDownloading = false;
  double _percantage = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff718289),
          elevation: 0.0,
          title: Text("Download"),
        ),
        backgroundColor: Color(0xff718289),
        body: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            FloatingActionButton.extended(
              onPressed: () async {
                setState(() {
                  _isDownloading = !_isDownloading;
                });
                var dir = await getExternalStorageDirectory();
                Dio dio = Dio();
                dio.download("http://192.168.1.100/filedownload.php", "${dir.path}/livinginthelight.pdf",
                    onReceiveProgress: (actualByte, totalByte) {
                  var percentage = actualByte / totalByte * 100;
                  if (percentage < 100) {
                    setState(() {
                      _percantage = percentage / 100;
                      downloadMessage =
                          'Downloading... ${percentage.floor()} %';
                    });
                  } else {
                    setState(() {
                      downloadMessage = "Download Complete .";
                    });
                    openFile();
                  }
                });
              },
              label: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text("Download"),
              ),
              backgroundColor: Color(0xff4BB2BE),
              icon: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Icon(Icons.file_download),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(downloadMessage ?? "", style: TextStyle(color: Colors.white)),
            Padding(
              padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  backgroundColor: Color(0xff718289),
                  value: _percantage,
                ),
              ),
            
          ],
        ),
      ),
    );
  }
}