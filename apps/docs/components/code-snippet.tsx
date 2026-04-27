import type { ComponentProps } from 'react';

export interface SnippetJson {
  file: string;
  language: string;
  source: string;
  highlights: { start: number; end: number }[];
}

interface CodeSnippetProps extends ComponentProps<'pre'> {
  snippet: SnippetJson;
}

export function CodeSnippet({ snippet, className, ...rest }: CodeSnippetProps) {
  const rawLines = snippet.source.split('\n');
  // Drop the single trailing empty string that arises when source ends with \n
  const lines =
    rawLines.length > 0 && rawLines[rawLines.length - 1] === ''
      ? rawLines.slice(0, -1)
      : rawLines;
  const isHighlighted = (oneBasedLine: number) =>
    snippet.highlights.some(
      (h) => oneBasedLine >= h.start && oneBasedLine <= h.end,
    );

  return (
    <pre
      data-testid="code-snippet"
      className={`liq-code rounded-md border bg-fd-card p-4 font-mono text-sm ${className ?? ''}`}
      {...rest}
    >
      <code>
        {lines.map((line, i) => {
          const lineNo = i + 1;
          const highlighted = isHighlighted(lineNo);
          return (
            <span
              key={i}
              data-testid="code-line"
              {...(highlighted ? { 'data-highlight': 'true' } : {})}
              className={
                highlighted
                  ? 'block bg-fd-accent/10 -mx-4 px-4'
                  : 'block'
              }
            >
              {line || '​'}
            </span>
          );
        })}
      </code>
    </pre>
  );
}
