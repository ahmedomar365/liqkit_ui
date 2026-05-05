import { act, render, screen } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { LiqPreview } from '../liq-preview';

vi.mock('next-themes', () => ({
  useTheme: () => ({ resolvedTheme: 'light' }),
}));

describe('LiqPreview', () => {
  it('renders an iframe whose src matches the manifest path', () => {
    render(
      <LiqPreview
        component="button"
        variant="regular"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );
    const iframe = screen.getByTitle('liqkit_ui — button/regular');
    expect(iframe.tagName).toBe('IFRAME');
    expect(iframe).toHaveAttribute(
      'src',
      'https://snippets.example.com/index.html?theme=light&v=1#/button/regular',
    );
  });

  it('updates iframe height when a liq.height message arrives', async () => {
    render(
      <LiqPreview
        component="button"
        variant="regular"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );
    const iframe = screen.getByTitle(
      'liqkit_ui — button/regular',
    ) as HTMLIFrameElement;
    expect(iframe.height).toBe('120');
    act(() => {
      window.dispatchEvent(
        new MessageEvent('message', {
          data: { type: 'liq.height', px: 360 },
          origin: 'https://snippets.example.com',
        }),
      );
    });
    expect(iframe.height).toBe('360');
  });

  it('ignores liq.height messages from a different origin', () => {
    render(
      <LiqPreview
        component="button"
        variant="regular"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );
    const iframe = screen.getByTitle(
      'liqkit_ui — button/regular',
    ) as HTMLIFrameElement;
    window.dispatchEvent(
      new MessageEvent('message', {
        data: { type: 'liq.height', px: 9999 },
        origin: 'https://attacker.example',
      }),
    );
    expect(iframe.height).toBe('120');
  });
});
