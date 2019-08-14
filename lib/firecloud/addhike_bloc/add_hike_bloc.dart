import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_hike/db/hike.dart';
import 'package:shared_hike/firecloud/cloud_repository.dart';
import './bloc.dart';

class AddHikeBloc extends Bloc<AddHikeEvent, AddHikeState> {
  final CloudRepository _cloudRepository;

  AddHikeBloc({@required CloudRepository cloudRepository})
      : assert(cloudRepository != null),
        _cloudRepository = cloudRepository;

  @override
  AddHikeState get initialState => AddHikeState.empty();

  @override
  Stream<AddHikeState> transform(
    Stream<AddHikeEvent> events,
    Stream<AddHikeState> Function(AddHikeEvent event) next,
  ) {
    final observableStream = events as Observable<AddHikeEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! TitleChanged &&
          event is! DescriptionChanged &&
          event is! DateChanged &&
          event is! ElevationChanged &&
          event is! DistanceChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is TitleChanged ||
          event is DescriptionChanged ||
          event is DateChanged ||
          event is ElevationChanged ||
          event is DistanceChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<AddHikeState> mapEventToState(
    AddHikeEvent event,
  ) async* {
    if (event is TitleChanged) {
      yield* _mapTitleChangedToState(event.title);
    } else if (event is DescriptionChanged) {
      yield* _mapDescriptionChangedToState(event.description);
    } else if (event is DateChanged) {
      yield* _mapDateChangedToState(event.date);
    } else if (event is DistanceChanged) {
      yield* _mapDistanceChangedToState(event.distance);
    } else if (event is ElevationChanged) {
      yield* _mapElevationChangedToState(event.elevation);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(
        event.title,
        event.description,
        event.date,
        event.distance,
        event.elevation,
        event.owner,
      );
    }
  }

  Stream<AddHikeState> _mapTitleChangedToState(String title) async* {
    yield currentState.update(
      isTitleValid: title.isNotEmpty,
    );
  }

  Stream<AddHikeState> _mapDescriptionChangedToState(
      String description) async* {
    yield currentState.update(
      isTitleValid: description.isNotEmpty,
    );
  }

  Stream<AddHikeState> _mapDateChangedToState(DateTime date) async* {
    yield currentState.update(
      isDateValid: date.isAfter(DateTime.now()),
    );
  }

  Stream<AddHikeState> _mapElevationChangedToState(int elevation) async* {
    yield currentState.update(
      isElevationValid: elevation > 0,
    );
  }

  Stream<AddHikeState> _mapDistanceChangedToState(int distance) async* {
    yield currentState.update(
      isDistanceValid: distance > 0,
    );
  }

  Stream<AddHikeState> _mapFormSubmittedToState(
      String title,
      String description,
      DateTime date,
      int distance,
      int elevation,
      String owner) async* {
    yield AddHikeState.loading();
    try {
      await _cloudRepository.createHike(
        title,
        description,
        date,
        distance,
        elevation,
        owner,
      );
      yield AddHikeState.success();
    } catch (_) {
      yield AddHikeState.failure();
    }
  }
}
