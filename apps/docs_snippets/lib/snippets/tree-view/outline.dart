// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/widgets.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget treeViewOutlineBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<String?>(
        initial: 'ch1/intro',
        builder:
            (sel, set) => SizedBox(
              width: 320,
              // {@highlight}
              child: LiqTreeView<String>(
                selectedId: sel,
                onSelected: (id, _) => set(id),
                initialExpanded: const <String>{'ch1', 'ch2', 'ch3'},
                nodes: const <LiqTreeNode<String>>[
                  LiqTreeNode<String>(
                    id: 'ch1',
                    label: '1. Introduction',
                    children: <LiqTreeNode<dynamic>>[
                      LiqTreeNode<String>(
                        id: 'ch1/intro',
                        label: '1.1 Overview',
                      ),
                      LiqTreeNode<String>(id: 'ch1/scope', label: '1.2 Scope'),
                    ],
                  ),
                  LiqTreeNode<String>(
                    id: 'ch2',
                    label: '2. Foundations',
                    children: <LiqTreeNode<dynamic>>[
                      LiqTreeNode<String>(
                        id: 'ch2/colors',
                        label: '2.1 Colors',
                      ),
                      LiqTreeNode<String>(
                        id: 'ch2/typography',
                        label: '2.2 Typography',
                      ),
                      LiqTreeNode<String>(
                        id: 'ch2/spacing',
                        label: '2.3 Spacing',
                      ),
                    ],
                  ),
                  LiqTreeNode<String>(
                    id: 'ch3',
                    label: '3. Components',
                    children: <LiqTreeNode<dynamic>>[
                      LiqTreeNode<String>(
                        id: 'ch3/buttons',
                        label: '3.1 Buttons',
                      ),
                      LiqTreeNode<String>(id: 'ch3/forms', label: '3.2 Forms'),
                    ],
                  ),
                ],
              ),
              // {@endhighlight}
            ),
      ),
    ),
  );
}
