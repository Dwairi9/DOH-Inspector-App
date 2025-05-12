import 'package:aca_mobile_app/data_models/action_object.dart';
import 'package:aca_mobile_app/data_models/attachment.dart';
import 'package:aca_mobile_app/data_models/record_id.dart';

import 'package:aca_mobile_app/network/accela_services.dart';

class RecordRepository {
  static Future<ActionObject<RecordId?>> saveEditRecord(RecordId recordId, {bool useAnonymousToken = false}) async {
    var dataResult = await AccelaServiceManager.emseRequest('saveRecordEdit', {"customId": recordId.customId}, useAnonymousToken: useAnonymousToken);
    ActionObject<RecordId?> result;
    if (dataResult.success) {
      var resultRecordId = RecordId.fromMap(dataResult.content);
      result = ActionObject(success: true, message: "success", content: resultRecordId);
    } else {
      result = ActionObject(success: false, message: dataResult.message, content: null);
    }

    return result;
  }

  static Future<List<Attachment>> getRecordDocuments(RecordId recordId, {bool useAnonymousToken = false}) async {
    List<Attachment> attachments = [];

    var dataResult = await AccelaServiceManager.emseRequest('getRecordDocuments', {"customId": recordId.customId}, useAnonymousToken: useAnonymousToken);
    if (dataResult.success) {
      attachments = List<Attachment>.from(dataResult.content?.map((x) => Attachment.fromMap(x)));
    }

    return attachments;
  }
}
