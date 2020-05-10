// To parse this JSON data, do
//
//      modelMhsUp = modelMhsUpFromJson(jsonString);

import 'dart:convert';
import 'dart:ui';

import '../utils/util_common.dart';

class ModelMhsSidang {
  String idStatus;
  String nim;
  String namaMhs;
  String sidangDateFmtd;
  DateTime sidangDate;
  String kodeRuang;
  String namaKelompokSidang;
  DosenSidang nilai;
  String keteranganSidang;
  List<DosenSidang> penguji;
  List<DosenSidang> pembimbing;

  String judulProposal;
  String judulMunaqosah;

  ModelMhsSidang(
      {this.idStatus,
      this.nim,
      this.namaMhs,
      this.sidangDateFmtd,
      this.sidangDate,
      this.kodeRuang,
      this.namaKelompokSidang,
      this.nilai,
      this.keteranganSidang,
      this.penguji,
      this.pembimbing,
      this.judulProposal,
      this.judulMunaqosah});

  factory ModelMhsSidang.fromRawJson(String str) =>
      ModelMhsSidang.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelMhsSidang.fromJson(Map<String, dynamic> json) => ModelMhsSidang(
        idStatus: json["id_status"] == null ? null : json["id_status"],
        nim: json["nim"] == null ? null : json["nim"],
        namaMhs: json["nama_mhs"] == null ? null : json["nama_mhs"],
        sidangDateFmtd:
            json["sidang_date_fmtd"] == null ? null : json["sidang_date_fmtd"],
        sidangDate: json["sidang_date"] == null
            ? null
            : DateTime.parse(json["sidang_date"]),
        kodeRuang: json["kode_ruang"] == null ? null : json["kode_ruang"],
        namaKelompokSidang: json["nama_kelompok_sidang"] == null
            ? null
            : json["nama_kelompok_sidang"],
        nilai:
            json["nilai"] == null ? null : DosenSidang.fromJson(json["nilai"]),
        keteranganSidang: json["keterangan_sidang"] == null
            ? null
            : json["keterangan_sidang"],
        penguji: json["penguji"] == null
            ? null
            : List<DosenSidang>.from(
                json["penguji"].map((x) => DosenSidang.fromJson(x))),
        pembimbing: json["pembimbing"] == null
            ? null
            : List<DosenSidang>.from(
                json["pembimbing"].map((x) => DosenSidang.fromJson(x))),
        judulProposal:
            json["judul_proposal"] == null ? null : json["judul_proposal"],
        judulMunaqosah:
            json["judul_munaqosah"] == null ? null : json["judul_munaqosah"],
      );

  Map<String, dynamic> toJson() => {
        "id_status": idStatus == null ? null : idStatus,
        "nim": nim == null ? null : nim,
        "nama_mhs": namaMhs == null ? null : namaMhs,
        "sidang_date_fmtd": sidangDateFmtd == null ? null : sidangDateFmtd,
        "sidang_date": sidangDate == null
            ? null
            : "${sidangDate.year.toString().padLeft(4, '0')}-${sidangDate.month.toString().padLeft(2, '0')}-${sidangDate.day.toString().padLeft(2, '0')}",
        "kode_ruang": kodeRuang == null ? null : kodeRuang,
        "nama_kelompok_sidang":
            namaKelompokSidang == null ? null : namaKelompokSidang,
        "nilai": nilai == null ? null : nilai.toJson(),
        "keterangan_sidang": keteranganSidang == null ? null : keteranganSidang,
        "penguji": penguji == null
            ? null
            : List<dynamic>.from(penguji.map((x) => x.toJson())),
        "pembimbing": pembimbing == null
            ? null
            : List<dynamic>.from(pembimbing.map((x) => x.toJson())),
      };
}

class DosenSidang {
  String idStatus;
  String idDosen;
  String namaDosen;
  String namaStatus;
  dynamic nilai;
  String mutu;
  String color;
  List<Revisi> revisi;

  DosenSidang({
    this.idStatus,
    this.idDosen,
    this.namaDosen,
    this.namaStatus,
    this.nilai,
    this.mutu,
    this.color,
    this.revisi,
  });

