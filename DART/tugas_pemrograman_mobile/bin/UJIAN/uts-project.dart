import 'dart:io';
abstract class Transportasi {
  String id;
  String namaKendaraan;
  double _tarifDasar;
  int kapasitas;

  Transportasi(this.id, this.namaKendaraan, this._tarifDasar, this.kapasitas);
  double get tarifDasar => _tarifDasar;
  double hitungTarif(int jumlahPenumpang);
  void tampilInfo() {
    print("ID: $id");
    print("Nama Kendaraan: $namaKendaraan");
    print("Tarif Dasar: $_tarifDasar");
    print("Kapasitas: $kapasitas");
  }
}
class Taksi extends Transportasi {
  double jarak; 

  Taksi(String id, String nama, double tarifDasar, int kapasitas, this.jarak)
      : super(id, nama, tarifDasar, kapasitas);

  @override
  double hitungTarif(int jumlahPenumpang) {
    return tarifDasar * jarak;
  }

  @override
  void tampilInfo() {
    super.tampilInfo();
    print("Jarak: $jarak km");
  }
}
class Bus extends Transportasi {
  bool adaWifi;

  Bus(String id, String nama, double tarifDasar, int kapasitas, this.adaWifi)
      : super(id, nama, tarifDasar, kapasitas);

  @override
  double hitungTarif(int jumlahPenumpang) {
    return (tarifDasar * jumlahPenumpang) + (adaWifi ? 5000 : 0);
  }
  @override
  void tampilInfo() {
    super.tampilInfo();
    print("Ada Wifi: ${adaWifi ? "Ya" : "Tidak"}");
  }
}
class Pesawat extends Transportasi {
  String kelasPenerbangan; 

  Pesawat(String id, String nama, double tarifDasar, int kapasitas, this.kelasPenerbangan)
      : super(id, nama, tarifDasar, kapasitas);

  @override
  double hitungTarif(int jumlahPenumpang) {
    return tarifDasar * jumlahPenumpang * (kelasPenerbangan == "Bisnis" ? 1.5 : 1.0);
  }

  @override
  void tampilInfo() {
    super.tampilInfo();
    print("Kelas Penerbangan: $kelasPenerbangan");
  }
}
class Pemesanan {
  String idPemesanan;
  String namaPelanggan;
  Transportasi transportasi;
  int jumlahPenumpang;
  double totalTarif;

  Pemesanan(this.idPemesanan, this.namaPelanggan, this.transportasi,
      this.jumlahPenumpang, this.totalTarif);

  void cetakStruk() {
    print("\n===== STRUK PEMESANAN =====");
    print("ID Pemesanan: $idPemesanan");
    print("Nama Pelanggan: $namaPelanggan");
    print("Transportasi: ${transportasi.namaKendaraan}");
    print("Jumlah Penumpang: $jumlahPenumpang");
    print("Total Tarif: Rp$totalTarif");
    print("============================\n");
  }

  Map<String, dynamic> toMap() {
    return {
      "id": idPemesanan,
      "nama": namaPelanggan,
      "transportasi": transportasi.namaKendaraan,
      "penumpang": jumlahPenumpang,
      "total": totalTarif
    };
  }
}
Pemesanan buatPemesanan(Transportasi t, String nama, int jumlahPenumpang) {
  double total = t.hitungTarif(jumlahPenumpang);
  return Pemesanan("P${DateTime.now().millisecondsSinceEpoch}", nama, t, jumlahPenumpang, total);
}

void tampilSemuaPemesanan(List<Pemesanan> daftar) {
  print("\n=== RIWAYAT PEMESANAN ===");
  for (var p in daftar) {
    p.cetakStruk();
  }
}
void main() {
  // Membuat beberapa objek transportasi
  var taksi = Taksi("T1", "Blue Bird", 10000, 4, 15);
  var bus = Bus("B1", "TransJakarta", 8000, 40, true);
  var pesawat = Pesawat("P1", "Garuda Indonesia", 500000, 150, "Ekonomi");

  List<Pemesanan> daftarPemesanan = [];

  print("=== SISTEM PEMESANAN TRANSPORTASI TERPADU ===");
  stdout.write("Masukkan nama pelanggan: ");
  String nama = stdin.readLineSync()!;

  print("\nPilih jenis transportasi:");
  print("1. Taksi\n2. Bus\n3. Pesawat");
  stdout.write("Pilihan Anda: ");
  int pilih = int.parse(stdin.readLineSync()!);

  stdout.write("Jumlah penumpang: ");
  int jumlah = int.parse(stdin.readLineSync()!);

  Transportasi? t;
  if (pilih == 1) {
    t = taksi;
  } else if (pilih == 2) {
    t = bus;
  } else if (pilih == 3) {
    t = pesawat;
  } else {
    print("Pilihan tidak valid!");
    return;
  }

  Pemesanan pesanan = buatPemesanan(t, nama, jumlah);
  daftarPemesanan.add(pesanan);

  tampilSemuaPemesanan(daftarPemesanan);
}