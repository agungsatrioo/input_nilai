/*
    2019 Agung Satrio Budi Prakoso
    ------------------------------

    This is PODO file for "akademik" classes

    @agungsatrioo  field bebas strukturnya gini ,,

    #mahasiswa minimal Ada Nim mama, #dosen Nik, mama, email, password. #nilai minimal nilai, mutu.
    #proposal,#kompre,#munaqosah itu ambil idnya aja jadi di table #sidang Ada id , relasi id, status, date

    [03:33, 1/18/2020] IF Pak Acep Ahman: Sementara buat test ya, kalo nanti praknya udah Ada api nya ngikut ke aplks webnya
    [03:34, 1/18/2020] IF Pak Acep Ahman: Sementara itu dulu nanti dlu Ada yg salah di revisi

 */

class Mahasiswa {
  var _nama, _nim;

  Mahasiswa(this._nama, this._nim);

  get nim => _nim;

  get nama => _nama;

  factory Mahasiswa.fromMap(dynamic obj) =>
      new Mahasiswa(obj['user_name'], obj['user_identity']);
}

class MahasiswaProfil extends Mahasiswa {
  var _jurusan;

  MahasiswaProfil(nama, nim, jurusan) : super(nama, nim) {
    this._jurusan = jurusan;
  }

  get jurusan => _jurusan;

  factory MahasiswaProfil.fromMap(dynamic obj) => new MahasiswaProfil(
      obj['user_name'], obj['user_identity'], obj['nama_jur']);
}

class Dosen {
  var _nama, _id, _nip, _nik, _nidn;

  Dosen(this._nama, this._id, this._nip, this._nik, this._nidn);

  get nama => _nama;

  factory Dosen.fromMap(dynamic obj) => new Dosen(obj['user_name'],
      obj['user_identity'], obj['nip'], obj['nik'], obj['nidn']);

  get id => _id;

  get nip => _nip;

  get nik => _nik;

  get nidn => _nidn;
}
