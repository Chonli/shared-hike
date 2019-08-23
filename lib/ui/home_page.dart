import 'package:package_info/package_info.dart';
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

  void manageDisconnect(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deconnexion'),
          content: const Text('Voulez vous vous déconnecter ?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('Deconnecter'),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .dispatch(LoggedOutEvent());
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void manageAbout(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    showAboutDialog(
        context: context,
        applicationName: "Rando Partagé",
        applicationVersion: "Version: " + packageInfo.version,
        applicationIcon: Icon(Icons.landscape));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                height: 100,
                child: DrawerHeader(
                  child: Text(
                    "Menu",
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                )),
            ListTile(
              title: Text('Deconnection'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                manageDisconnect(context);
              },
            ),
            ListTile(
              title: Text('A propos...'),
              onTap: () {
                manageAbout(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
          child: StreamBuilder<List<Hike>>(
        stream: cloudRepository.getHikes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: HikeCard(cloudRepository, snapshot.data[index]),
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
