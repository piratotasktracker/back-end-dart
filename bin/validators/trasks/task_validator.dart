import '../../models/result_models.dart';
import '../../models/task_model.dart';
import '../validator_interface.dart';

class TaskValidator extends IValidator<TaskRequest>{
  
  @override
  (bool, ErrorMessage?) validateTyped(TaskRequest data) {
    Map<String, dynamic> messageMap = {};
    if(data.name.isEmpty){
      messageMap["name"] = "Can not be empty";
    }
    if(data.createdById.isEmpty){
      messageMap["createdById"] = "Can not be empty";
    }
    return messageMap.isEmpty ? (true, null) : throw FormatException(messageMap.toString());
  }

}