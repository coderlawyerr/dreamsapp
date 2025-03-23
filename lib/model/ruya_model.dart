import 'package:hive/hive.dart';

part 'ruya_model.g.dart'; //bunu eklemen gerekiyor oluşturması için

@HiveType(typeId: 0)
class RuyaModel {
  @HiveField(0)
  String baslik;

  @HiveField(1)
  String icerik;

  @HiveField(2)
  String kategori;

  @HiveField(3)
  String tarih;

  @HiveField(4)
  String? yorum;

  RuyaModel({required this.baslik, required this.icerik, required this.kategori, required this.tarih, this.yorum});
}
