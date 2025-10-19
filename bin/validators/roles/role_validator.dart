import '../../models/result_models.dart';
import '../../models/role_model.dart';
import '../validator_interface.dart';

class RoleValidator extends IValidator<RoleRequest> {
  @override
  (bool, ErrorMessage?) validateTyped(RoleRequest data) {
    Map<String, dynamic> messageMap = {};
    if(data.name.isEmpty){
      messageMap["name"] = "Can not be empty";
    }
    return messageMap.isEmpty ? (true, null) : throw FormatException(messageMap.toString());
  }
} 