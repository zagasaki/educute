import 'package:educute/Catatan/detailcatatan.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class CatatanScreen extends StatefulWidget {
  const CatatanScreen({Key? key}) : super(key: key);

  @override
  State<CatatanScreen> createState() => _CatatanScreenState();
}

class _CatatanScreenState extends State<CatatanScreen> {
  late TextEditingController _controller;
  late Database _database;
  late List<Map<String, dynamic>> _catatanList = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      'catatan.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS catatan(id INTEGER PRIMARY KEY, judul TEXT, isi TEXT)',
        );
      },
    );
    _refreshCatatanList();
  }

  Future<void> _tambahCatatan(String judul, String isi) async {
    await _database.insert(
      'catatan',
      {'judul': judul, 'isi': isi},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    setState(() {
      _controller.clear();
    });
    _refreshCatatanList();
  }

  Future<void> _refreshCatatanList() async {
    final List<Map<String, dynamic>> catatan = await _database.query('catatan');
    setState(() {
      _catatanList = catatan;
    });
  }

  Future<void> _hapusCatatan(int id) async {
    await _database.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
    _refreshCatatanList();
  }

  void _showDetailCatatan(int index) {
    if (_catatanList[index]['judul'] != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailCatatanScreen(
            judul: _catatanList[index]['judul'],
            isi: _catatanList[index]['isi'],
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Judul catatan tidak valid'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan')),
      body: _catatanList.isEmpty
          ? const Center(child: Text('Catatan masih kosong'))
          : ListView.builder(
              itemCount: _catatanList.length,
              itemBuilder: (BuildContext context, int index) {
                final judul = _catatanList[index]['judul'];
                final id = _catatanList[index]['id'];
                return ListTile(
                  title: Text(judul ?? 'Judul tidak valid'),
                  onTap: () {
                    _showDetailCatatan(index);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text(
                                'Apakah Anda yakin ingin menghapus catatan ini?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Tidak'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _hapusCatatan(
                                      id); // Panggil fungsi hapusCatatan dengan ID catatan yang akan dihapus
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Ya'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController judulController = TextEditingController();
              return AlertDialog(
                title: const Text('Tambah Catatan'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(
                        hintText: 'Judul catatan',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Isi catatan',
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (judulController.text.isNotEmpty) {
                        _tambahCatatan(judulController.text, _controller.text);
                        Navigator.of(context).pop();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Peringatan'),
                              content: const Text(
                                  'Judul catatan tidak boleh kosong.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Tutup'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
