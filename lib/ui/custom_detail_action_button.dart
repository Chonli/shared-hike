import 'package:flutter/material.dart';
import 'package:shared_hike/db/cloud_repository.dart';
import 'package:shared_hike/db/hike.dart';
import 'package:shared_hike/ui/edit_hike_page.dart';

class CustomDetailActionButton extends StatefulWidget {
  final Hike _hike;
  final CloudRepository _cloudRepository;

  CustomDetailActionButton({Key key, @required CloudRepository cloudRepository, @required Hike hike})
      : assert(hike != null), assert(cloudRepository != null),
        _cloudRepository = cloudRepository,
        _hike = hike,
        super(key: key);

  State<CustomDetailActionButton> createState() =>
      _CustomDetailActionButtonState();
}

class _CustomDetailActionButtonState extends State<CustomDetailActionButton> {
  bool _isMyHike = false;

  get _hike => widget._hike;
  get _cloudRepository => widget._cloudRepository;

  @override
  void initState() {
    super.initState();
    _cloudRepository.getCurrentUserId().then((currentId) {
      setState(() {
        _isMyHike = _hike.owner == currentId;
        print("isMyHike " + _isMyHike.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isMyHike
        ?
    FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditHikePage(
                    hike: _hike,
                    cloudRepository: _cloudRepository,
                  )));
        },
        tooltip: 'Modifier',
        child: Icon(Icons.edit))
        : Container();
  }
}
