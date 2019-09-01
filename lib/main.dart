import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/authentification/authentication_bloc/bloc.dart';
import 'package:shared_hike/model/cloud_repository.dart';
import 'package:shared_hike/ui/home_page.dart';
import 'package:shared_hike/authentification/login_page.dart';

import 'authentification/login_bloc/bloc.dart';
import 'authentification/register_bloc/bloc.dart';
import 'firecloud/hike_bloc/bloc.dart';
import 'search_image/bloc.dart';

void main() {
  BlocSupervisor.delegate = _MyBlocDelegate();
  final CloudRepository cloudRepository = CloudRepository();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthenticationBloc>(
        builder: (context) =>
            AuthenticationBloc(cloudRepository: cloudRepository)
              ..dispatch(AppStartedEvent())),
    BlocProvider<LoginBloc>(
        builder: (context) => LoginBloc(cloudRepository: cloudRepository)),
    BlocProvider<RegisterBloc>(
        builder: (context) => RegisterBloc(cloudRepository: cloudRepository)),
    BlocProvider<SearchImageBloc>(builder: (context) => SearchImageBloc()),
    BlocProvider<HikeBloc>(
        builder: (context) => HikeBloc(cloudRepository: cloudRepository)),
  ], child: MyApp(cloudRepository: cloudRepository)));
}

class MyApp extends StatelessWidget {
  final String _title = 'Shared Hike';
  final CloudRepository _cloudRepository;

  MyApp({Key key, @required CloudRepository cloudRepository})
      : assert(cloudRepository != null),
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
              ? HomePage(
                  cloudRepository: _cloudRepository,
                  currentUser: state.displayName,
                  title: _title)
              : LoginPage(cloudRepository: _cloudRepository);
        },
      ),
    );
  }
}

class _MyBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
