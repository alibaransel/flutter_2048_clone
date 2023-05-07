import 'package:flutter/material.dart';
import 'package:flutter_2048_clone/constants/app_sizes.dart';
import 'package:flutter_2048_clone/constants/app_strings.dart';
import 'package:flutter_2048_clone/enums/swipe_direction.dart';
import 'package:flutter_2048_clone/models/game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game game;

  @override
  void initState() {
    super.initState();
    game = Game(
      height: 4,
      width: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => game.swipe(SwipeDirection.left),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text(AppStrings.appName),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.square(400)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            ),
            child: AnimatedBuilder(
              animation: game,
              builder: (context, child) {
                return GridView.builder(
                  itemCount: 16,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: AppSizes.padding,
                    crossAxisSpacing: AppSizes.padding,
                  ),
                  itemBuilder: (context, index) {
                    final int value = game.getValueWithIndex(index);
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                        color: Colors.amber,
                      ),
                      child: value == 0
                          ? null
                          : Center(
                              child: Text(
                                value.toString(),
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
