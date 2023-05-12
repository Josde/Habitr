import 'package:flutter/material.dart';

// FIXME: REFERENCIA DE CLASE: https://www.youtube.com/watch?v=5k8XFgRtPb4
class LikeButton extends StatefulWidget {
  const LikeButton(
      {Key? key,
      required this.isAnimating,
      required this.duration,
      required this.isLiked,
      required this.likeCount})
      : super(key: key);
  final bool isAnimating;
  final Duration duration;
  final bool isLiked;
  final int likeCount;
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;
  bool isLiked = false;

  @override
  void initState() {
    final halfDuration = widget.duration.inMilliseconds ~/ 2;
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: halfDuration));
    scale = Tween<double>(begin: 1, end: 1.2).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    doAnimation(); // FIXME: This is dirty
  }

  @override
  Widget build(BuildContext context) {
    var color = isLiked ? Colors.redAccent : Theme.of(context).iconTheme.color;
    return ScaleTransition(
      scale: scale,
      child: Stack(alignment: Alignment.center, children: [
        Icon(Icons.favorite, color: color),
        Text('${widget.likeCount}',
            style: TextStyle(
                fontSize: 10.0)) //TODO: Checkear que esto no hace overflow
      ]),
    );
  }

  Future doAnimation() async {
    // TODO: This is currently not working
    if (widget.isAnimating) {
      await _controller.forward();
      await _controller.reverse();
    }
  }
}
