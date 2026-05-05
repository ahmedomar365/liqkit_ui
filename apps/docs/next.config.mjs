import { createMDX } from 'fumadocs-mdx/next';

const withMDX = createMDX();

const SNIPPETS_URL = process.env.NEXT_PUBLIC_SNIPPETS_URL;
if (!SNIPPETS_URL || !/^https?:\/\//.test(SNIPPETS_URL)) {
  // Fail loud and early — the iframe will be broken if this is missing.
  // Allow the dev command to proceed with a default for local dev.
  if (process.env.NODE_ENV === 'production') {
    throw new Error(
      'NEXT_PUBLIC_SNIPPETS_URL must be set to a https:// URL when building for production.',
    );
  }
}

/** @type {import('next').NextConfig} */
const config = {
  reactStrictMode: true,
  output: 'standalone',
  pageExtensions: ['ts', 'tsx', 'mdx'],
  allowedDevOrigins: ['127.0.0.1'],
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'Cross-Origin-Opener-Policy',
            value: 'same-origin',
          },
          {
            key: 'Cross-Origin-Embedder-Policy',
            value: 'credentialless',
          },
          {
            key: 'Permissions-Policy',
            value: 'cross-origin-isolated=(self)',
          },
        ],
      },
    ];
  },
};

export default withMDX(config);
