import 'package:flutter/cupertino.dart';

class ComLoading extends StatelessWidget {
  final double size;
  const ComLoading({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Center(child: CupertinoActivityIndicator(radius: size));
  }
}
