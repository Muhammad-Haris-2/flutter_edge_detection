import 'package:flutter/material.dart';

class CropBubble extends StatefulWidget {
  const CropBubble({
    super.key,
    required this.size,
    required this.onDrag,
    required this.onDragFinished,
  });

  final double size;
  final Function onDrag;
  final Function onDragFinished;

  @override
  State<CropBubble> createState() => _CropBubbleState();
}

class _CropBubbleState extends State<CropBubble> {
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: _startDragging,
      onPanUpdate: _drag,
      onPanCancel: _cancelDragging,
      onPanEnd: (_) => _cancelDragging(),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(widget.size / 2)),
        child: AnimatedCropBubble(
          dragging: dragging,
          size: widget.size,
        ),
      ),
    );
  }

  void _startDragging(DragStartDetails data) {
    setState(() {
      dragging = true;
    });
    widget.onDrag(data.localPosition - Offset(widget.size / 2, widget.size / 2));
  }

  void _cancelDragging() {
    setState(() {
      dragging = false;
    });
    widget.onDragFinished();
  }

  void _drag(DragUpdateDetails data) {
    if (!dragging) {
      return;
    }

    widget.onDrag(data.delta);
  }
}

class AnimatedCropBubble extends StatefulWidget {
  const AnimatedCropBubble({super.key, required this.dragging, required this.size});

  final bool dragging;
  final double size;

  @override
  State<AnimatedCropBubble> createState() => _AnimatedCropBubbleState();
}

class _AnimatedCropBubbleState extends State<AnimatedCropBubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void didChangeDependencies() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);

    _colorAnimation = ColorTween(
      begin: Colors.amber.withOpacity(0.5),
      end: Colors.amber.withOpacity(0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0),
      ),
    );

    _controller.repeat();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: widget.dragging ? 0 : widget.size / 2,
            height: widget.dragging ? 0 : widget.size / 2,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.5),
              borderRadius: widget.dragging ? BorderRadius.circular(widget.size) : BorderRadius.circular(widget.size / 4),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Center(
              child: Container(
                width: widget.dragging ? 0 : widget.size * _sizeAnimation.value,
                height: widget.dragging ? 0 : widget.size * _sizeAnimation.value,
                decoration: BoxDecoration(
                  border: Border.all(color: _colorAnimation.value!, width: widget.size / 20),
                  borderRadius: widget.dragging ? BorderRadius.zero : BorderRadius.circular(widget.size * _sizeAnimation.value / 2),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
