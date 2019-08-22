import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_hike/db/cloud_repository.dart';
import 'package:shared_hike/db/hike.dart';
import './bloc.dart';

class HikeBloc extends Bloc<HikeEvent, HikeState> {
  final CloudRepository _cloudRepository;

  HikeBloc({@required CloudRepository cloudRepository})
      : assert(cloudRepository != null),
        _cloudRepository = cloudRepository;

  @override
  HikeState get initialState => HikeState.empty();

  @override
  Stream<HikeState> transform(
    Stream<HikeEvent> events,
    Stream<HikeState> Function(HikeEvent event) next,
  ) {
    final observableStream = events as Observable<HikeEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! TitleChanged &&
          event is! DescriptionChanged &&
          event is! DateChanged &&
          event is! ElevationChanged &&
          event is! DistanceChanged &&
          event is! UrlImageChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is TitleChanged ||
          event is DescriptionChanged ||
          event is DateChanged ||
          event is ElevationChanged ||
          event is DistanceChanged ||
          event is UrlImageChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super.transform(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<HikeState> mapEventToState(
    HikeEvent event,
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
    } else if (event is UrlImageChanged) {
      yield* _mapUrlImageChangedToState(event.urlImage);
    } else if (event is CreateHike) {
      yield* _mapFormCreateHikeToState(
        event.title,
        event.description,
        event.date,
        event.distance,
        event.elevation,
        event.owner,
        event.urlImage,
      );
    }else if (event is UpdateHike) {
      yield* _mapFormUpdateHikeToState(
        event.hike,
      );
    }
  }

  Stream<HikeState> _mapTitleChangedToState(String title) async* {
    yield currentState.update(
      isTitleValid: title.isNotEmpty,
    );
  }

  Stream<HikeState> _mapDescriptionChangedToState(
      String description) async* {
    yield currentState.update(
      isTitleValid: description.isNotEmpty,
    );
  }

  Stream<HikeState> _mapDateChangedToState(DateTime date) async* {
    yield currentState.update(
      isDateValid: date.isAfter(DateTime.now()),
    );
  }

  Stream<HikeState> _mapElevationChangedToState(int elevation) async* {
    yield currentState.update(
      isElevationValid: elevation > 0,
    );
  }

  Stream<HikeState> _mapDistanceChangedToState(int distance) async* {
    yield currentState.update(
      isDistanceValid: distance > 0,
    );
  }

  Stream<HikeState> _mapUrlImageChangedToState(String urlImage) async* {
    yield currentState.update(
      isImageValid: urlImage.isNotEmpty,
    );
  }

  Stream<HikeState> _mapFormCreateHikeToState(
      String title,
      String description,
      DateTime date,
      int distance,
      int elevation,
      String owner,
      String urlImage,) async* {
    yield HikeState.loading();
    try {
      await _cloudRepository.createHike(
        title,
        description,
        date,
        distance,
        elevation,
        owner,
        urlImage,
      );
      yield HikeState.success();
    } catch (_) {
      yield HikeState.failure();
    }
  }

  Stream<HikeState> _mapFormUpdateHikeToState(
      Hike hike,) async* {
    yield HikeState.loading();
    try {
      await _cloudRepository.updateHike(hike);
      yield HikeState.success();
    } catch (_) {
      yield HikeState.failure();
    }
  }
}
