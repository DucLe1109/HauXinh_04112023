import 'package:flutter/cupertino.dart';

class DefaultErrorWidget extends StatelessWidget {
  final String errorMessage;

  const DefaultErrorWidget({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorMessage),
    );
  }
}
