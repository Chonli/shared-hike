import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/firebase_login/user_repository.dart';
import 'package:shared_hike/firebase_login/authentication_bloc/bloc.dart';
import 'package:shared_hike/firebase_login/my_bloc_delegate.dart';
import 'package:shared_hike/ui/home_page.dart';
import 'package:shared_hike/ui/login_page.dart';

void main() {
  BlocSupervisor.delegate = MyBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(BlocProvider(
      builder: (context) => AuthenticationBloc(userRepository: userRepository)
        ..dispatch(AppStartedEvent()),
      child: MyApp(userRepository: userRepository)
  ));
}

class MyApp extends StatelessWidget {
  final String _title = 'Shared Hike';
  final UserRepository _userRepository;

  MyApp({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
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
                ? HomePage( user: state.displayName, title: _title)
                : LoginPage(userRepository: _userRepository);
          },
        ),
      );
  }
}
