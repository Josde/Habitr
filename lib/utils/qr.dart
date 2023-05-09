import 'package:uuid/uuid.dart';

String generateQRData(String data) {
  return 'HABITR:' + data;
}

String parseQRData(String data) {
  return data.substring(7);
}

bool isValidQR(String? data) {
  if (data == null) return false;
  if (data.substring(0, 7) == "HABITR:") {
    Uuid.isValidUUID(fromString: parseQRData(data));
    return true;
  }
  return false;
}
