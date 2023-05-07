import 'package:flutter/material.dart';
import 'package:flutter_2048_clone/constants/app_sizes.dart';
import 'package:flutter_2048_clone/constants/app_strings.dart';
import 'package:flutter_2048_clone/ui/game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.spacingM),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: AppSizes.fontXL,
                ),
              ),
              const SizedBox(
                height: AppSizes.spacingL,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    AppSizes.lengthL,
                    AppSizes.lengthM,
                  ),
                ),
                child: const Text(AppStrings.play),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (context) => const GameScreen(),
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
