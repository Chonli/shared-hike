import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/fireauth/user_repository.dart';
import 'package:shared_hike/fireauth/authentication_bloc/bloc.dart';
import 'package:shared_hike/fireauth/my_bloc_delegate.dart';
import 'package:shared_hike/firecloud/cloud_repository.dart';
import 'package:shared_hike/ui/home_page.dart';
import 'package:shared_hike/ui/login_page.dart';

void main() {
  BlocSupervisor.delegate = MyBlocDelegate();
  final UserRepository userRepository = UserRepository();
  final CloudRepository cloudRepository = CloudRepository();
  runApp(BlocProvider(
      builder: (context) => AuthenticationBloc(userRepository: userRepository)
        ..dispatch(AppStartedEvent()),
      child: MyApp(userRepository: userRepository,cloudRepository: cloudRepository)
  ));
}

class MyApp extends StatelessWidget {
  final String _title = 'Shared Hike';
  final UserRepository _userRepository;
  final CloudRepository _cloudRepository;

  MyApp({Key key, @required UserRepository userRepository, @required CloudRepository cloudRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _cloudRepository = cloudRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('fr', ''),
        ],
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
            return state is AuthenticatedState
                ? HomePage(cloudRepository: _cloudRepository, currentUser: state.displayName, title: _title)
                : LoginPage(userRepository: _userRepository);
          },
        ),
      );
  }
}
