import 'package:dream/const/color.dart';
import 'package:dream/controller/ruya_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class RuyaListPage extends StatefulWidget {
  const RuyaListPage({super.key});

  @override
  State<RuyaListPage> createState() => _RuyaListPageState();
}

class _RuyaListPageState extends State<RuyaListPage> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = "ca-app-pub-3940256099942544/9214589741";

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  void loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad. final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.sizeOf(context).width.truncate());
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          print(ad.responseInfo);
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          debugPrint('BannerAd failed to load: ${ad.responseInfo}');
          // Dispose the ad here to free resources.
          ad.dispose();
          setState(() {
            _isLoaded = false;
          });
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final ruyaProvider = Provider.of<RuyaProvider>(context);
    // MediaQuery ile bottom inset değerini alıyoruz
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      // Klavye açıldığında ekranın sıkışmaması için
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Yüksekliği artırıyoruz
        child: AppBar(
          title: Column(
            children: [
              Text("Ana Sayfa"), // Üstte başlık
            ],
          ),
          centerTitle: true,
        ),
      ),
      // appBar: AppBar(
      //   title: Align(
      //     alignment: Alignment.bottomCenter,
      //     child: SafeArea(child: SizedBox(width: _bannerAd!.size.width.toDouble(), height: _bannerAd!.size.height.toDouble(), child: AdWidget(ad: _bannerAd!))),
      //   ),
      // ),
      body: SafeArea(
        // Bottom bar'a göre boşluk bırakmak için bottom: false
        bottom: false,
        child: Padding(
          // Alt kısım için padding ekliyoruz (bottom bar + ekstra güvenlik)
          padding: EdgeInsets.only(top: 150, right: 15, left: 15, bottom: bottomPadding + 15),
          child:
              ruyaProvider.ruyalar.isEmpty
                  ? const Center(child: Text('Henüz kaydedilmiş rüya bulunmamaktadır.', style: TextStyle(fontSize: 16)))
                  : Column(
                    children: [
                      if (_isLoaded) AdWidget(ad: _bannerAd!),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: ruyaProvider.ruyalar.length,
                        itemBuilder: (context, index) {
                          var ruya = ruyaProvider.ruyalar[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ExpansionTile(
                              collapsedBackgroundColor: const Color.fromARGB(255, 44, 62, 80),
                              backgroundColor: const Color.fromARGB(255, 44, 62, 80),
                              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              collapsedIconColor: Colors.white,
                              iconColor: const Color.fromARGB(255, 44, 62, 80),
                              title: Text(ruya.baslik, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Text(ruya.tarih, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.expand_more, color: Colors.white),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white),
                                    onPressed: () {
                                      ruyaProvider.deleteRuya(index);
                                    },
                                  ),
                                ],
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Rüya İçeriği:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.background)),
                                      const SizedBox(height: 8),
                                      Text(ruya.icerik, style: const TextStyle(fontSize: 14, color: AppColors.background)),
                                      if (ruya.yorum != null && ruya.yorum!.isNotEmpty) ...[
                                        const SizedBox(height: 16),
                                        Text('Rüya Yorumu:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.background)),
                                        const SizedBox(height: 8),
                                        Text(ruya.yorum!, style: const TextStyle(fontSize: 14, color: AppColors.background)),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
