import 'package:flutter/material.dart';

class ComRating extends StatefulWidget {
  final double rating;
  final int starCount;
  final double starSize;
  final Color filledColor;
  final Color unfilledColor;
  final bool allowHalfStar;
  final double spacing;
  final ValueChanged<double>? onRatingChanged;
  final Widget? filledIcon;
  final Widget? unfilledIcon;
  final Widget? halfFilledIcon;

  const ComRating({
    super.key,
    this.rating = 0.0,
    this.starCount = 5,
    this.starSize = 24.0,
    this.filledColor = Colors.amber,
    this.unfilledColor = Colors.grey,
    this.allowHalfStar = true,
    this.spacing = 2.0,
    this.onRatingChanged,
    this.filledIcon,
    this.unfilledIcon,
    this.halfFilledIcon,
  });

  @override
  ComRatingState createState() => ComRatingState();
}

class ComRatingState extends State<ComRating> {
  double _currentRating = 0.0;
  bool _isSliding = false;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void didUpdateWidget(ComRating oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSliding && oldWidget.rating != widget.rating) {
      _currentRating = widget.rating;
    }
  }

  void _updateRating(Offset position) {
    if (widget.onRatingChanged == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(position);
    final double width = box.size.width;
    final double starWidth = (width + widget.spacing) / widget.starCount;

    double newRating =
        (localPosition.dx / starWidth).clamp(0.0, widget.starCount.toDouble());

    if (widget.allowHalfStar) {
      newRating = (newRating * 2).round() / 2;
    } else {
      newRating = newRating.roundToDouble();
    }

    if (newRating != _currentRating) {
      setState(() {
        _currentRating = newRating;
      });
      widget.onRatingChanged?.call(newRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart:
          widget.onRatingChanged != null ? (_) => _isSliding = true : null,
      onHorizontalDragUpdate: widget.onRatingChanged != null
          ? (details) => _updateRating(details.globalPosition)
          : null,
      onHorizontalDragEnd:
          widget.onRatingChanged != null ? (_) => _isSliding = false : null,
      onTapDown: widget.onRatingChanged != null
          ? (details) => _updateRating(details.globalPosition)
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.starCount, (index) {
          Widget star;
          if (index < _currentRating &&
              index + 1 > _currentRating &&
              widget.allowHalfStar) {
            star = widget.halfFilledIcon ??
                Icon(
                  Icons.star_half,
                  size: widget.starSize,
                  color: widget.filledColor,
                );
          } else if (index < _currentRating) {
            star = widget.filledIcon ??
                Icon(
                  Icons.star,
                  size: widget.starSize,
                  color: widget.filledColor,
                );
          } else {
            star = widget.unfilledIcon ??
                Icon(
                  Icons.star_border,
                  size: widget.starSize,
                  color: widget.unfilledColor,
                );
          }

          return Padding(
            padding: EdgeInsets.only(right: widget.spacing),
            child: star,
          );
        }),
      ),
    );
  }
}
