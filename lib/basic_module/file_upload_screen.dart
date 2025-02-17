import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:khmenu_mobile/env.dart';
import 'package:khmenu_mobile/basic_module/file_service.dart'; // Import your file service

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  List<MyFile> _fileList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Fetch files from API
  Future<void> _fetchFiles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String url = "${Env.apiBaseUrl}/v1/files";
    String? token = await Env.apiStorage.read(key: Env.apiKey);

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          _fileList = myFileFromJson(response.body);
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to fetch files';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching files: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchFiles();
  }

  // Format date to readable string
  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('File List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading) Center(child: CircularProgressIndicator()),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            if (!_isLoading && _errorMessage == null)
              Expanded(
                child: ListView.builder(
                  itemCount: _fileList.length,
                  itemBuilder: (context, index) {
                    var file = _fileList[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.insert_drive_file),
                        title: Text(file.originalname),
                        subtitle: Text(
                          'Size: ${file.size} bytes\nUploaded: ${_formatDate(file.createdDate)}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.download),
                          onPressed: () {
                            // Implement download logic here
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
