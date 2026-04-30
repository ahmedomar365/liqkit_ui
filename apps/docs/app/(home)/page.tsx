import Link from 'next/link';

const FEATURES: Array<{ title: string; body: string }> = [
  {
    title: '69 components',
    body:
      'Every primitive forui and shadcn/ui ship — accordion, dialog, ' +
      'tabs, toast, breadcrumb, command palette, tree view, kanban — ' +
      'plus 37 iOS-26-specific surfaces (face ID, status bars, app ' +
      'icons, materials, bezels, keyboards) with no equivalent ' +
      'elsewhere.',
  },
  {
    title: 'Liquid Glass throughout',
    body:
      'Translucent surfaces, hairline rims, soft drop shadows, iOS ' +
      'spring animations, and the San Francisco type scale — sourced ' +
      'directly from Apple’s iOS 26 design language.',
  },
  {
    title: 'Pure Dart, golden-tested',
    body:
      'Canonical tokens captured from Figma into typed Dart classes. ' +
      'Every widget has goldens asserting exact pixel dimensions. ' +
      'Steady-state dependencies are Dart-only — no JS toolchain.',
  },
  {
    title: 'Live previews + interactive snippets',
    body:
      'Each docs page iframes a Flutter Web app rendering the actual ' +
      'widget. Snippets are extracted with `// {@highlight}` markers ' +
      'so you copy exactly what runs in the preview.',
  },
];

const PHASES: Array<{ label: string; count: number; sample: string }> = [
  { label: 'iOS chrome', count: 37, sample: 'Face ID, status bar, bezel, app icon, keyboard, material' },
  { label: 'Foundation', count: 16, sample: 'Accordion, dialog, drawer, tabs, toast, tooltip, badge, card' },
  { label: 'Form/input', count: 6, sample: 'Calendar, time picker, OTP, number field, combobox, chip' },
  { label: 'Advanced',   count: 5, sample: 'Command palette, carousel, hover card, resizable, data table' },
  { label: 'Phase 5',    count: 5, sample: 'Tree view, rich editor, line chart, bar chart, kanban' },
];

export default function HomePage() {
  return (
    <main className="flex flex-1 flex-col">
      {/* Hero */}
      <section className="border-b border-fd-border bg-fd-card/40 px-6 py-24 text-center md:py-32">
        <h1 className="text-balance text-5xl font-bold tracking-tight md:text-6xl">
          liqkit_ui
        </h1>
        <p className="mx-auto mt-6 max-w-2xl text-balance text-lg text-fd-muted-foreground md:text-xl">
          The iOS&nbsp;26 Liquid Glass design system for Flutter. 69
          components, every one with goldens, live previews, and
          interactive code snippets.
        </p>
        <div className="mt-10 flex flex-wrap items-center justify-center gap-3">
          <Link
            href="/docs"
            className="rounded-md bg-fd-primary px-5 py-3 text-sm font-medium text-fd-primary-foreground transition hover:opacity-90"
          >
            Browse the docs
          </Link>
          <Link
            href="/docs/getting-started/installation"
            className="rounded-md border border-fd-border bg-fd-card px-5 py-3 text-sm font-medium text-fd-card-foreground transition hover:bg-fd-accent"
          >
            Get started
          </Link>
          <a
            href="https://github.com/ahmedomar365/liqkit_ui"
            target="_blank"
            rel="noreferrer"
            className="rounded-md border border-fd-border bg-fd-card px-5 py-3 text-sm font-medium text-fd-card-foreground transition hover:bg-fd-accent"
          >
            GitHub
          </a>
        </div>
        <p className="mt-8 text-xs text-fd-muted-foreground">
          MIT licensed &middot; pure Dart pub workspace under Melos
        </p>
      </section>

      {/* Feature grid */}
      <section className="border-b border-fd-border px-6 py-20">
        <div className="mx-auto grid max-w-5xl gap-6 md:grid-cols-2">
          {FEATURES.map((f) => (
            <div
              key={f.title}
              className="rounded-lg border border-fd-border bg-fd-card p-6"
            >
              <h2 className="text-lg font-semibold">{f.title}</h2>
              <p className="mt-2 text-sm leading-relaxed text-fd-muted-foreground">
                {f.body}
              </p>
            </div>
          ))}
        </div>
      </section>

      {/* Component breakdown */}
      <section className="border-b border-fd-border px-6 py-20">
        <div className="mx-auto max-w-5xl">
          <h2 className="text-2xl font-semibold">What’s in the box</h2>
          <p className="mt-2 text-sm text-fd-muted-foreground">
            69 components across five build phases. Every category linked
            from the sidebar.
          </p>
          <div className="mt-8 overflow-hidden rounded-lg border border-fd-border bg-fd-card">
            <table className="w-full text-sm">
              <thead className="bg-fd-muted/30 text-fd-muted-foreground">
                <tr>
                  <th className="px-4 py-3 text-left font-medium">
                    Phase
                  </th>
                  <th className="px-4 py-3 text-right font-medium">
                    Count
                  </th>
                  <th className="px-4 py-3 text-left font-medium">
                    Sample
                  </th>
                </tr>
              </thead>
              <tbody>
                {PHASES.map((p) => (
                  <tr
                    key={p.label}
                    className="border-t border-fd-border/60"
                  >
                    <td className="px-4 py-3 font-medium">{p.label}</td>
                    <td className="px-4 py-3 text-right tabular-nums">
                      {p.count}
                    </td>
                    <td className="px-4 py-3 text-fd-muted-foreground">
                      {p.sample}
                    </td>
                  </tr>
                ))}
                <tr className="border-t border-fd-border bg-fd-muted/20">
                  <td className="px-4 py-3 font-semibold">Total</td>
                  <td className="px-4 py-3 text-right font-semibold tabular-nums">
                    69
                  </td>
                  <td className="px-4 py-3" />
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="px-6 py-24 text-center">
        <h2 className="text-3xl font-semibold">Ready to build?</h2>
        <p className="mx-auto mt-3 max-w-xl text-fd-muted-foreground">
          Add liqkit_ui to your <code>pubspec.yaml</code> and import a
          single barrel.
        </p>
        <pre className="mx-auto mt-8 max-w-md overflow-x-auto rounded-md border border-fd-border bg-fd-card p-4 text-left text-sm">
          {`dependencies:\n  liqkit_ui: any`}
        </pre>
        <div className="mt-8 flex flex-wrap items-center justify-center gap-3">
          <Link
            href="/docs/getting-started/installation"
            className="rounded-md bg-fd-primary px-5 py-3 text-sm font-medium text-fd-primary-foreground transition hover:opacity-90"
          >
            Installation guide
          </Link>
        </div>
      </section>
    </main>
  );
}
