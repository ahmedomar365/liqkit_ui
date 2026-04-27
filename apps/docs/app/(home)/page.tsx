import Link from 'next/link';

export default function HomePage() {
  return (
    <main className="flex flex-1 flex-col items-center justify-center p-8 text-center">
      <h1 className="text-4xl font-bold">liqkit_ui</h1>
      <p className="mt-2 text-lg text-fd-muted-foreground">
        iOS 26 Liquid Glass design system for Flutter.
      </p>
      <Link
        href="/docs"
        className="mt-6 rounded-md bg-fd-primary px-4 py-2 text-fd-primary-foreground"
      >
        Browse the docs
      </Link>
    </main>
  );
}
