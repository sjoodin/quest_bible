import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_bible/features/bible/application/providers/active_section_provider.dart';
import 'package:quest_bible/features/bible/application/providers/hovered_chapter_provider.dart';
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

class _SectionInteractionState {
  const _SectionInteractionState({
    this.activePointerId,
    this.pointerDownSectionId,
    this.wasSectionActiveAtPointerDown = false,
  });

  final int? activePointerId;
  final String? pointerDownSectionId;
  final bool wasSectionActiveAtPointerDown;

  bool isActivePointer(int pointerId) => activePointerId == pointerId;

  _SectionInteractionState copyWith({
    int? activePointerId,
    String? pointerDownSectionId,
    bool? wasSectionActiveAtPointerDown,
  }) {
    return _SectionInteractionState(
      activePointerId: activePointerId,
      pointerDownSectionId: pointerDownSectionId,
      wasSectionActiveAtPointerDown:
          wasSectionActiveAtPointerDown ?? this.wasSectionActiveAtPointerDown,
    );
  }
}

class _LeftSideSectionsState extends ConsumerState<LeftSideSections> {
  _SectionInteractionState _interaction = const _SectionInteractionState();

  void _setActiveSection(BibleSection section) {
    ref.read(activeSectionProvider.notifier).setSection(section);
  }

  void _clearActiveSection() {
    ref.read(activeSectionProvider.notifier).clear();
    ref.read(hoveredChapterProvider.notifier).clear();
  }

  void _handlePointerDownOnSection(int pointerId, BibleSection section) {
    final currentActiveSection = ref.read(activeSectionProvider);
    setState(() {
      _interaction = _interaction.copyWith(
        activePointerId: pointerId,
        pointerDownSectionId: section.id,
        wasSectionActiveAtPointerDown: currentActiveSection?.id == section.id,
      );
    });
    _setActiveSection(section);
  }

  void _handlePointerMoveOverSection(int pointerId, BibleSection section) {
    // Ignore move events from pointers other than the active interaction pointer.
    if (!_interaction.isActivePointer(pointerId)) return;

    if (ref.read(activeSectionProvider)?.id != section.id) {
      _setActiveSection(section);
    }
  }

  void _handlePointerUpOnSection(int pointerId, BibleSection section) {
    if (!_interaction.isActivePointer(pointerId)) return;

    final shouldClose =
        _interaction.wasSectionActiveAtPointerDown &&
        _interaction.pointerDownSectionId == section.id;
    if (shouldClose) {
      _clearActiveSection();
      widget.onSectionReleased?.call();
    }

    _resetInteraction();
  }

  void _resetInteraction() {
    if (!mounted) return;
    setState(() {
      _interaction = const _SectionInteractionState();
    });
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
              activePointerId: _interaction.activePointerId,
              isInteracting: _interaction.activePointerId != null,
              onPointerDown: (pointerId) =>
                  _handlePointerDownOnSection(pointerId, section),
              onPointerMove: (pointerId) =>
                  _handlePointerMoveOverSection(pointerId, section),
              onPointerUp: (pointerId) =>
                  _handlePointerUpOnSection(pointerId, section),
              onPointerCancel: (pointerId) {
                if (_interaction.isActivePointer(pointerId)) {
                  _resetInteraction();
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
    required this.activePointerId,
    required this.isInteracting,
    required this.onPointerDown,
    required this.onPointerMove,
    required this.onPointerUp,
    required this.onPointerCancel,
  });

  final double sectionHeight;
  final BibleSection section;
  final int? activePointerId;
  final bool isInteracting;
  final ValueChanged<int> onPointerDown;
  final ValueChanged<int> onPointerMove;
  final ValueChanged<int> onPointerUp;
  final ValueChanged<int> onPointerCancel;

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
    final activePointerId = widget.activePointerId;
    if (activePointerId == null || event.pointer != activePointerId) {
      return;
    }

    if (event is PointerMoveEvent && _containsGlobalPosition(event.position)) {
      widget.onPointerMove(event.pointer);
      return;
    }

    if (event is PointerUpEvent && _containsGlobalPosition(event.position)) {
      widget.onPointerUp(event.pointer);
      return;
    }

    if (event is PointerCancelEvent) {
      widget.onPointerCancel(event.pointer);
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
      onPointerDown: (event) => widget.onPointerDown(event.pointer),
      onPointerCancel: (event) => widget.onPointerCancel(event.pointer),
      child: Opacity(
        opacity: widget.isInteracting ? 1.0 : 0.5,
        child: Container(
          width: _sectionStripWidth,
          height: widget.sectionHeight,
          color: widget.section.color,
        ),
      ),
    );
  }
}
