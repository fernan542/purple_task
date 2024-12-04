import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/categories/categories_controller.dart';
import '../../../models/models.dart';
import 'widgets/narrow_layout/narrow_layout.dart';
import 'widgets/wide_layout/wide_layout.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

// ignore: prefer_mixin
class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final AppWindowSize _appWindowSize = AppWindowSizePluginBased();
  Size? _windowSize =
      WidgetsBinding.instance.platformDispatcher.implicitView?.physicalSize;
  Size? _tempWindowSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Used to save app window size on resize
  @override
  void didChangeMetrics() {
    _tempWindowSize =
        WidgetsBinding.instance.platformDispatcher.implicitView?.physicalSize;
    if (_windowSize != _tempWindowSize) {
      _windowSize = _tempWindowSize;
      _appWindowSize.saveWindowSize(_windowSize!.width, _windowSize!.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer(
          builder: (context, ref, _) {
            final isCategoryListEmpty =
                ref.watch(categoriesNotifierProvider).isEmpty;
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 700 || isCategoryListEmpty) {
                  return const NarrowLayout();
                } else {
                  return const WideLayout();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
