import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detail_hike_page.dart';
import 'add_hike_page.dart';
import '../db/hike.dart';

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('hikes').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                return new ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    return new ListTile(
                      title: new Text(document['title']),
                      subtitle: new Text(document['description']),
                      onTap: () {
                        Navigator.push(
                            context,
                        MaterialPageRoute(builder: (context) =>
                            DetailHikePage(Hike.fromSnapshot(document)))
                        );
                      },
                    );
                  }).toList(),
                );
            }
          },
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  AddHikePage())
          );
        },
        tooltip: 'Ajouter ',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}