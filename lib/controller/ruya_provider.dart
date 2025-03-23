
import 'package:dream/model/ruya_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

class RuyaProvider with ChangeNotifier {
  Box<RuyaModel>? _ruyaBox;
  bool _isInitializing = false;

  // Rüya verisini almak için getter
  List<RuyaModel> get ruyalar {
    // Box initialize edilmediyse boş liste döndür
    if (_ruyaBox == null) return [];

    try {
      return _ruyaBox!.values.toList();
    } catch (e) {
      debugPrint('Rüya listesi alınırken hata: $e');
      return [];
    }
  }

  // Box'ın açık olup olmadığını kontrol eden getter
  bool get isInitialized => _ruyaBox != null && _ruyaBox!.isOpen;

  // Hive kutusunu açmak - basitleştirilmiş
  Future<void> initialize() async {
    // Zaten başlatılmış ise tekrar başlatma
    if (isInitialized) {
      debugPrint('Provider zaten başlatılmış.');
      return;
    }

    // Zaten başlatılma sürecindeyse bekleme yapma
    if (_isInitializing) {
      debugPrint('Provider başlatılıyor, lütfen bekleyin...');
      return;
    }

    _isInitializing = true;
    debugPrint('Provider başlatma işlemi başladı...');

    try {
      // 1. Hive'ı başlat
      await Hive.initFlutter();
      debugPrint('Hive.initFlutter() başarılı.');

      // 2. Adapter'ı kaydet
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(RuyaModelAdapter());
        debugPrint('RuyaModelAdapter başarıyla kaydedildi.');
      } else {
        debugPrint('RuyaModelAdapter zaten kayıtlı.');
      }

      // 3. Box'ı aç
      _ruyaBox = await Hive.openBox<RuyaModel>('ruyalar');
      debugPrint('Rüya kutusu başarıyla açıldı. Rüya sayısı: ${_ruyaBox!.length}');

      notifyListeners();
    } catch (e) {
      debugPrint('!!! Hive başlatma hatası: $e');

      try {
        // Alternatif yöntem dene
        final path = Directory.current.path;
        Hive.init(path);
        debugPrint('Alternatif başlatma yöntemi kullanıldı: $path');

        if (!Hive.isAdapterRegistered(0)) {
          Hive.registerAdapter(RuyaModelAdapter());
        }

        _ruyaBox = await Hive.openBox<RuyaModel>('ruyalar_backup');
        debugPrint('Backup kutusu açıldı: ${_ruyaBox!.name}');
      } catch (backupError) {
        debugPrint('!!! Backup kutusu açılamadı: $backupError');
        rethrow;
      }
    } finally {
      _isInitializing = false;
      debugPrint('Provider başlatma işlemi tamamlandı!');
    }
  }

  // Rüya eklemek - index döndürecek şekilde güncellendi
  Future<int> addRuya(RuyaModel ruya) async {
    // Box kontrolü yap ve gerekirse başlat
    if (!isInitialized) {
      await initialize();
    }

    // Başlatma başarısız oldu mu?
    if (!isInitialized) {
      throw Exception('Veritabanı başlatılamadı');
    }

    try {
      // Rüyayı kaydet
      final index = await _ruyaBox!.add(ruya);
      debugPrint('Rüya kaydedildi: ${ruya.baslik}, index: $index');

      // UI güncelle
      notifyListeners();

      // Index'i döndür
      return index;
    } catch (e) {
      debugPrint('!!! Rüya kaydetme hatası: $e');
      throw Exception('Rüya kaydedilemedi: $e');
    }
  }

  // Rüya silmek
  Future<void> deleteRuya(int index) async {
    if (!isInitialized) {
      await initialize();
    }

    if (!isInitialized || index >= _ruyaBox!.length) {
      debugPrint('Silme işlemi yapılamadı: Kutu başlatılmamış veya geçersiz index: $index');
      return;
    }

    try {
      await _ruyaBox!.deleteAt(index);
      debugPrint('Rüya başarıyla silindi. Index: $index');
      notifyListeners();
    } catch (e) {
      debugPrint('!!! Rüya silme hatası: $e');
      rethrow;
    }
  }

  // Rüya yorumunu güncelleme metodu
  Future<void> updateRuyaYorum(int index, String yorum) async {
    if (!isInitialized) {
      await initialize();
    }

    if (!isInitialized || index < 0 || index >= _ruyaBox!.length) {
      debugPrint('Yorum güncellenemedi: Kutu başlatılmamış veya geçersiz index: $index');
      return;
    }

    try {
      // Rüyayı al
      final ruya = _ruyaBox!.getAt(index);
      if (ruya != null) {
        // Yeni bir RuyaModel oluştur (Hive ile çalışırken önerilen yöntem)
        final updatedRuya = RuyaModel(
          baslik: ruya.baslik,
          icerik: ruya.icerik,
          kategori: ruya.kategori,
          tarih: ruya.tarih,
          yorum: yorum, // Yeni yorum
        );

        // Güncellenen rüyayı kaydet
        await _ruyaBox!.putAt(index, updatedRuya);
        debugPrint('Rüya yorumu başarıyla güncellendi. Index: $index');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('!!! Rüya yorumu güncelleme hatası: $e');
      rethrow;
    }
  }

  // Box'ı kapatmak için metot
  Future<void> closeBox() async {
    if (isInitialized) {
      try {
        await _ruyaBox!.close();
        _ruyaBox = null;
        debugPrint('Rüya kutusu kapatıldı');
      } catch (e) {
        debugPrint('!!! Kutu kapatma hatası: $e');
      }
    }
  }

  @override
  void dispose() {
    closeBox();
    super.dispose();
  }
}
