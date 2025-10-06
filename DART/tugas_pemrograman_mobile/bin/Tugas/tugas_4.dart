import 'dart:io';
import 'dart:math';

void main() async {
  Map<int, Map<String, dynamic>> makanan = {
    1: {'nama': 'Nasi Goreng', 'harga': 15000},
    2: {'nama': 'Mie Ayam', 'harga': 12000},
    3: {'nama': 'Ayam Bakar', 'harga': 20000},
  };

  Map<int, Map<String, dynamic>> minuman = {
    1: {'nama': 'Es Teh', 'harga': 5000},
    2: {'nama': 'Jus Jeruk', 'harga': 8000},
    3: {'nama': 'Air Mineral', 'harga': 4000},
  };

  print("\n=== Welcome To Restorant ===");
  Map<String, Map<String, dynamic>> pesananMakanan = {};
  while (true) {
    print("\n----------  Menu Makanan  ----------\n");
    makanan.forEach((key, value) {
      print("$key. ${value['nama']} = Rp${value['harga']}");
    });
    print("0. Selesai memilih makanan");
    stdout.write(
      "Pilih nomor makanan dan jumlah (misal: 1 2 untuk Nasi Goreng 2 porsi): ",
    );
    String? input = stdin.readLineSync();
    if (input == null || input.trim() == "0") break;
    var parts = input.trim().split(' ');
    if (parts.length < 1 || parts.length > 2) {
      print("Input tidak valid.");
      continue;
    }
    int? pilihan = int.tryParse(parts[0]);
    int jumlah = parts.length == 2 ? int.tryParse(parts[1]) ?? 1 : 1;
    if (pilihan == null || !makanan.containsKey(pilihan) || jumlah < 1) {
      print("Pilihan tidak valid.");
      continue;
    }
    String nama = makanan[pilihan]!['nama'];
    if (pesananMakanan.containsKey(nama)) {
      pesananMakanan[nama]!['jumlah'] += jumlah;
    } else {
      pesananMakanan[nama] = {
        'harga': makanan[pilihan]!['harga'],
        'jumlah': jumlah,
      };
    }
    print("$nama $jumlah porsi ditambahkan.");
  }

  // Tanya apakah ingin minum
  bool pesanMinum = false;
  while (true) {
    stdout.write("Apakah Anda ingin memesan minuman? (ya/tidak): ");
    String? jawab = stdin.readLineSync();
    if (jawab != null &&
        (jawab.toLowerCase() == 'ya' || jawab.toLowerCase() == 'y')) {
      pesanMinum = true;
      break;
    } else if (jawab != null &&
        (jawab.toLowerCase() == 'tidak' || jawab.toLowerCase() == 't')) {
      break;
    } else {
      print("Jawaban tidak valid.");
    }
  }

  // Pilih minuman (bisa lebih dari satu dan bisa input jumlah)
  Map<String, Map<String, dynamic>> pesananMinuman = {};
  if (pesanMinum) {
    while (true) {
      print("\n------------  Menu Minuman ------------\n");
      minuman.forEach((key, value) {
        print("$key. ${value['nama']} - Rp${value['harga']}");
      });
      print("0. Selesai memilih minuman");
      stdout.write(
        "Pilih nomor minuman dan jumlah (misal: 1 2 untuk Es Teh 2 gelas): ",
      );
      String? input = stdin.readLineSync();
      if (input == null || input.trim() == "0") break;
      var parts = input.trim().split(' ');
      if (parts.length < 1 || parts.length > 2) {
        print("Input tidak valid.");
        continue;
      }
      int? pilihan = int.tryParse(parts[0]);
      int jumlah = parts.length == 2 ? int.tryParse(parts[1]) ?? 1 : 1;
      if (pilihan == null || !minuman.containsKey(pilihan) || jumlah < 1) {
        print("Pilihan tidak valid.");
        continue;
      }
      String nama = minuman[pilihan]!['nama'];
      if (pesananMinuman.containsKey(nama)) {
        pesananMinuman[nama]!['jumlah'] += jumlah;
      } else {
        pesananMinuman[nama] = {
          'harga': minuman[pilihan]!['harga'],
          'jumlah': jumlah,
        };
      }
      print("$nama $jumlah gelas ditambahkan.");
    }
  }

  // Cek jika tidak ada pesanan sama sekali
  if (pesananMakanan.isEmpty && pesananMinuman.isEmpty) {
    print("\nAnda belum memesan makanan atau minuman apapun.");
    print("Terima kasih sudah berkunjung. Sampai jumpa!");
    return;
  }

  // Konfirmasi pesanan
  while (true) {
    print("\n--- Rincian Pesanan ---");
    int total = 0;
    if (pesananMakanan.isNotEmpty) {
      print("Makanan:");
      pesananMakanan.forEach((nama, item) {
        int subtotal = (item['harga'] * item['jumlah']).toInt();
        print("- $nama (${item['jumlah']} porsi) : Rp$subtotal");
        total += subtotal;
      });
    }
    if (pesananMinuman.isNotEmpty) {
      print("Minuman:");
      pesananMinuman.forEach((nama, item) {
        int subtotal = (item['harga'] * item['jumlah']).toInt();
        print("- $nama (${item['jumlah']} gelas) : Rp$subtotal");
        total += subtotal;
      });
    }
    print("Total yang harus dibayar: Rp$total");
    stdout.write("Apakah pesanan Anda sudah benar? (ya/tidak): ");
    String? konfirmasi = stdin.readLineSync();
    if (konfirmasi != null &&
        (konfirmasi.toLowerCase() == 'ya' || konfirmasi.toLowerCase() == 'y')) {
      break;
    } else if (konfirmasi != null &&
        (konfirmasi.toLowerCase() == 'tidak' ||
            konfirmasi.toLowerCase() == 't')) {
      print("Silakan ulangi pemesanan dari awal.");
      main();
      return;
    } else {
      print("Jawaban tidak valid.");
    }
  }

  // Pilih makan di tempat atau bungkus
  String tipePesanan = '';
  while (true) {
    stdout.write(
      "Apakah Anda ingin makan di sini atau bungkus? (makan/bungkus): ",
    );
    String? tipe = stdin.readLineSync();
    if (tipe != null && tipe.toLowerCase() == 'makan') {
      tipePesanan = 'makan';
      break;
    } else if (tipe != null && tipe.toLowerCase() == 'bungkus') {
      tipePesanan = 'bungkus';
      break;
    } else {
      print("Pilihan tidak valid.");
    }
  }

  // Proses pesanan
  if (tipePesanan == 'makan') {
    int nomorMeja = Random().nextInt(20) + 1;
    print("Silakan duduk di meja nomor $nomorMeja.");
    print("Tunggu sebentar, pesanan Anda sedang disiapkan...");
    await Future.delayed(Duration(seconds: 3));
  } else {
    int totalOrder = 0;
    pesananMakanan.forEach((_, item) => totalOrder += (item['jumlah'] as int));
    pesananMinuman.forEach((_, item) => totalOrder += (item['jumlah'] as int));
    int waktuTunggu = totalOrder * 60; // 1 menit per item (dalam detik)
    print("Pesanan Anda sedang disiapkan, silakan tunggu sebentar...");
    print("Estimasi waktu tunggu: ${totalOrder} menit.");
    await Future.delayed(
      Duration(seconds: min(waktuTunggu, 5).toInt()),
    ); // Untuk demo, delay max 5 detik
  }

  // Hitung total harga
  int total = 0;
  pesananMakanan.forEach(
    (_, item) => total += ((item['harga'] as int) * (item['jumlah'] as int)),
  );
  pesananMinuman.forEach(
    (_, item) => total += ((item['harga'] as int) * (item['jumlah'] as int)),
  );

  // Proses pembayaran
  bool sudahBayar = false;
  while (!sudahBayar) {
    stdout.write("Masukkan jumlah uang pembayaran: Rp");
    String? bayarInput = stdin.readLineSync();
    int? bayar = int.tryParse(bayarInput ?? '');
    if (bayar == null || bayar < total) {
      print("Uang tidak cukup atau input salah. Silakan bayar sesuai total.");
    } else {
      int kembalian = bayar - total;
      print("Pembayaran berhasil. Kembalian Anda: Rp$kembalian");
      sudahBayar = true;
    }
  }

  print("Terima kasih sudah berkunjung. Sampai jumpa!");
}
