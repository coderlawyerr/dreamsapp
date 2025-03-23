

import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAds {
   InterstitialAd? _interstitialAd;
   /// Loads an interstitial ad.
  void loadInterstitalAd({bool showAfterLoad= false}) {
    

    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          
          _interstitialAd = ad;
          if(showAfterLoad) showInterstitalAd();
          {

          }
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
         
        },
      ),
    );
  }
  void  showInterstitalAd(){
    if(_interstitialAd!=null){
      _interstitialAd!.show();
    }

  }
}