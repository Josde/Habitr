/// {@category Miscelaneo}
/// Métodos para tratar con códigos QR.
library;

import 'package:uuid/uuid.dart';

/// Método que simplemente le añade un prefijo para marcar que el QR proviene de esta aplicación.
String generateQRData(String data) {
  return 'HABITR:' + data;
}

/// Método que borra el prefijo añadido por generateQRData
String parseQRData(String data) {
  return data.substring(7);
}

/// Método que comprueba que el QR ha sido generado por esta aplicación y que es válido.
///
/// En el contexto de la aplicación, los QR sólo se usan para representar UUIDs de usuarios, así que las comprobaciones hechas es que tienen el prefijo de la app y que son un UUID válido.
bool isValidQR(String? data) {
  if (data == null) return false;
  if (data.substring(0, 7) == "HABITR:") {
    Uuid.isValidUUID(fromString: parseQRData(data));
    return true;
  }
  return false;
}
