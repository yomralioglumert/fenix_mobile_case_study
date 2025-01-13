import 'package:fenix_mobile_case_study/network/exceptions/base_exception.dart';


class AppException extends BaseException {
  AppException({
    String message = "",
  }) : super(message: message);
}
