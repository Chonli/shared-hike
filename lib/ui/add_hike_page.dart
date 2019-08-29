import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/firecloud/hike_bloc/bloc.dart';
import 'package:shared_hike/model/cloud_repository.dart';
import 'package:shared_hike/ui/hike_form.dart';

class AddHikePage extends StatelessWidget {
  final CloudRepository _cloudRepository;
  final String _currentUser;

  AddHikePage({Key key, @required CloudRepository cloudRepository, @required String currentUser})
      : assert(cloudRepository != null),
        _cloudRepository = cloudRepository,
        _currentUser = currentUser,
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
          child: HikeForm(currentUser: _currentUser),
        ),
      ),
    );
  }
}
