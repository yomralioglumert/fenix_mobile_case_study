import 'package:fenix_mobile_case_study/network/exceptions/base_exception.dart';

class JsonFormatException extends BaseException {
  JsonFormatException(String message) : super(message: message);
}
