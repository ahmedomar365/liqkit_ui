import defaultMdxComponents from 'fumadocs-ui/mdx';
import { LiqPreview } from '@/components/liq-preview';
import { CodeSnippet } from '@/components/code-snippet';

export const mdxComponents = {
  ...defaultMdxComponents,
  LiqPreview,
  CodeSnippet,
};

// Required by Next 16 MDX provider:
export function useMDXComponents(components: Record<string, unknown>) {
  return { ...mdxComponents, ...components };
}
