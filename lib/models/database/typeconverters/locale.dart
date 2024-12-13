part of '../database.dart';

class LocaleConverter extends TypeConverter<Locale, String> {
  const LocaleConverter();

  @override
  Locale fromSql(String fromDb) {
    final rawMap = jsonDecode(fromDb) as Map<String, dynamic>;
    return Locale.fromSubtags(
      languageCode: rawMap["languageCode"],
      countryCode: rawMap["countryCode"],
      scriptCode: rawMap["scriptCode"],
    );
  }

  @override
  String toSql(Locale value) {
    return jsonEncode({
      "languageCode": value.languageCode,
      "countryCode": value.countryCode,
      "scriptCode": value.scriptCode,
    });
  }
}
