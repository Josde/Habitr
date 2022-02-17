import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  Function onComplete;
  LoadingButton({required this.onComplete});
  @override
  _LoadingButtonState createState() => _LoadingButtonState(onComplete: this.onComplete);
}

class _LoadingButtonState extends State<LoadingButton> with SingleTickerProviderStateMixin {
  //https://stackoverflow.com/questions/53424764/circular-progress-button-based-on-hold-flutter
  late AnimationController controller;
  Function onComplete;
  _LoadingButtonState({required this.onComplete});

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
          onComplete();
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
