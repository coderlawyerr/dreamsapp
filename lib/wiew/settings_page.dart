import 'package:dream/const/color.dart';
import 'package:dream/controller/theme_provider.dart';
import 'package:dream/wiew/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isNotificationEnabled = false; // Bildirim durumunu tutan değişken

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text("Temayı Değiştir"),
                leading: const Icon(Icons.sunny),
                trailing: Switch(
                  value: themeProvider.isDarkTheme,
                  onChanged: (value) {
                    themeProvider.toggleTheme(); // Tema değişim fonksiyonunu çağır
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(child: const ListTile(title: Text("Bizi Değerlendir"), leading: Icon(Icons.star_sharp))),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                title: const Text("Çıkış Yap"),
                leading: const Icon(Icons.door_back_door),
                onTap: () {
                  // Navigator.push ile logout sayfasına geçiş yapıyoruz
                  SystemNavigator.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
