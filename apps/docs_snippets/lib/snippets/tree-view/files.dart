// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/material.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget treeViewFilesBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<String?>(
        initial: null,
        builder:
            (sel, set) => SizedBox(
              width: 320,
              // {@highlight}
              child: LiqTreeView<String>(
                selectedId: sel,
                onSelected: (id, _) => set(id),
                initialExpanded: const <String>{'src', 'src/components'},
                nodes: const <LiqTreeNode<String>>[
                  LiqTreeNode<String>(
                    id: 'src',
                    label: 'src',
                    icon: Icons.folder_outlined,
                    children: <LiqTreeNode<dynamic>>[
                      LiqTreeNode<String>(
                        id: 'src/main.dart',
                        label: 'main.dart',
                        icon: Icons.description_outlined,
                      ),
                      LiqTreeNode<String>(
                        id: 'src/components',
                        label: 'components',
                        icon: Icons.folder_outlined,
                        children: <LiqTreeNode<dynamic>>[
                          LiqTreeNode<String>(
                            id: 'src/components/button.dart',
                            label: 'button.dart',
                            icon: Icons.description_outlined,
                          ),
                          LiqTreeNode<String>(
                            id: 'src/components/toggle.dart',
                            label: 'toggle.dart',
                            icon: Icons.description_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                  LiqTreeNode<String>(
                    id: 'pubspec.yaml',
                    label: 'pubspec.yaml',
                    icon: Icons.description_outlined,
                  ),
                ],
              ),
              // {@endhighlight}
            ),
      ),
    ),
  );
}
