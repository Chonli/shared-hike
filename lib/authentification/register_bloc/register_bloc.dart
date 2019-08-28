import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_hike/authentification/register_bloc/bloc.dart';
import 'package:shared_hike/db/cloud_repository.dart';
import 'package:shared_hike/util/validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CloudRepository _cloudRepository;

  RegisterBloc({@required CloudRepository cloudRepository})
      : assert(cloudRepository != null),
        _cloudRepository = cloudRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transform(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged &&
          event is! PasswordChanged &&
          event is! PseudoChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged ||
          event is PasswordChanged ||
          event is PseudoChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is PseudoChanged) {
      yield* _mapPseudoChangedToState(event.pseudo);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password, event.pseudo);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapPseudoChangedToState(String pseudo) async* {
    yield currentState.update(
      isPseudoValid: pseudo.isNotEmpty,
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
    String pseudo,
  ) async* {
    yield RegisterState.loading();
    try {
      await _cloudRepository.signUp(
        email: email,
        password: password,
      );
      var id = await _cloudRepository.getCurrentUserId();
      await _cloudRepository.createUser(id: id, pseudo: pseudo);
      yield RegisterState.success();
    } catch (_) {
      yield RegisterState.failure();
    }
  }
}
