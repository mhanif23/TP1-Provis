import 'dart:async';
import 'dart:io';

class Kategori {
  String nama;
  Kategori(this.nama);
}

class Kursus {
  String judul, deskripsi, kreator;
  Kategori kategori;
  List<Pelajaran> pelajaran;
  Kuis kuis;

  Kursus(this.judul, this.deskripsi, this.kreator, this.kategori, this.pelajaran, this.kuis);
}

class Pelajaran {
  String judul, konten;

  Pelajaran(this.judul, this.konten);
}

class Kuis {
  String judul;
  List<Pertanyaan> pertanyaan;

  Kuis(this.judul, this.pertanyaan);

  int jalankanKuis() {
    print('\nKuis: $judul');
    int skor = 0;
    for (var p in pertanyaan) {
      print('\nPertanyaan: ${p.pertanyaan}');
      for (var i = 0; i < p.opsi.length; i++) {
        print('${i + 1}. ${p.opsi[i]}');
      }
      print('Masukkan nomor jawaban Anda:');
      String? jawabanUser;
      try {
        jawabanUser = stdin.readLineSync();
        if (jawabanUser == null || int.parse(jawabanUser) > p.opsi.length) {
          print('Jawaban tidak valid, silakan masukkan nomor yang sesuai dengan opsi.');
          continue; // Meminta pengguna untuk menjawab pertanyaan lagi jika input tidak valid
        }
        if (p.opsi[int.parse(jawabanUser) - 1] == p.jawabanBenar) {
          skor++;
        }
      } catch (e) {
        print('Error: ${e.toString()}. Pastikan Anda memasukkan nomor yang valid.');
        continue; // Meminta pengguna untuk menjawab pertanyaan lagi jika terjadi kesalahan parsing
      }
    }
    print('Skor Anda: $skor dari ${pertanyaan.length}');
    return skor;
  }
}

class Pertanyaan {
  String pertanyaan;
  List<String> opsi;
  String jawabanBenar;

  Pertanyaan(this.pertanyaan, this.opsi, this.jawabanBenar);
}

class Pengguna {
  String _nama, _email;
  List<Kursus> kursusDiambil = [];

  Pengguna(this._nama, this._email);

  void ambilKursus(Kursus kursus) {
    kursusDiambil.add(kursus);
    print('${_nama} telah mendaftar di kursus: ${kursus.judul}');
  }

  void tampilkanProgress() {
    print('\nKursus yang diambil oleh $_nama:');
    kursusDiambil.forEach((k) {
      print(k.judul);
    });
  }
}

class Sertifikat {
  String _namaPengguna, _kursus;

  Sertifikat(this._namaPengguna, this._kursus);

  void cetakSertifikat(int skor) {
    print('\nSertifikat berhasil diterbitkan untuk $_namaPengguna atas penyelesaian kursus $_kursus dengan skor $skor');
  }
}

Future<Kursus> getKursusAsync(String judul, Kategori kategori) async {
  await Future.delayed(Duration(seconds: 1)); // Simulasi delay

  // Contoh data dummy yang lebih spesifik
  var kursusData = {
    "Dart untuk Pemula": Kursus(
      "Dart untuk Pemula",
      "Belajar Dart dari dasar hingga mahir.",
      "Andi",
      kategori,
      [Pelajaran("Pengenalan Dart", "Mengenal bahasa pemrograman Dart dan cara kerjanya.")],
      Kuis(
        "Kuis Dart Dasar",
        [
          Pertanyaan(
              "Apa kegunaan Dart?",
              ["Membuat website", "Pengembangan aplikasi mobile", "Game development", "Semua benar"],
              "Semua benar"),
          Pertanyaan(
              "Manakah yang merupakan IDE yang bisa digunakan untuk Dart?",
              ["Visual Studio Code", "IntelliJ IDEA", "Notepad", "Visual Studio Code dan IntelliJ IDEA"],
              "Visual Studio Code dan IntelliJ IDEA"),
        ],
      ),
    ),
    "Desain Grafis untuk Pemula": Kursus(
      "Desain Grafis untuk Pemula",
      "Belajar dasar-dasar desain grafis.",
      "Budi",
      kategori,
      [Pelajaran("Pengenalan Desain Grafis", "Apa itu desain grafis dan bagaimana sejarahnya.")],
      Kuis(
        "Kuis Desain Dasar",
        [
          Pertanyaan(
              "Software apa yang banyak digunakan untuk desain grafis?",
              ["Adobe Photoshop", "Microsoft Word", "Notepad", "Adobe Photoshop dan Illustrator"],
              "Adobe Photoshop dan Illustrator"),
          Pertanyaan(
              "Elemen dasar desain grafis meliputi?",
              ["Garis", "Bentuk", "Warna", "Semua benar"],
              "Semua benar"),
        ],
      ),
    ),
  };

  return kursusData[judul]!;
}

void main() async {
  // Membuat kategori
  var kategoriPemrograman = Kategori("Pemrograman");
  var kategoriDesain = Kategori("Desain");

  // Membuat pengguna
  var alice = Pengguna("Alice", "alice@example.com");
  var bob = Pengguna("Bob", "bob@example.com");

  // Mengambil kursus secara asinkron
  var kursusDart = await getKursusAsync("Dart untuk Pemula", kategoriPemrograman);
  var kursusDesain = await getKursusAsync("Desain Grafis untuk Pemula", kategoriDesain);

  // Pengguna mengambil kursus
  alice.ambilKursus(kursusDart);
  bob.ambilKursus(kursusDesain);

  // Tampilkan progress pengguna
  alice.tampilkanProgress();
  bob.tampilkanProgress();

  // Jalankan kuis
  print('\n--- Kuis untuk Alice ---');
  var skorAlice = kursusDart.kuis.jalankanKuis();
  var sertifikatAlice = Sertifikat(alice._nama, kursusDart.judul);
  sertifikatAlice.cetakSertifikat(skorAlice);

  print('\n--- Kuis untuk Bob ---');
  var skorBob = kursusDesain.kuis.jalankanKuis();
  var sertifikatBob = Sertifikat(bob._nama, kursusDesain.judul);
  sertifikatBob.cetakSertifikat(skorBob);
}

