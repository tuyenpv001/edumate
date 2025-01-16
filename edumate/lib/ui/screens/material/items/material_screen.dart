import 'package:edumate/ui/screens/material/services/upload_service..dart';
import 'package:flutter/material.dart';

class MaterialManagementScreen extends StatefulWidget {
  @override
  _MaterialManagementScreenState createState() =>
      _MaterialManagementScreenState();
}

class _MaterialManagementScreenState extends State<MaterialManagementScreen> {
  final UploadService _materialService = UploadService();
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _materials = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  String? _keyword;

  @override
  void initState() {
    super.initState();
    _fetchMaterials();
  }

  Future<void> _fetchMaterials() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _materialService.fetchMaterials(
        pageSize: 10,
        page: _currentPage,
        keyword: _keyword,
      );
      setState(() {
        _materials = result['data'];
        _totalPages = result['totalPages'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteMaterial(String uuid) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận'),
        content: Text('Bạn có chắc chắn muốn xóa tài liệu này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Xóa'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _materialService.deleteMaterial(uuid);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xóa tài liệu thành công')),
          );
          _fetchMaterials();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xóa tài liệu thất bại')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _searchMaterials() {
    setState(() {
      _currentPage = 1;
      _keyword = _searchController.text.trim();
    });
    _fetchMaterials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm tài liệu',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchMaterials,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Material list
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _materials.length,
                      itemBuilder: (context, index) {
                        final material = _materials[index];
                        return Card(
                            child: ListTile(
                          title: Text(material['file_name']),
                          subtitle: Text(material['file_extension']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _deleteMaterial(material['uuid']),
                              ),
                            ],
                          ),
                        ));
                      },
                    ),
            ),
            // Pagination controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 1
                      ? () {
                          setState(() {
                            _currentPage--;
                          });
                          _fetchMaterials();
                        }
                      : null,
                  child: Text('Trước'),
                ),
                Text('Trang $_currentPage / $_totalPages'),
                ElevatedButton(
                  onPressed: _currentPage < _totalPages
                      ? () {
                          setState(() {
                            _currentPage++;
                          });
                          _fetchMaterials();
                        }
                      : null,
                  child: Text('Tiếp theo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