  bool get sudahAdaNilai => isNumeric(this.nilai);

  Color get colorObj => hexToColor(this.color);

  factory DosenSidang.fromRawJson(String str) =>
      DosenSidang.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DosenSidang.fromJson(Map<String, dynamic> json) => DosenSidang(
        idStatus: json["id_status"] == null ? null : json["id_status"],
        idDosen: json["id_dosen"] == null ? null : json["id_dosen"],
        namaDosen: json["nama_dosen"] == null ? null : json["nama_dosen"],
        namaStatus: json["nama_status"] == null ? null : json["nama_status"],
        nilai: json["nilai"] == null ? null : json["nilai"],
        mutu: json["mutu"] == null ? null : json["mutu"],
        color: json["color"] == null ? null : json["color"],
        revisi: json["revisi"] == null
            ? null
            : List<Revisi>.from(json["revisi"].map((x) => Revisi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_status": idStatus == null ? null : idStatus,
        "id_dosen": idDosen == null ? null : idDosen,
        "nama_dosen": namaDosen == null ? null : namaDosen,
        "nama_status": namaStatus == null ? null : namaStatus,
        "nilai": nilai == null ? null : nilai,
        "mutu": mutu == null ? null : mutu,
        "color": color == null ? null : color,
        "revisi": revisi == null
            ? null
            : List<dynamic>.from(revisi.map((x) => x.toJson())),
      };
}

class Revisi {
  String idRevisi;
  String nim;
  String idDosen;
  String namaMhs;
  String namaDosen;
  String namaStatus;
  String idStatus;
  String detailRevisi;
  DateTime tglRevisiInput;
  DateTime tglRevisiDeadline;
  bool statusRevisi;

  Revisi({
    this.idRevisi,
    this.nim,
    this.idDosen,
    this.namaMhs,
    this.namaDosen,
    this.namaStatus,
    this.idStatus,
    this.detailRevisi,
    this.tglRevisiInput,
    this.tglRevisiDeadline,
    this.statusRevisi,
  });

  factory Revisi.fromRawJson(String str) => Revisi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Revisi.fromJson(Map<String, dynamic> json) => Revisi(
        idRevisi: json["id_revisi"] == null ? null : json["id_revisi"],
        nim: json["nim"] == null ? null : json["nim"],
        idDosen: json["id_dosen"] == null ? null : json["id_dosen"],
        namaMhs: json["nama_mhs"] == null ? null : json["nama_mhs"],
        namaDosen: json["nama_dosen"] == null ? null : json["nama_dosen"],
        namaStatus: json["nama_status"] == null ? null : json["nama_status"],
        idStatus: json["id_status"] == null ? null : json["id_status"],
        detailRevisi:
            json["detail_revisi"] == null ? null : json["detail_revisi"],
        tglRevisiInput: json["tgl_revisi_input"] == null
            ? null
            : DateTime.parse(json["tgl_revisi_input"]),
        tglRevisiDeadline: json["tgl_revisi_deadline"] == null
            ? null
            : DateTime.parse(json["tgl_revisi_deadline"]),
        statusRevisi:
            json["status_revisi"] == null ? null : json["status_revisi"],
      );

  Map<String, dynamic> toJson() => {
        "id_revisi": idRevisi == null ? null : idRevisi,
        "nim": nim == null ? null : nim,
        "id_dosen": idDosen == null ? null : idDosen,
        "nama_mhs": namaMhs == null ? null : namaMhs,
        "nama_dosen": namaDosen == null ? null : namaDosen,
        "nama_status": namaStatus == null ? null : namaStatus,
        "id_status": idStatus == null ? null : idStatus,
        "detail_revisi": detailRevisi == null ? null : detailRevisi,
        "tgl_revisi_input":
            tglRevisiInput == null ? null : tglRevisiInput.toIso8601String(),
        "tgl_revisi_deadline": tglRevisiDeadline == null
            ? null
            : tglRevisiDeadline.toIso8601String(),
        "status_revisi": statusRevisi == null ? null : statusRevisi,
      };
}
