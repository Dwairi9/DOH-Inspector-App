
import 'package:aca_mobile_app/description/offline_expression_field.dart';

class OfflineExpressionDescription {
  final List<OfflineExpressionField> offlineExpressionFields;
  final int viewId;

  OfflineExpressionDescription({required this.offlineExpressionFields, required this.viewId});

  factory OfflineExpressionDescription.fromMap(Map<String, dynamic> map) {
    return OfflineExpressionDescription(
      offlineExpressionFields: List<OfflineExpressionField>.from(map['fields']?.map((x) => OfflineExpressionField.fromMap(x))),
      viewId: map['viewId']?.toInt(),
    );
  }
}
