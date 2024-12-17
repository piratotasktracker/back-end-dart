import '../../models/result_models.dart';
import '../../models/sign_up_model.dart';
import '../../utils/constants.dart';
import '../validator_interface.dart';

class SignUpValidator extends IValidator<SignUpModel>{
  
  @override
  (bool, ErrorMessage?) validateTyped(SignUpModel data) {
    RegExp regex = RegExp(Constants.emailRegEx);
    Map<String, dynamic> messageMap = {};
    if(data.email.isEmpty || !regex.hasMatch(data.email)){
      messageMap["email"] = "Can not be empty or has non E-mail stucture";
    }
    if(data.full_name == null || data.full_name!.isEmpty){
      messageMap["full_name"] = "Can not be empty";
    }
    if(data.password.isEmpty){
      messageMap["password"]="Can not be empty";
    }
    if(data.role == null || data.role! > 3){
      messageMap["role"] = "Can not be empty on higher than 3";
    }
    return messageMap.isEmpty ? (true, null) : throw FormatException(messageMap.toString());  
  }

}