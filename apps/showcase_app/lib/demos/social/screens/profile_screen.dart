import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';
import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';

import '../models/social_models.dart';
import '../models/social_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return LiqScaffold(
      appBar: LiqAppBar(
        title: Text(
          currentUser.username,
          style: context.textStyles.largeTitle.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        actions: <Widget>[
          LiqIconButton(icon: LiqIcons.menu, onPressed: () {}),
          const SizedBox(width: 12),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(child: _ProfileHeader(user: currentUser)),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  color: LiqColors.grey.withValues(alpha: 0.1),
                  child: Image.network(
                    'https://picsum.photos/200/200?random=${100 + index}',
                    fit: BoxFit.cover,
                  ),
                );
              },
              childCount: 12,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: LiqColors.grey.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(user.avatarUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _StatColumn(value: user.posts.toString(), label: 'Posts'),
                    _StatColumn(
                      value: _formatCount(user.followers),
                      label: 'Followers',
                    ),
                    _StatColumn(
                      value: _formatCount(user.following),
                      label: 'Following',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Text(
                user.displayName,
                style: context.textStyles.body.copyWith(
                  fontWeight: LiqAppleTypography.semibold,
                ),
              ),
              if (user.isVerified) ...<Widget>[
                const SizedBox(width: 4),
                Icon(
                  LiqMaterialIcons.verified,
                  size: 16,
                  color: context.appleColors.blue,
                ),
              ],
            ],
          ),
          if (user.bio.isNotEmpty) ...<Widget>[
            const SizedBox(height: 4),
            Text(user.bio, style: context.textStyles.body),
          ],
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: LiqButton(
                  label: 'Edit Profile',
                  fullWidth: true,
                  style: LiqButtonStyle.borderedSecondary,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LiqButton(
                  label: 'Share Profile',
                  fullWidth: true,
                  style: LiqButtonStyle.borderedSecondary,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: context.textStyles.title3.copyWith(
            fontWeight: LiqAppleTypography.bold,
          ),
        ),
        Text(label, style: context.textStyles.caption1.secondary),
      ],
    );
  }
}
