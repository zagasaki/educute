import 'package:educute/Tugas/detailtugas.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TugasScreen extends StatelessWidget {
  const TugasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tugas').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              final judul = document['judul'];
              final deskripsi = document['deskripsi'];
              final deadlineTimestamp = document['deadline'];
              final deadline = DateTime.fromMillisecondsSinceEpoch(
                  deadlineTimestamp.seconds * 1000);
              final remainingTime = deadline.difference(DateTime.now());
              String deadlineString;
              if (remainingTime.isNegative) {
                deadlineString = 'Tugas telah berakhir';
              } else {
                final days = remainingTime.inDays;
                final hours = remainingTime.inHours % 24;
                final minutes = remainingTime.inMinutes % 60;
                deadlineString =
                    'Deadline: $days hari, $hours jam, $minutes menit';
              }

              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                title: Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  deadlineString,
                  style: const TextStyle(fontSize: 16.0),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailTugasScreen(
                                judul: judul,
                                deskripsi: deskripsi,
                                deadline: deadline,
                              )));
                },
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
