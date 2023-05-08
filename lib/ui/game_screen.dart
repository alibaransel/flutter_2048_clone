import 'package:flutter/material.dart';
import 'package:flutter_2048_clone/constants/app_durations.dart';
import 'package:flutter_2048_clone/constants/app_sizes.dart';
import 'package:flutter_2048_clone/constants/app_strings.dart';
import 'package:flutter_2048_clone/enums/game_status.dart';
import 'package:flutter_2048_clone/models/game.dart';
import 'package:flutter_2048_clone/ui/swipe_detector.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Game _game;

  @override
  void initState() {
    super.initState();
    _game = Game(
      height: 4,
      width: 4,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        AppStrings.appName,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spacingM),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.square(AppSizes.lengthXL)),
          child: AnimatedBuilder(
            animation: _game,
            builder: (context, child) {
              return AnimatedSwitcher(
                duration: AppDurations.m,
                child: _game.status == GameStatus.playing ? _buildPlayBox() : _buildGameOverBox(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlayBox() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: SwipeDetector(
        onSwipe: (swipeDirection) => _game.swipe(swipeDirection),
        child: GridView.builder(
          itemCount: 16,
          padding: const EdgeInsets.all(AppSizes.spacingM),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: AppSizes.spacingM,
            crossAxisSpacing: AppSizes.spacingM,
          ),
          itemBuilder: (context, index) {
            final int value = _game.getValueWithIndex(index);
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
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameOverBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.gameOver,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: AppSizes.spacingL,
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => _game.restart(),
        ),
      ],
    );
  }
}
