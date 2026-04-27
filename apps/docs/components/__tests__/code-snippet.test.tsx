import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { CodeSnippet } from '../code-snippet';

describe('CodeSnippet', () => {
  it('renders the source as a <pre>', () => {
    const json = {
      file: 'a/b.dart',
      language: 'dart',
      source: 'final x = 1;\nfinal y = 2;\n',
      highlights: [{ start: 1, end: 1 }],
    };
    render(<CodeSnippet snippet={json} />);
    const pre = screen.getByTestId('code-snippet');
    expect(pre.textContent).toContain('final x = 1;');
    expect(pre.textContent).toContain('final y = 2;');
  });

  it('annotates highlighted lines with data-highlight', () => {
    const json = {
      file: 'a/b.dart',
      language: 'dart',
      source: 'a\nb\nc\n',
      highlights: [{ start: 2, end: 2 }],
    };
    render(<CodeSnippet snippet={json} />);
    const lines = screen.getAllByTestId('code-line');
    expect(lines).toHaveLength(3);
    expect(lines[0]).not.toHaveAttribute('data-highlight');
    expect(lines[1]).toHaveAttribute('data-highlight', 'true');
    expect(lines[2]).not.toHaveAttribute('data-highlight');
  });
});
