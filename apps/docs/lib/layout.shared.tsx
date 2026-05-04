import type { BaseLayoutProps } from 'fumadocs-ui/layouts/shared';
import { DocsToolbar } from '@/components/docs-toolbar';

export const baseOptions: BaseLayoutProps = {
  nav: {
    title: 'liqkit_ui',
    url: '/',
  },
  searchToggle: {
    components: {
      lg: <DocsToolbar variant="lg" />,
      sm: <DocsToolbar variant="sm" />,
    },
  },
  themeSwitch: {
    enabled: false,
  },
  links: [
    { text: 'Docs', url: '/docs' },
    {
      text: 'GitHub',
      url: 'https://github.com/forus-labs/liqkit_ui',
      external: true,
    },
  ],
};
