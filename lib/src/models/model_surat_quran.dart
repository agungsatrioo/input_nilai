// To parse this JSON data, do
//
//     final suratQuran = suratQuranFromJson(jsonString);

import 'dart:convert';

class SuratQuran {
  final String number;
  final String name;
  final String nameLatin;
  final String numberOfAyah;
  final Map<String, String> text;
  final Translations translations;
  final Tafsir tafsir;

  SuratQuran({
    this.number,
    this.name,
    this.nameLatin,
    this.numberOfAyah,
    this.text,
    this.translations,
    this.tafsir,
  });

  factory SuratQuran.fromRawJson(String str) =>
      SuratQuran.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SuratQuran.fromJson(Map<String, dynamic> json) => SuratQuran(
        number: json["number"] == null ? null : json["number"],
        name: json["name"] == null ? null : json["name"],
        nameLatin: json["name_latin"] == null ? null : json["name_latin"],
        numberOfAyah:
            json["number_of_ayah"] == null ? null : json["number_of_ayah"],
        text: json["text"] == null
            ? null
            : Map.from(json["text"])
                .map((k, v) => MapEntry<String, String>(k, v)),
        translations: json["translations"] == null
            ? null
            : Translations.fromJson(json["translations"]),
        tafsir: json["tafsir"] == null ? null : Tafsir.fromJson(json["tafsir"]),
      );

  Map<String, dynamic> toJson() => {
        "number": number == null ? null : number,
        "name": name == null ? null : name,
        "name_latin": nameLatin == null ? null : nameLatin,
        "number_of_ayah": numberOfAyah == null ? null : numberOfAyah,
        "text": text == null
            ? null
            : Map.from(text).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "translations": translations == null ? null : translations.toJson(),
        "tafsir": tafsir == null ? null : tafsir.toJson(),
      };
}

class Tafsir {
  final TafsirId id;

  Tafsir({
    this.id,
  });

  factory Tafsir.fromRawJson(String str) => Tafsir.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Tafsir.fromJson(Map<String, dynamic> json) => Tafsir(
        id: json["id"] == null ? null : TafsirId.fromJson(json["id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id.toJson(),
      };
}

class TafsirId {
  final Kemenag kemenag;

  TafsirId({
    this.kemenag,
  });

  factory TafsirId.fromRawJson(String str) =>
      TafsirId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TafsirId.fromJson(Map<String, dynamic> json) => TafsirId(
        kemenag:
            json["kemenag"] == null ? null : Kemenag.fromJson(json["kemenag"]),
      );

  Map<String, dynamic> toJson() => {
        "kemenag": kemenag == null ? null : kemenag.toJson(),
      };
}

class Kemenag {
  final String name;
  final String source;
  final Map<String, String> text;

  Kemenag({
    this.name,
    this.source,
    this.text,
  });

  factory Kemenag.fromRawJson(String str) => Kemenag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Kemenag.fromJson(Map<String, dynamic> json) => Kemenag(
        name: json["name"] == null ? null : json["name"],
        source: json["source"] == null ? null : json["source"],
        text: json["text"] == null
            ? null
            : Map.from(json["text"])
                .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "source": source == null ? null : source,
        "text": text == null
            ? null
            : Map.from(text).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Translations {
  final TranslationsId id;

  Translations({
    this.id,
  });

  factory Translations.fromRawJson(String str) =>
      Translations.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Translations.fromJson(Map<String, dynamic> json) => Translations(
        id: json["id"] == null ? null : TranslationsId.fromJson(json["id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id.toJson(),
      };
}

class TranslationsId {
  final String name;
  final Map<String, String> text;

  TranslationsId({
    this.name,
    this.text,
  });

  factory TranslationsId.fromRawJson(String str) =>
      TranslationsId.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TranslationsId.fromJson(Map<String, dynamic> json) => TranslationsId(
        name: json["name"] == null ? null : json["name"],
        text: json["text"] == null
            ? null
            : Map.from(json["text"])
                .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "text": text == null
            ? null
            : Map.from(text).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class IndexQuran {
  final String arti;
  final String asma;
  final String audio;
  final int ayat;
  final String keterangan;
  final String nama;
  final String nomor;
  final String rukuk;
  final String type;
  final String urut;

  IndexQuran({
    this.arti,
    this.asma,
    this.audio,
    this.ayat,
    this.keterangan,
    this.nama,
    this.nomor,
    this.rukuk,
    this.type,
    this.urut,
  });

  factory IndexQuran.fromRawJson(String str) =>
      IndexQuran.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndexQuran.fromJson(Map<String, dynamic> json) => IndexQuran(
        arti: json["arti"] == null ? null : json["arti"],
        asma: json["asma"] == null ? null : json["asma"],
        audio: json["audio"] == null ? null : json["audio"],
        ayat: json["ayat"] == null ? null : json["ayat"],
        keterangan: json["keterangan"] == null ? null : json["keterangan"],
        nama: json["nama"] == null ? null : json["nama"],
        nomor: json["nomor"] == null ? null : json["nomor"],
        rukuk: json["rukuk"] == null ? null : json["rukuk"],
        type: json["type"] == null ? null : json["type"],
        urut: json["urut"] == null ? null : json["urut"],
      );

  Map<String, dynamic> toJson() => {
        "arti": arti == null ? null : arti,
        "asma": asma == null ? null : asma,
        "audio": audio == null ? null : audio,
        "ayat": ayat == null ? null : ayat,
        "keterangan": keterangan == null ? null : keterangan,
        "nama": nama == null ? null : nama,
        "nomor": nomor == null ? null : nomor,
        "rukuk": rukuk == null ? null : rukuk,
        "type": type == null ? null : type,
        "urut": urut == null ? null : urut,
      };
}
