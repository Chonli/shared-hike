import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_hike/db/cloud_repository.dart';
import './bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final CloudRepository _cloudRepository;

  AuthenticationBloc({@required CloudRepository cloudRepository})
      : assert(cloudRepository != null),
        _cloudRepository = cloudRepository;

  @override
  AuthenticationState get initialState => UninitializedState();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStartedEvent) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedInEvent) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOutEvent) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _cloudRepository.isSignedIn();
      if (isSignedIn) {
        yield AuthenticatedState(await _cloudRepository.getCurrentUserId());
      } else {
        yield UnauthenticatedState();
      }
    } catch (_) {
      yield UnauthenticatedState();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield AuthenticatedState(await _cloudRepository.getCurrentUserId());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield UnauthenticatedState();
    _cloudRepository.signOut();
  }
}
