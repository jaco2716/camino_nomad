import 'package:flutter/material.dart';

class ExpandableCard extends StatefulWidget {
  final Widget child;
  final Widget expandedChild;

  const ExpandableCard({
    super.key,
    required this.child,
    required this.expandedChild,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  late bool isExpanded;
  @override
  void initState() {
    isExpanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AnimatedSize(
            clipBehavior: Clip.hardEdge,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                widget.child,
                isExpanded ? widget.expandedChild : const SizedBox.shrink(),
              ],
            )),
      ),
    );
  }
}
