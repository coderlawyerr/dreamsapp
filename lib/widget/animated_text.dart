import 'package:dream/const/color.dart';
import 'package:dream/wiew/home_page.dart';
import 'package:flutter/material.dart';

class FallingTextAnimation extends StatefulWidget {
  const FallingTextAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FallingTextAnimationState createState() => _FallingTextAnimationState();
}

class _FallingTextAnimationState extends State<FallingTextAnimation> with TickerProviderStateMixin {
  final String text = "YOUR DREAMS "; // Animasyon yapacağımız metin
  late List<AnimationController> controllers;
  late List<Animation<Offset>> animations;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(text.length, (index) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 800 + (index * 200)), // Sıralı animasyon
      );
    });

    animations =
        controllers.map((controller) {
          return Tween<Offset>(
            // Başlangıç ve bitiş konumları
            begin: const Offset(0, -2), // Başlangıç: yukarıdan başlasın
            end: Offset.zero, // Bitiş: Normal konumuna gelsin
          ).animate(CurvedAnimation(parent: controller, curve: Curves.bounceOut));
        }).toList();

    // Use Future.microtask to start animation after the first frame
    Future.microtask(() => _startAnimation());
  }

  void _startAnimation() async {
    // Animasyonlar sırasıyla başlatılır
    for (var controller in controllers) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 200)); // Harfler sırayla düşsün
      if (!mounted) return;
      controller.forward();
    }

    // Wait for all animations to complete
    await Future.delayed(const Duration(seconds: 2));

    if (mounted && !_isNavigating) {
      _isNavigating = true;
      _navigateToNextPage();
    }
  }

  void _navigateToNextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()), // 'HomePage' yönlendirilmek istenen sayfa
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Arka plan rengi
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(text.length, (index) {
              return SlideTransition(
                position: animations[index],
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        // ignore: deprecated_member_use
                        Colors.purple.withOpacity(0.6),
                        // ignore: deprecated_member_use
                        Colors.blue.withOpacity(0.6),
                      ], // Yumuşak geçiş renkleri
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds);
                  },
                  child: Text(text[index], style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: AppColors.text)),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
