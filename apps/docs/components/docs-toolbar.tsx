'use client';

import { useSearchContext } from 'fumadocs-ui/contexts/search';
import { useTheme } from 'next-themes';
import { useEffect, useState } from 'react';

interface DocsToolbarProps {
  variant?: 'lg' | 'sm';
}

export function DocsToolbar({ variant = 'lg' }: DocsToolbarProps) {
  const search = useSearchContext();
  const { resolvedTheme, setTheme, theme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (variant === 'sm') {
    return (
      <div className="flex items-center gap-1">
        <button
          type="button"
          aria-label="Search"
          className="inline-flex size-10 items-center justify-center rounded-md text-fd-muted-foreground transition-colors hover:bg-fd-accent hover:text-fd-accent-foreground"
          onClick={() => search.setOpenSearch(true)}
        >
          <SearchIcon className="size-5" />
        </button>
        <ThemeButton
          mounted={mounted}
          resolvedTheme={resolvedTheme}
          theme={theme}
          setTheme={setTheme}
        />
      </div>
    );
  }

  return (
    <div className="flex items-center gap-2">
      <button
        type="button"
        className="flex min-w-0 flex-1 items-center gap-2 rounded-lg border bg-fd-secondary/45 px-3 py-2 text-start text-sm text-fd-muted-foreground transition-colors hover:bg-fd-accent hover:text-fd-accent-foreground"
        onClick={() => search.setOpenSearch(true)}
      >
        <SearchIcon className="size-4 shrink-0" />
        <span className="min-w-0 flex-1 truncate">Search</span>
        <kbd className="rounded border bg-fd-background px-1.5 py-0.5 text-[0.65rem] leading-none text-fd-muted-foreground">
          Ctrl K
        </kbd>
      </button>
      <ThemeButton
        mounted={mounted}
        resolvedTheme={resolvedTheme}
        theme={theme}
        setTheme={setTheme}
      />
    </div>
  );
}

function ThemeButton({
  mounted,
  resolvedTheme,
  theme,
  setTheme,
}: {
  mounted: boolean;
  resolvedTheme?: string;
  theme?: string;
  setTheme: (theme: string) => void;
}) {
  const effectiveTheme = mounted ? resolvedTheme : 'light';
  const nextTheme = effectiveTheme === 'dark' ? 'light' : 'dark';
  const label = effectiveTheme === 'dark' ? 'Switch to light' : 'Switch to dark';

  return (
    <button
      type="button"
      aria-label={label}
      title={label}
      className="inline-flex size-10 shrink-0 items-center justify-center rounded-md border bg-fd-background text-fd-muted-foreground transition-colors hover:bg-fd-accent hover:text-fd-accent-foreground"
      onClick={() => setTheme(nextTheme)}
    >
      {theme === 'system' && mounted ? (
        <SystemIcon className="size-4" />
      ) : effectiveTheme === 'dark' ? (
        <MoonIcon className="size-4" />
      ) : (
        <SunIcon className="size-4" />
      )}
    </button>
  );
}

function SearchIcon({ className }: { className?: string }) {
  return (
    <svg
      aria-hidden="true"
      className={className}
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <circle cx="11" cy="11" r="7" />
      <path d="m20 20-3.5-3.5" />
    </svg>
  );
}

function SunIcon({ className }: { className?: string }) {
  return (
    <svg
      aria-hidden="true"
      className={className}
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <circle cx="12" cy="12" r="4" />
      <path d="M12 2v2" />
      <path d="M12 20v2" />
      <path d="m4.93 4.93 1.41 1.41" />
      <path d="m17.66 17.66 1.41 1.41" />
      <path d="M2 12h2" />
      <path d="M20 12h2" />
      <path d="m6.34 17.66-1.41 1.41" />
      <path d="m19.07 4.93-1.41 1.41" />
    </svg>
  );
}

function MoonIcon({ className }: { className?: string }) {
  return (
    <svg
      aria-hidden="true"
      className={className}
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <path d="M20 14.5A8.5 8.5 0 0 1 9.5 4 7 7 0 1 0 20 14.5Z" />
    </svg>
  );
}

function SystemIcon({ className }: { className?: string }) {
  return (
    <svg
      aria-hidden="true"
      className={className}
      fill="none"
      viewBox="0 0 24 24"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    >
      <rect x="4" y="5" width="16" height="11" rx="2" />
      <path d="M8 21h8" />
      <path d="M12 16v5" />
    </svg>
  );
}
