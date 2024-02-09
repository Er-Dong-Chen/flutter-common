import 'package:flutter/cupertino.dart';

class ComLoading extends StatelessWidget {
  final double size;
  final Color? color;
  const ComLoading({super.key, this.size = 16, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: size,
        color: color,
      ),
    );
  }
}
