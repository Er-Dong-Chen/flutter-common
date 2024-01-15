import 'package:flutter/cupertino.dart';

class ComLoading extends StatelessWidget {
  const ComLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CupertinoActivityIndicator(radius: 16));
  }
}
