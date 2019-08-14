import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/firecloud/addhike_bloc/bloc.dart';
import 'package:shared_hike/firecloud/cloud_repository.dart';
import 'package:shared_hike/ui/add_hike_form.dart';

class AddHikePage extends StatelessWidget {
  final CloudRepository _cloudRepository;

  AddHikePage({Key key, @required CloudRepository cloudRepository})
      : assert(cloudRepository != null),
        _cloudRepository = cloudRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajout Rando'),
      ),
      body: Center(
        child: BlocProvider<AddHikeBloc>(
          builder: (context) => AddHikeBloc(cloudRepository: _cloudRepository),
          child: AddHikeForm(),
        ),
      ),
    );
  }
}
