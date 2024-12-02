import '../../models/project_model.dart';
import '../../models/result_models.dart';
import '../validator_interface.dart';

class ProjectValidator extends IValidator<ProjectRequest>{
  
  @override
  (bool, ErrorMessage?) validateTyped(ProjectRequest data) {
    Map<String, dynamic> messageMap = {};
    if(data.name.isEmpty){
      messageMap["name"] = "Can not be empty";
    }
    return messageMap.isEmpty ? (true, null) : (false, ErrorMessage(result: messageMap.toString(), statusCode: 400));
  }

}