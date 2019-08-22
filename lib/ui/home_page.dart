import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/fireauth/authentication_bloc/bloc.dart';
import 'package:shared_hike/db/cloud_repository.dart';
import 'package:shared_hike/ui/hike_card.dart';
import 'add_hike_page.dart';
import 'package:shared_hike/db/hike.dart';

class HomePage extends StatelessWidget {
  final String title;
  final String currentUser;
  final CloudRepository cloudRepository;

  HomePage(
      {Key key,
      @required this.cloudRepository,
      @required this.currentUser,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              //Handling click on the action items
              BlocProvider.of<AuthenticationBloc>(context)
                  .dispatch(LoggedOutEvent());
            },
          )
        ],
      ),
      body: Center(
          child: StreamBuilder<QuerySnapshot>(
        stream: cloudRepository.getHikes(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: HikeCard(cloudRepository,
                            Hike.fromSnapshot(snapshot.data.documents[index])),
                      ));
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddHikePage(
                        currentUser: currentUser,
                        cloudRepository: cloudRepository,
                      )));
        },
        tooltip: 'Ajouter ',
        child: Icon(Icons.add),
      ),
    );
  }
}
