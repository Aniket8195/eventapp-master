import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenPage extends StatefulWidget {
  const FullScreenPage({super.key,
    required this.image,
    required this.dark,
  });

  final String image;
  final bool dark;

  @override
  State<FullScreenPage> createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  @override
  void initState() {
    var brightness = widget.dark ? Brightness.light : Brightness.dark;
    var color = widget.dark ? Colors.black12 : Colors.white70;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
      statusBarColor: color,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarDividerColor: color,
      systemNavigationBarIconBrightness: brightness,
    ));
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // Restore your settings here...
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              AnimatedPositioned(
                  duration: const Duration(milliseconds: 333),
                  curve: Curves.fastOutSlowIn,
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child:InteractiveViewer(
                    panEnabled: true,
                    minScale: 0.5,
                    maxScale: 4,
                    child: CachedNetworkImage(
                      imageUrl: widget.image,
                      fit: BoxFit.contain,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                      errorWidget: (context, url, error) {
                        print("firebase storage error is $error");
                        return const Icon(Icons.error);
                      },
                    ),
                  )
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: MaterialButton(
                padding: const EdgeInsets.all(15),
                elevation: 0,
                color: widget.dark ? Colors.black12 : Colors.white70,
                highlightElevation: 0,
                minWidth: double.minPositive,
                height: double.minPositive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back,
                  color: widget.dark ? Colors.white : Colors.black,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}