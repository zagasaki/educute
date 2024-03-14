import 'package:flutter/material.dart';

class DetailTugasScreen extends StatelessWidget {
  final String judul;
  final String deskripsi;
  final DateTime deadline;

  const DetailTugasScreen({
    Key? key,
    required this.judul,
    required this.deskripsi,
    required this.deadline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime deadlineDateTime = deadline;
    String formattedDeadline =
        '${deadlineDateTime.day}/${deadlineDateTime.month}/${deadlineDateTime.year} pukul ${deadlineDateTime.hour}:${deadlineDateTime.minute}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              judul,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Deskripsi: $deskripsi',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Deadline: $formattedDeadline',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
