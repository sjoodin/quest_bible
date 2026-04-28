import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/active_section_provider.dart';
import 'package:quest_bible/features/bible/domain/entities/bible_sections.dart';

// Left-side section strip for touch navigation:
// - pointer down on a section opens/switches active section,
// - dragging across buttons updates active section,
// - releasing on the same button that was already active at pointer down closes the section view.
const _sectionStripWidth = 25.0;

class LeftSideSections extends ConsumerStatefulWidget {
  const LeftSideSections({super.key, this.onSectionReleased});

  final VoidCallback? onSectionReleased;

  @override
  ConsumerState<LeftSideSections> createState() => _LeftSideSectionsState();
}

class _LeftSideSectionsState extends ConsumerState<LeftSideSections> {
  int? _activePointer;
  BibleSection? _pointerDownSection;
  bool _wasActiveOnPointerDown = false;

  void _onButtonPointerDown(PointerDownEvent event, BibleSection section) {
    _activePointer = event.pointer;
    _pointerDownSection = section;
    _wasActiveOnPointerDown = ref.read(activeSectionProvider) == section;
    ref.read(activeSectionProvider.notifier).setSection(section);
  }

  void _onButtonPointerMove(PointerMoveEvent event, BibleSection section) {
    // Ignore other simultaneous move events from any pointer other than the one that started this interaction.
    if (_activePointer != event.pointer) return;
    if (ref.read(activeSectionProvider) != section) {
      ref.read(activeSectionProvider.notifier).setSection(section);
    }
  }

  void _onButtonPointerUp(PointerUpEvent event, BibleSection section) {
    if (_activePointer != event.pointer) return;

    final shouldClose =
        _wasActiveOnPointerDown && _pointerDownSection == section;
    if (shouldClose) {
      ref.read(activeSectionProvider.notifier).clear();
      widget.onSectionReleased?.call();
    }

    _clearPointerTracking();
  }

  void _clearPointerTracking() {
    _activePointer = null;
    _pointerDownSection = null;
    _wasActiveOnPointerDown = false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sectionHeight = constraints.hasBoundedHeight
            ? constraints.maxHeight / bibleSections.length
            : 24.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(bibleSections.length, (index) {
            final section = bibleSections[index];
            return BibleSectionButton(
              sectionHeight: sectionHeight,
              section: section,
              activePointer: _activePointer,
              isActive: _activePointer != null,
              onPointerDown: (event) => _onButtonPointerDown(event, section),
              onPointerMove: (event) => _onButtonPointerMove(event, section),
              onPointerUp: (event) => _onButtonPointerUp(event, section),
              onPointerCancel: (event) {
                if (_activePointer == event.pointer) {
                  _clearPointerTracking();
                }
              },
            );
          }),
        );
      },
    );
  }
}

class BibleSectionButton extends StatefulWidget {
  const BibleSectionButton({
    super.key,
    required this.sectionHeight,
    required this.section,
    required this.activePointer,
    required this.isActive,
    required this.onPointerDown,
    required this.onPointerMove,
    required this.onPointerUp,
    required this.onPointerCancel,
  });

  final double sectionHeight;
  final BibleSection section;
  final int? activePointer;
  final bool isActive;
  final ValueChanged<PointerDownEvent> onPointerDown;
  final ValueChanged<PointerMoveEvent> onPointerMove;
  final ValueChanged<PointerUpEvent> onPointerUp;
  final ValueChanged<PointerCancelEvent> onPointerCancel;

  @override
  State<BibleSectionButton> createState() => _BibleSectionButtonState();
}

class _BibleSectionButtonState extends State<BibleSectionButton> {
  bool _containsGlobalPosition(Offset globalPosition) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      return false;
    }

    final local = renderBox.globalToLocal(globalPosition);
    return local.dx >= 0 &&
        local.dy >= 0 &&
        local.dx <= renderBox.size.width &&
        local.dy <= renderBox.size.height;
  }

  void _handleGlobalPointerEvent(PointerEvent event) {
    final activePointer = widget.activePointer;
    if (activePointer == null || event.pointer != activePointer) {
      return;
    }

    if (event is PointerMoveEvent && _containsGlobalPosition(event.position)) {
      widget.onPointerMove(event);
      return;
    }

    if (event is PointerUpEvent && _containsGlobalPosition(event.position)) {
      widget.onPointerUp(event);
      return;
    }

    if (event is PointerCancelEvent) {
      widget.onPointerCancel(event);
    }
  }

  @override
  void initState() {
    super.initState();
    GestureBinding.instance.pointerRouter.addGlobalRoute(
      _handleGlobalPointerEvent,
    );
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(
      _handleGlobalPointerEvent,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: widget.onPointerDown,
      onPointerCancel: widget.onPointerCancel,
      child: Opacity(
        opacity: widget.isActive ? 1.0 : 0.5,
        child: Container(
          width: _sectionStripWidth,
          height: widget.sectionHeight,
          color: widget.section.color,
        ),
      ),
    );
  }
}
