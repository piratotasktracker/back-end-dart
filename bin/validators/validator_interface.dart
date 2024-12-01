import '../models/result_models.dart';

abstract class IValidator<T> {
  (bool, ErrorMessage?) validate(dynamic data) {
    if (data is! T) {
      return (
        false,
        ErrorMessage(result: "Bad request: Invalid data type", statusCode: 400)
      );
    }
    return validateTyped(data);
  }

  (bool, ErrorMessage?) validateTyped(T data);
}