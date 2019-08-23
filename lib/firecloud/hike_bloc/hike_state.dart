import 'package:meta/meta.dart';

@immutable
class HikeState {
  final bool isTitleValid;
  final bool isDescriptionValid;
  final bool isDateValid;
  final bool isElevationValid;
  final bool isDistanceValid;
  final bool isImageValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isDateValid && isDescriptionValid && isTitleValid;

  HikeState({
    @required this.isTitleValid,
    @required this.isDescriptionValid,
    @required this.isDateValid,
    this.isImageValid,
    this.isElevationValid,
    this.isDistanceValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory HikeState.empty() {
    return HikeState(
      isTitleValid: true,
      isDescriptionValid: true,
      isDateValid: true,
      isImageValid: true,
      isElevationValid: true,
      isDistanceValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory HikeState.loading() {
    return HikeState(
      isTitleValid: true,
      isDescriptionValid: true,
      isDateValid: true,
      isImageValid: true,
      isElevationValid: true,
      isDistanceValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory HikeState.failure() {
    return HikeState(
      isTitleValid: true,
      isDescriptionValid: true,
      isDateValid: true,
      isImageValid: true,
      isElevationValid: true,
      isDistanceValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory HikeState.success() {
    return HikeState(
      isTitleValid: true,
      isDescriptionValid: true,
      isDateValid: true,
      isImageValid: true,
      isElevationValid: true,
      isDistanceValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  HikeState update({
    bool isTitleValid,
    bool isDescriptionValid,
    bool isDateValid,
    bool isImageValid,
    bool isElevationValid,
    bool isDistanceValid,
  }) {
    return copyWith(
      isTitleValid: isTitleValid,
      isDescriptionValid: isDescriptionValid,
      isDateValid: isDateValid,
      isImageValid: isImageValid,
      isElevationValid: isElevationValid,
      isDistanceValid: isDistanceValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  HikeState copyWith({
    bool isTitleValid,
    bool isDescriptionValid,
    bool isDateValid,
    bool isImageValid,
    bool isElevationValid,
    bool isDistanceValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return HikeState(
      isTitleValid: isTitleValid ?? this.isTitleValid,
      isDescriptionValid: isDescriptionValid ?? this.isDescriptionValid,
      isDateValid: isDateValid ?? this.isDateValid,
      isImageValid: isImageValid ?? this.isImageValid,
      isElevationValid: isElevationValid ?? this.isElevationValid,
      isDistanceValid: isDistanceValid ?? this.isDistanceValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''HikeState {
      isTitleValid: $isTitleValid,
      isDescriptionValid: $isDescriptionValid,
      isDateValid: $isDateValid,
      isImageValid: $isImageValid,
      isElevationValid: $isElevationValid,
      isDistanceValid: $isDistanceValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
