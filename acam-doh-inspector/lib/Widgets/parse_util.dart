import 'package:aca_mobile_app/description/unified_field_description.dart';

class ParseUtil {
  static List<UnifiedFieldDescription> unifiedFields(dynamic unifiedFields) {
    return List<UnifiedFieldDescription>.from(unifiedFields.map((x) => UnifiedFieldDescription.fromMap(x)));
  }
}
