import '../../models/login_model.dart';
import '../../models/result_models.dart';
import '../../utils/constants.dart';
import '../validator_interface.dart';

class LoginValidator extends IValidator<LoginModel>{
  
  @override
  (bool, ErrorMessage?) validateTyped(LoginModel data) {
    RegExp regex = RegExp(Constants.emailRegEx);
    Map<String, dynamic> messageMap = {};
    if(data.email.isEmpty || !regex.hasMatch(data.email)){
      messageMap["email"] = "Can not be empty or has non E-mail stucture";
    }
    if(data.password.isEmpty){
      messageMap["password"]="Can not be empty";
    }
    return messageMap.isEmpty ? (true, null) : (false, ErrorMessage(result: messageMap.toString(), statusCode: 400));
  }

}