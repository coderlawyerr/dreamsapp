import 'package:dream/controller/ruya_provider.dart';
import 'package:dream/widget/bottom_bar.dart';
import 'package:dream/wiew/ruya_add_page.dart';
import 'package:dream/wiew/settings_page.dart';
import 'package:dream/wiew/ruya_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Örnek sayfalar (import yollarını proje yapınıza göre güncelleyin)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;
  bool _isProviderInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeProvider();
  }

  // Provider'ı başlatma işlemi
  Future<void> _initializeProvider() async {
    try {
      if (!mounted) return;

      // Provider başlatılıyor
      debugPrint("Provider başlatılıyor...");
      await Provider.of<RuyaProvider>(context, listen: false).initialize();

      if (mounted) {
        setState(() {
          _isProviderInitialized = true;
        });
        debugPrint("Provider başarıyla başlatıldı!");
      }
    } catch (e) {
      debugPrint('Provider başlatma hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veritabanı başlatılamadı: $e')));
      }
    }
  }

  // Sayfaları getirecek widget
  Widget _buildBody() {
    // Provider'ın başlatılmasını bekle
    if (!_isProviderInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Veriler yükleniyor...')],
        ),
      );
    }

    // Aktif sayfayı göster
    return _getPageByIndex(_selectedTabIndex);
  }

  // Tab indeksine göre sayfayı getir
  Widget _getPageByIndex(int index) {
    switch (index) {
      case 0:
        return const RuyaListPage();
      case 1:
        // RuyaAddPage'e callback fonksiyonu gönder
        return RuyaChatPage();
      case 2:
        return const SettingPage();
      default:
        return const RuyaListPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).size.height * 0.08;

    // WillPopScope ekleyerek geri tuşu davranışını kontrol edelim
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Eğer ana sayfa dışında bir sayfadaysak, ana sayfaya dön
        if (_selectedTabIndex != 0) {
          setState(() {
            _selectedTabIndex = 0;
          });
          return false; // Uygulamayı kapatma
        }
        return true; // Uygulamayı kapat
      },
      child: Scaffold(
        extendBody: true,

        // Sayfa içeriği
        body: SafeArea(bottom: false, child: Padding(padding: EdgeInsets.only(bottom: bottomPadding), child: _buildBody())),

        // Alt gezinme çubuğu
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
