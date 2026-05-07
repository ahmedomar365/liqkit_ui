import { act, render, screen } from '@testing-library/react';
import { beforeEach, describe, it, expect, vi } from 'vitest';
import { LiqPreview } from '../liq-preview';

let mockedResolvedTheme = 'light';

vi.mock('next-themes', () => ({
  useTheme: () => ({ resolvedTheme: mockedResolvedTheme }),
}));

describe('LiqPreview', () => {
  beforeEach(() => {
    mockedResolvedTheme = 'light';
  });

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

  it('passes dark theme through to the Flutter snippet iframe', async () => {
    mockedResolvedTheme = 'dark';

    render(
      <LiqPreview
        component="sheet"
        variant="full-screen"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );

    const iframe = await screen.findByTitle(
      'liqkit_ui — sheet/full-screen',
    );
    expect(iframe).toHaveAttribute(
      'src',
      'https://snippets.example.com/index.html?theme=dark&v=1#/sheet/full-screen',
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

  it('uses a taller initial frame for card examples with footers', () => {
    render(
      <LiqPreview
        component="card"
        variant="with-footer"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );

    const iframe = screen.getByTitle(
      'liqkit_ui — card/with-footer',
    ) as HTMLIFrameElement;
    expect(iframe.height).toBe('260');
  });

  it('uses a taller initial frame for expanded collapsible content', () => {
    render(
      <LiqPreview
        component="collapsible"
        variant="expanded"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );

    const iframe = screen.getByTitle(
      'liqkit_ui — collapsible/expanded',
    ) as HTMLIFrameElement;
    expect(iframe.height).toBe('220');
  });

  it('uses a responsive initial frame for collapsed drawer rails', () => {
    render(
      <LiqPreview
        component="drawer"
        variant="collapsed"
        snippetsBaseUrl="https://snippets.example.com"
      />,
    );

    const iframe = screen.getByTitle(
      'liqkit_ui — drawer/collapsed',
    ) as HTMLIFrameElement;
    expect(iframe.height).toBe('320');
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
