import 'package:flutter/material.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';

const _sectionStripWidth = 25.0;

class LeftSideSections extends StatefulWidget {
  const LeftSideSections({
    super.key,
    required this.onSectionPressed,
    this.onSectionReleased,
  });

  final ValueChanged<BibleSection> onSectionPressed;
  final VoidCallback? onSectionReleased;

  @override
  State<LeftSideSections> createState() => _LeftSideSectionsState();
}

class _LeftSideSectionsState extends State<LeftSideSections> {
  int? _activePointer;
  int? _lastTriggeredIndex;

  bool _isPointerOverStrip(Offset localPosition, double sectionHeight) {
    final totalHeight = sectionHeight * bibleSections.length;
    return localPosition.dx >= 0 &&
        localPosition.dx <= _sectionStripWidth &&
        localPosition.dy >= 0 &&
        localPosition.dy <= totalHeight;
  }

  void _triggerSectionFromPosition(Offset localPosition, double sectionHeight) {
    if (!_isPointerOverStrip(localPosition, sectionHeight)) return;
    final index = (localPosition.dy / sectionHeight).floor().clamp(
      0,
      bibleSections.length - 1,
    );
    if (_lastTriggeredIndex == index) return;
    _lastTriggeredIndex = index;
    widget.onSectionPressed(bibleSections[index]);
  }

  void _clearPointerTracking() {
    _activePointer = null;
    _lastTriggeredIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sectionHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight / bibleSections.length
            : 24.0;

        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) {
            _activePointer = event.pointer;
            _triggerSectionFromPosition(event.localPosition, sectionHeight);
          },
          onPointerMove: (event) {
            if (_activePointer != event.pointer) return;
            _triggerSectionFromPosition(event.localPosition, sectionHeight);
          },
          onPointerUp: (event) {
            if (_activePointer == event.pointer) {
              if (_isPointerOverStrip(event.localPosition, sectionHeight)) {
                widget.onSectionReleased?.call();
              }
              _clearPointerTracking();
            }
          },
          onPointerCancel: (event) {
            if (_activePointer == event.pointer) {
              _clearPointerTracking();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(bibleSections.length, (index) {
              final section = bibleSections[index];
              return BibleSectionButton(
                sectionHeight: sectionHeight,
                section: section,
                isActive: _activePointer != null,
              );
            }),
          ),
        );
      },
    );
  }
}

class BibleSectionButton extends StatelessWidget {
  const BibleSectionButton({
    super.key,
    required this.sectionHeight,
    required this.section,
    required this.isActive,
  });

  final double sectionHeight;
  final BibleSection section;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: Container(
        width: _sectionStripWidth,
        height: sectionHeight,
        color: section.color,
      ),
    );
  }
}
