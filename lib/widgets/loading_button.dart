import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final Function onComplete;
  const LoadingButton({Key? key, required this.onComplete}) : super(key: key);
  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> with SingleTickerProviderStateMixin {
  //https://stackoverflow.com/questions/53424764/circular-progress-button-based-on-hold-flutter
  late AnimationController controller;

  @override initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    controller.addListener(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (_) => controller.forward(),
        onTapUp: (_) {
        if (controller.status == AnimationStatus.forward) {
        controller.reverse();
        } else if (controller.status == AnimationStatus.completed) {
          widget.onComplete();
        }
      },
      child: Stack(
          children: [CircularProgressIndicator(value: 1.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)),
          CircularProgressIndicator(value: controller.value,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
          Padding(
            //TODO: REMOVE THIS AND FIND A BETTER WAY
            padding: const EdgeInsets.all(6.0),
            child: Icon(Icons.check),
          )],
      )
    );
  }
}