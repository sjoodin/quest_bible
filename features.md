# Quest Bible - Feature Requirements

## Performance
- Pre-load book list on app startup to avoid database delays when opening section view

## Navigation & Interaction
- Tap section button to open section view with books and chapters
- Drag finger across section buttons to switch active section
- Tap a chapter number to navigate to that chapter
- Tap already-active section button to close section view (same-pointer-sequence rule)

## Chapter & Book Navigation
- Next Chapter button (when current chapter < total chapters for book)
- Next Book button (when on last chapter and another book exists)
- Both buttons styled with their respective section colors

## UI & Theming
- Section colors propagate to all interactive elements (buttons, headers, navigation buttons)
- Section buttons show 50% opacity when inactive, full opacity when active
- Chapter header displays selected book name + chapter number with section color background
- Chapter boxes styled with section color for pressed state

## Hover & Preview Interactions
- Chapter boxes turn red when hovered (mouse on desktop, finger drag on mobile)
- Header updates to show hovered chapter name + number in real-time while hovering
- Touch drag across chapters triggers hover state update for each chapter entered
- Hover state resets when BibleSectionView closes

## State Management
- Book + chapter updates happen atomically via single notifier call to prevent invalid (book, chapter) tuples
- Active section state centrally managed via provider (single source of truth)
- No transient invalid states during navigation or selection changes

## User Experience
- Seamless drag-across section switching while holding pointer
- Immediate visual feedback for button states (opacity, colors)
- Consistent section-color branding throughout UI