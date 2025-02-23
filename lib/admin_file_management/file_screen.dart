import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:khmenu_mobile/env.dart';
import 'package:khmenu_mobile/admin_file_management/file_service.dart';

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  List<MyFile> _fileList = [];
  bool _isLoading = false;

  // Fetch files from API
  Future<void> _fetchFiles() async {
    setState(() {
      _isLoading = true;
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
      } else if (response.statusCode == 401) {
        setState(() {});
      } else {
        setState(() {});
      }
    } catch (e) {
      setState(() {});
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Delete file
  Future<void> _deleteFile(MyFile file) async {
    String url = "${Env.apiBaseUrl}/v1/files/${file.id}";
    String? token = await Env.apiStorage.read(key: Env.apiKey);

    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() {
          _fileList.removeWhere((element) => element.id == file.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete file: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting file: $e")),
      );
    }
  }

  // Delete file confirmation
  Future<void> _confirmDeleteFile(MyFile file) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete File"),
        content: Text("Are you sure you want to delete '${file.filename}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deleteFile(file); // Call delete only if confirmed
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
      appBar: AppBar(title: Text('Files')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _fileList.length,
              itemBuilder: (context, index) {
                var file = _fileList[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      "${Env.apiBaseUrl}/uploads/${file.filename}",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.insert_drive_file, size: 50),
                    ),
                    title: Text(file.filename),
                    subtitle: Text(_formatDate(file.createdDate)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteFile(file),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
