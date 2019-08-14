import 'package:meta/meta.dart';

@immutable
class AddHikeState {
  final bool isTitleValid;
  final bool isDescriptionValid;
  final bool isDateValid;
  final bool isNumberGuestValid;
  final bool isElevationValid;
  final bool isDistanceValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isNumberGuestValid && isDateValid && isDescriptionValid && isTitleValid;

  AddHikeState({
    @required this.isTitleValid,
    @required this.isDescriptionValid,
    @required this.isDateValid,
    @required this.isNumberGuestValid,
    this.isElevationValid,
    this.isDistanceValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
  });

  factory AddHikeState.empty() {
    return AddHikeState(
      isTitleValid: true,
      isDescriptionValid: true,
      isDateValid: true,
      isNumberGuestValid: true,
      isElevationValid: true,
      isDistanceValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory AddHikeState.loading() {
    return AddHikeState(
      isTitleValid: true,
      isDescriptionValid: true,
      isDateValid: true,
      isNumberGuestValid: true,
      isElevationValid: true,
      isDistanceValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory AddHikeState.failure() {
    return AddHikeState(
      isTitleValid: true,
      isDescriptionValid: true,
      isDateValid: true,
      isNumberGuestValid: true,
      isElevationValid: true,
      isDistanceValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory AddHikeState.success() {
    return AddHikeState(
      isTitleValid: true,
      isDescriptionValid: true,
      isDateValid: true,
      isNumberGuestValid: true,
      isElevationValid: true,
      isDistanceValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }

  AddHikeState update({
    bool isTitleValid,
    bool isDescriptionValid,
    bool isDateValid,
    bool isNumberGuestValid,
    bool isElevationValid,
    bool isDistanceValid,
  }) {
    return copyWith(
      isTitleValid: isTitleValid,
      isDescriptionValid: isDescriptionValid,
      isDateValid: isDateValid,
      isNumberGuestValid: isNumberGuestValid,
      isElevationValid: isElevationValid,
      isDistanceValid: isDistanceValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  AddHikeState copyWith({
    bool isTitleValid,
    bool isDescriptionValid,
    bool isDateValid,
    bool isNumberGuestValid,
    bool isElevationValid,
    bool isDistanceValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
  }) {
    return AddHikeState(
      isTitleValid: isTitleValid ?? this.isTitleValid,
      isDescriptionValid: isDescriptionValid ?? this.isDescriptionValid,
      isDateValid: isDateValid ?? this.isDateValid,
      isNumberGuestValid: isNumberGuestValid ?? this.isNumberGuestValid,
      isElevationValid: isElevationValid ?? this.isElevationValid,
      isDistanceValid: isDistanceValid ?? this.isDistanceValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isTitleValid: $isTitleValid,
      isDescriptionValid: $isDescriptionValid,
      isDateValid: $isDateValid,
      isNumberGuestValid: $isNumberGuestValid,
      isElevationValid: $isElevationValid,
      isDistanceValid: $isDistanceValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
    }''';
  }
}
