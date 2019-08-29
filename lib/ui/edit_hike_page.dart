import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/model/hike.dart';
import 'package:shared_hike/firecloud/hike_bloc/bloc.dart';
import 'package:shared_hike/model/cloud_repository.dart';
import 'package:shared_hike/ui/hike_form.dart';

class EditHikePage extends StatelessWidget {
  final CloudRepository _cloudRepository;
  final Hike _hike;

  EditHikePage(
      {Key key, @required Hike hike, @required CloudRepository cloudRepository})
      : assert(cloudRepository != null),
        assert(hike != null),
        _cloudRepository = cloudRepository,
        _hike = hike,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajout Rando'),
      ),
      body: Center(
        child: BlocProvider<HikeBloc>(
          builder: (context) => HikeBloc(cloudRepository: _cloudRepository),
          child: HikeForm(hike: _hike,),
        ),
      ),
    );
  }
}
