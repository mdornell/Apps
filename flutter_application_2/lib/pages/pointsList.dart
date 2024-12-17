import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PointsListPage extends StatefulWidget {
  @override
  _PointsListPageState createState() => _PointsListPageState();
}

class _PointsListPageState extends State<PointsListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchPoints(
      List<QueryDocumentSnapshot> docs) async {
    return Future.wait(docs.map((doc) async {
      final data = doc.data() as Map<String, dynamic>;
      String userName = 'Unknown';

      if (data['user'] != null) {
        final userRef = data['user'] as DocumentReference;
        try {
          final userSnapshot = await userRef.get();
          if (userSnapshot.exists) {
            final userData = userSnapshot.data() as Map<String, dynamic>?;
            userName = userData?['name'] ?? 'Unknown';
          }
        } catch (e) {
          print('Error fetching user: $e');
        }
      }

      return {
        'name': userName,
        'point': data['point'] ?? 0,
        'totalQuestions': data['totalQuestions'] ?? 0,
      };
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pontuação'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10), // Adicionando um SizedBox para espaçamento
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('points')
                  .orderBy('point', descending: true)
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No points found'));
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchPoints(snapshot.data!.docs),
                  builder: (context, pointsSnapshot) {
                    if (pointsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (pointsSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${pointsSnapshot.error}'));
                    }
                    final points = pointsSnapshot.data ?? [];

                    return Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columnSpacing: 20.0,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Point',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Total Questions',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: points.map((point) {
                                    return DataRow(cells: [
                                      DataCell(Text(
                                        point['name'],
                                        style: TextStyle(fontSize: 14),
                                      )),
                                      DataCell(Text(
                                        point['point'].toString(),
                                        style: TextStyle(fontSize: 14),
                                      )),
                                      DataCell(Text(
                                        point['totalQuestions'].toString(),
                                        style: TextStyle(fontSize: 14),
                                      )),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
