import '../models/result_models.dart';

abstract class IValidator<T> {
  (bool, ErrorMessage?) validate(dynamic data) {
    if (data is! T) {
      return (
        false,
        throw FormatException('Bad request: Invalid data type')
      );
    }
    return validateTyped(data);
  }

  (bool, ErrorMessage?) validateTyped(T data);
}