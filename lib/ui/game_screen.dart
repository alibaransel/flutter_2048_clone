import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048_clone/constants/app_durations.dart';
import 'package:flutter_2048_clone/constants/app_sizes.dart';
import 'package:flutter_2048_clone/constants/app_strings.dart';
import 'package:flutter_2048_clone/enums/game_status.dart';
import 'package:flutter_2048_clone/enums/swipe_direction.dart';
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

  void _swipeTiles(SwipeDirection direction) {
    if (_game.status != GameStatus.playing) return;
    _game.swipe(direction);
  }

  void _restartGame() {
    if (_game.status != GameStatus.over) return;
    _game.restart();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(
          LogicalKeyboardKey.arrowUp,
          includeRepeats: false,
        ): () => _swipeTiles(SwipeDirection.up),
        const SingleActivator(
          LogicalKeyboardKey.arrowDown,
          includeRepeats: false,
        ): () => _swipeTiles(SwipeDirection.down),
        const SingleActivator(
          LogicalKeyboardKey.arrowLeft,
          includeRepeats: false,
        ): () => _swipeTiles(SwipeDirection.left),
        const SingleActivator(
          LogicalKeyboardKey.arrowRight,
          includeRepeats: false,
        ): () => _swipeTiles(SwipeDirection.right),
        const SingleActivator(
          LogicalKeyboardKey.space,
          includeRepeats: false,
        ): _restartGame,
        const SingleActivator(
          LogicalKeyboardKey.enter,
          includeRepeats: false,
        ): _restartGame,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(),
        ),
      ),
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
    );
  }

  Widget _buildPlayBox() {
    return SwipeDetector(
      onSwipe: _swipeTiles,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacingM),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.builder(
            itemCount: 16,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, index) {
              final int value = _game.getValueWithIndex(index);
              return AnimatedSwitcher(
                duration: AppDurations.m,
                child: value == 0
                    ? const SizedBox.shrink()
                    : Container(
                        margin: const EdgeInsets.all(AppSizes.spacingS),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
                          color: Colors.amber,
                        ),
                        child: value == 0
                            ? null
                            : FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  value.toString(),
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                              ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverBox() {
    return FittedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.gameOver,
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: AppSizes.spacingL),
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: _restartGame,
          ),
        ],
      ),
    );
  }
}
