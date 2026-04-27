import type { BaseLayoutProps } from 'fumadocs-ui/layouts/shared';

export const baseOptions: BaseLayoutProps = {
  nav: {
    title: 'liqkit_ui',
    url: '/',
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
