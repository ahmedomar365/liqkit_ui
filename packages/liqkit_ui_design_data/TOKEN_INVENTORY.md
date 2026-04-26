# liqkit token surface inventory

Compares the *true* iOS 26 token surface (extracted from every Figma variable-defs.json across all 37 categories) against what the TS \`foundationTokens\` capture in \`tokens.json\` exposes.

## Summary

- Categories scanned: 37
- Modes encountered: [default, increasedContrast]
- Unique color tokens (across all modes): 40
- Unique typography tokens: 2
- Unique other tokens: 0

## TS-captured vs. Figma-defined

| Surface | TS tokens.json | Figma variable-defs |
|---|---:|---:|
| Colors | 5 | 40 |
| Radii | 4 | n/a (in component CSS only) |
| Spacing | 5 | n/a (in component CSS only) |
| Typography | 0 | 2 |

## Mode: `default` (42 tokens)

### Colors (40)

- `Accents/Blue` = #0091ff
- `Accents/Brown` = #b78a66
- `Accents/Cyan` = #3cd3fe
- `Accents/Green` = #30d158
- `Accents/Indigo` = #6d7cff
- `Accents/Mint` = #00dac3
- `Accents/Orange` = #ff9230
- `Accents/Pink` = #ff375f
- `Accents/Purple` = #db34f2
- `Accents/Red` = #ff4245
- `Accents/Teal` = #00d2e0
- `Accents/Yellow` = #ffd600
- `Backgrounds (Grouped)/Primary` = #000000
- `Backgrounds (Grouped)/Primary - Elevated` = #1c1c1e
- `Backgrounds (Grouped)/Secondary` = #1c1c1e
- `Backgrounds (Grouped)/Secondary - Elevated` = #2c2c2e
- `Backgrounds (Grouped)/Tertiary` = #2c2c2e
- `Backgrounds (Grouped)/Tertiary - Elevated` = #3a3a3c
- `Backgrounds/Primary` = #000000
- `Backgrounds/Primary - Elevated` = #1c1c1e
- `Backgrounds/Secondary` = #1c1c1e
- `Backgrounds/Secondary - Elevated` = #2c2c2e
- `Backgrounds/Tertiary` = #2c2c2e
- `Backgrounds/Tertiary - Elevated` = #3a3a3c
- `Grays/Black` = #000000
- `Grays/Gray` = #8e8e93
- `Grays/Gray 2` = #AEAEB2
- `Grays/Gray 3` = #48484a
- `Grays/Gray 4` = #3a3a3c
- `Grays/Gray 5` = #2c2c2e
- `Grays/Gray 6` = #1c1c1e
- `Grays/White` = #ffffff
- `Labels/Primary` = #ffffff
- `Labels/Quaternary` = #ebebf529
- `Labels/Secondary` = #ebebf5b2
- `Labels/Tertiary` = #ebebf54d
- `Section Fill` = #f5f5f5
- `Section Stroke` = #00000066
- `Separators/Non-opaque` = #ffffff2b
- `Separators/Opaque` = #38383a

### Typography (2)

- `Footnote/Emphasized` = Font(family: "SF Pro", style: Semibold, size: 13, weight: 590, lineHeight: 18, letterSpacing: -0.07999999821186066)
- `Footnote/Regular` = Font(family: "SF Pro", style: Regular, size: 13, weight: 400, lineHeight: 18, letterSpacing: -0.07999999821186066)


## Mode: `increasedContrast` (42 tokens)

### Colors (40)

- `Accents/Blue` = #5cb8ff
- `Accents/Brown` = #dba679
- `Accents/Cyan` = #6dd9ff
- `Accents/Green` = #4ae968
- `Accents/Indigo` = #a7aaff
- `Accents/Mint` = #54dfcb
- `Accents/Orange` = #ffa056
- `Accents/Pink` = #ff8ac4
- `Accents/Purple` = #ea8dff
- `Accents/Red` = #ff6165
- `Accents/Teal` = #3bddec
- `Accents/Yellow` = #fedf43
- `Backgrounds (Grouped)/Primary` = #000000
- `Backgrounds (Grouped)/Primary - Elevated` = #1c1c1e
- `Backgrounds (Grouped)/Secondary` = #1c1c1e
- `Backgrounds (Grouped)/Secondary - Elevated` = #2c2c2e
- `Backgrounds (Grouped)/Tertiary` = #2c2c2e
- `Backgrounds (Grouped)/Tertiary - Elevated` = #3a3a3c
- `Backgrounds/Primary` = #000000
- `Backgrounds/Primary - Elevated` = #1c1c1e
- `Backgrounds/Secondary` = #1c1c1e
- `Backgrounds/Secondary - Elevated` = #2c2c2e
- `Backgrounds/Tertiary` = #2c2c2e
- `Backgrounds/Tertiary - Elevated` = #3a3a3c
- `Grays/Black` = #000000
- `Grays/Gray` = #aeaeb2
- `Grays/Gray 2` = #AEAEB2
- `Grays/Gray 3` = #444446
- `Grays/Gray 4` = #363638
- `Grays/Gray 5` = #242426
- `Grays/Gray 6` = #000000
- `Grays/White` = #ffffff
- `Labels/Primary` = #ffffff
- `Labels/Quaternary` = #ebebf566
- `Labels/Secondary` = #ebebf5b2
- `Labels/Tertiary` = #ebebf58c
- `Section Fill` = #f5f5f5
- `Section Stroke` = #00000066
- `Separators/Non-opaque` = #ffffff2b
- `Separators/Opaque` = #38383a

### Typography (2)

- `Footnote/Emphasized` = Font(family: "SF Pro", style: Semibold, size: 13, weight: 590, lineHeight: 18, letterSpacing: -0.07999999821186066)
- `Footnote/Regular` = Font(family: "SF Pro", style: Regular, size: 13, weight: 400, lineHeight: 18, letterSpacing: -0.07999999821186066)

## Per-category color-token presence

A `*` in a column means the category file declared that token at least once.

_Listed: top 30 most cross-category-shared tokens. Full data in `manifests/token_inventory.json`._

- `Backgrounds (Grouped)/Primary - Elevated` — present in 1 categories
- `Accents/Brown` — present in 1 categories
- `Accents/Cyan` — present in 1 categories
- `Accents/Green` — present in 1 categories
- `Accents/Indigo` — present in 1 categories
- `Accents/Mint` — present in 1 categories
- `Accents/Orange` — present in 1 categories
- `Accents/Pink` — present in 1 categories
- `Accents/Purple` — present in 1 categories
- `Accents/Red` — present in 1 categories
- `Accents/Teal` — present in 1 categories
- `Accents/Yellow` — present in 1 categories
- `Backgrounds (Grouped)/Primary` — present in 1 categories
- `Accents/Blue` — present in 1 categories
- `Backgrounds (Grouped)/Secondary` — present in 1 categories
- `Backgrounds (Grouped)/Secondary - Elevated` — present in 1 categories
- `Backgrounds (Grouped)/Tertiary` — present in 1 categories
- `Backgrounds (Grouped)/Tertiary - Elevated` — present in 1 categories
- `Backgrounds/Primary` — present in 1 categories
- `Backgrounds/Primary - Elevated` — present in 1 categories
- `Backgrounds/Secondary` — present in 1 categories
- `Backgrounds/Secondary - Elevated` — present in 1 categories
- `Backgrounds/Tertiary` — present in 1 categories
- `Backgrounds/Tertiary - Elevated` — present in 1 categories
- `Grays/Black` — present in 1 categories
- `Separators/Opaque` — present in 1 categories
- `Grays/Gray 2` — present in 1 categories
- `Grays/Gray 3` — present in 1 categories
- `Grays/Gray 4` — present in 1 categories
- `Grays/Gray 5` — present in 1 categories
