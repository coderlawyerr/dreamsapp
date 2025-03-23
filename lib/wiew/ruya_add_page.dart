import 'package:dream/const/color.dart';
import 'package:dream/controller/ruya_commentt_provider.dart';
import 'package:dream/controller/ruya_provider.dart';
import 'package:dream/model/ruya_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RuyaChatPage extends StatefulWidget {
  @override
  _RuyaChatPageState createState() => _RuyaChatPageState();
}

class _RuyaChatPageState extends State<RuyaChatPage> {
  String _ruyaYorumu = "";
  RuyaModel? _currentRuya;
  final RuyaYorumuController _yorumuController = RuyaYorumuController();
  final TextEditingController _messageController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 35, right: 10, left: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity, // Sayfanın genişliği kadar
              padding: EdgeInsets.all(15), // Kenar boşluğu eklemek için
              decoration: BoxDecoration(
                //   color: AppColors.text, // Arka plan rengini pembe yap
                borderRadius: BorderRadius.circular(20), // Köşeleri oval yap
              ),
              child: CircleAvatar(
                radius: 45,

                backgroundColor:AppColors.text, // Arka plan rengi beyaz olsun
                child: Text(
                  "D",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color:AppColors.background, // Harf rengi siyah olsun
                  ),
                ),
              ),
            ),
            Divider(thickness: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: [
                  // Karşılama mesajı
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.text, borderRadius: BorderRadius.circular(12)),
                      child: Text("Rüyanı dinlemek için sabırsızlanıyorum...", style: TextStyle(color: AppColors.background)),
                    ),
                  ),

                  // Kullanıcı rüyası (eğer girilmişse)
                  if (_currentRuya != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(12)),
                        child: Text(_currentRuya!.icerik, style: TextStyle(color: Colors.white)),
                      ),
                    ),

                  // Rüya yorumu (eğer üretilmişse)
                  if (_ruyaYorumu.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.text, borderRadius: BorderRadius.circular(12)),
                        child: Text(_ruyaYorumu, style: TextStyle(color: AppColors.background)),
                      ),
                    ),

                  // İşlem göstergesi
                  if (_isProcessing) Center(child: Padding(padding: const EdgeInsets.all(12.0), child: CircularProgressIndicator())),
                ],
              ),
            ),

            // Mesaj giriş alanı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Rüyanı anlat...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      enabled: !_isProcessing,
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: AppColors.text),
                    onPressed:
                        _isProcessing
                            ? null
                            : () async {
                              if (_messageController.text.trim().isNotEmpty) {
                                final ruyaMetni = _messageController.text.trim();

                                setState(() {
                                  _isProcessing = true;
                                  _ruyaYorumu = "";
                                  _currentRuya = RuyaModel(
                                    baslik: "Rüya",
                                    icerik: ruyaMetni,
                                    kategori: "Genel",
                                    tarih: DateTime.now().toIso8601String(),
                                    yorum: "",
                                  );
                                });

                                try {
                                  // API'den yorum al
                                  final yorum = await _yorumuController.getYorum(ruyaMetni);

                                  // Rüyayı ve yorumu kaydet
                                  final ruyaProvider = Provider.of<RuyaProvider>(context, listen: false);
                                  final yeniRuya = RuyaModel(
                                    baslik: "Rüya",
                                    icerik: ruyaMetni,
                                    kategori: "Genel",
                                    tarih: DateTime.now().toIso8601String(),
                                    yorum: yorum,
                                  );

                                  await ruyaProvider.addRuya(yeniRuya);

                                  setState(() {
                                    _ruyaYorumu = yorum;
                                    _isProcessing = false;
                                  });
                                } catch (e) {
                                  setState(() {
                                    _ruyaYorumu = "Rüya yorumu alınamadı: $e";
                                    _isProcessing = false;
                                  });
                                }

                                _messageController.clear();
                              }
                            },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
