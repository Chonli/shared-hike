import 'package:package_info/package_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/authentification/authentication_bloc/bloc.dart';
import 'package:shared_hike/model/cloud_repository.dart';
import 'package:shared_hike/ui/hike_card.dart';
import 'add_hike_page.dart';
import 'package:shared_hike/model/hike.dart';

class HomePage extends StatefulWidget {
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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Toute'),
    Tab(text: 'Mes Rando'),
    Tab(text: 'Enregistrées'),
    Tab(text: 'Archivées'),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: myTabs.length);
  }

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
/*      appBar: AppBar(
        title: Text(title),
      ),*/
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Image.asset(
                      "assets/images/tab_background.jpeg",
                      fit: BoxFit.cover,
                    )),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.blue,
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    isScrollable: true,
                    tabs: myTabs,
                  ),
                ]),
              ),
            ];
          },
          body: TabBarView(controller: _tabController, children: [
            _listHikes(widget.cloudRepository.getHikes()),
            _listHikes(widget.cloudRepository.getMyHikes(widget.currentUser)),
            _listHikes(widget.cloudRepository.getRegisterHikes(widget.currentUser)),
            _listHikes(widget.cloudRepository.getOldHikes()),
          ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddHikePage(
                        currentUser: widget.currentUser,
                        cloudRepository: widget.cloudRepository,
                      )));
        },
        tooltip: 'Ajouter ',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _listHikes(Stream stream) {
    return StreamBuilder<List<Hike>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => HikeCard(
                          widget.cloudRepository, snapshot.data[index]),
                    );
        }
      },
    );
  }
}
