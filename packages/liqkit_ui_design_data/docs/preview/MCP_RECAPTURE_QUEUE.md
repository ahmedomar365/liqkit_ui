# MCP Recapture Queue

Generated from local persisted evidence quality checks.

| Priority | Category | ID | Node | Issues | Current design-context bytes | Current screenshot bytes | Figma URL |
| ---: | --- | --- | --- | --- | ---: | ---: | --- |
| 1 | Buttons | buttons | 507:24673 | screenshot_tiny, design_context_tiny | 2664 | 345 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=507-24673 |
| 2 | Materials | materials | 215:105157 | screenshot_tiny, design_context_tiny | 1699 | 347 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=215-105157 |
| 3 | System | system | 507:24688 | screenshot_tiny, design_context_tiny | 2438 | 348 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=507-24688 |
| 4 | Text fields | text-fields | 553:22762 | screenshot_tiny, design_context_tiny | 2641 | 382 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=553-22762 |
| 5 | Text styles | text-styles | 0:2194 | screenshot_tiny, design_context_tiny | 1553 | 1782 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=0-2194 |
| 6 | Toggles | toggles | 507:24690 | screenshot_tiny, design_context_tiny | 2538 | 982 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=507-24690 |
| 7 | Bezels | bezels | 507:24672 | design_context_tiny | 1695 | 44164 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=507-24672 |
| 8 | Face ID | face-id | 507:26011 | design_context_tiny | 2523 | 21034 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=507-26011 |
| 9 | Popup buttons | popup-buttons | 507:26009 | design_context_tiny | 2693 | 3045 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=507-26009 |
| 10 | Progress indicators | progress-indicators | 507:24682 | design_context_tiny | 1586 | 13079 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=507-24682 |
| 11 | Status bars | status-bars | 507:24686 | screenshot_tiny | 4056 | 1963 | https://www.figma.com/design/zaxcqZr1Vg7oSf38Vrhulx/iOS-and-iPadOS-26--Community-?node-id=507-24686 |

## Recapture policy

- Fetch category root with `get_metadata` first, then fetch broader canonical child nodes with `get_design_context`.
- Persist at least one non-tiny screenshot per category that shows full component variants.
- Avoid replacing existing strong artifacts unless new capture is strictly better.