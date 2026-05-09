import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

class AlertDialogDemoScreen extends ConsumerWidget {
  const AlertDialogDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const LiqScaffold(
      appBar: LiqAppBar(title: Text('Alert Dialogs')),
      body: SingleChildScrollView(child: AlertDialogDemoBody()),
    );
  }
}

/// Body-only widget rendering every alert-dialog variant section.
/// Used standalone via [AlertDialogDemoScreen] and inside the combined
/// `DialogsSheetsAllInOneDemoScreen`.
class AlertDialogDemoBody extends ConsumerWidget {
  const AlertDialogDemoBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          _Section(
            title: 'Simple Alert',
            child: LiqButton(
              label: 'Show Simple Alert',
              onPressed: () => _showSimpleAlert(context),
            ),
          ),
          _Section(
            title: 'Two-Button Alert',
            child: LiqButton(
              label: 'Show Two-Button Alert',
              onPressed: () => _showTwoButtonAlert(context),
            ),
          ),
          _Section(
            title: 'Three-Button Alert',
            child: LiqButton(
              label: 'Show Three-Button Alert',
              onPressed: () => _showThreeButtonAlert(context),
            ),
          ),
          _Section(
            title: 'Destructive Alert',
            child: LiqButton(
              label: 'Show Destructive Alert',
              destructive: true,
              onPressed: () => _showDestructiveAlert(context),
            ),
          ),
          _Section(
            title: 'Text Input Alert',
            child: LiqButton(
              label: 'Show Text Input Alert',
              onPressed: () => _showTextInputAlert(context),
            ),
          ),
          _Section(
            title: 'Password Alert',
            child: LiqButton(
              label: 'Show Password Alert',
              onPressed: () => _showPasswordAlert(context),
            ),
          ),
          _Section(
            title: 'Error Alert',
            child: LiqButton(
              label: 'Show Error Alert',
              destructive: true,
              onPressed: () => _showErrorAlert(context),
            ),
          ),
          _Section(
            title: 'Long Message Alert',
            child: LiqButton(
              label: 'Show Long Message',
              onPressed: () => _showLongMessageAlert(context),
            ),
          ),
          _Section(
            title: 'Custom Content Alert',
            child: LiqButton(
              label: 'Show Custom Content',
              style: LiqButtonStyle.borderedSecondary,
              onPressed: () => _showCustomContentAlert(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showSimpleAlert(BuildContext context) {
    LiqAlert.showMessage(
      context: context,
      title: 'Success',
      description: 'Your changes have been saved.',
      onPressed: () => LiqToastOverlay.show(context, 'Alert dismissed'),
    );
  }

  Future<void> _showTwoButtonAlert(BuildContext context) async {
    final result = await LiqAlert.showConfirmation(
      context: context,
      title: 'Save Changes?',
      description: 'You have unsaved changes. Would you like to save them?',
      confirmText: 'Save',
      cancelText: 'Discard',
    );

    if (context.mounted) {
      LiqToastOverlay.show(
        context,
        result == true ? 'Changes saved' : 'Changes discarded',
      );
    }
  }

  void _showThreeButtonAlert(BuildContext context) {
    LiqAlert.show<void>(
      context: context,
      title: 'Replace Existing File?',
      description: 'A file with this name already exists. What would you like to do?',
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'Cancel',
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Cancelled');
          },
        ),
        LiqAlertAction(
          label: 'Replace',
          style: LiqAlertActionStyle.destructive,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'File replaced');
          },
        ),
        LiqAlertAction(
          label: 'Keep Both',
          style: LiqAlertActionStyle.filled,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Both files kept');
          },
        ),
      ],
    );
  }

  Future<void> _showDestructiveAlert(BuildContext context) async {
    final result = await LiqAlert.showConfirmation(
      context: context,
      title: 'Delete Item?',
      description: 'This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDestructive: true,
    );

    if (context.mounted && result == true) {
      LiqToastOverlay.show(
        context,
        'Item deleted',
        variant: LiqToastVariant.error,
      );
    }
  }

  Future<void> _showTextInputAlert(BuildContext context) async {
    final name = await LiqTextInputDialog.show(
      context: context,
      title: 'Enter Name',
      description: 'Please enter your name',
      placeholder: 'John Doe',
      confirmText: 'Submit',
      validator: (value) {
        if (value == null || value.isEmpty) return 'Name is required';
        if (value.length < 3) return 'Name must be at least 3 characters';
        return null;
      },
    );

    if (context.mounted && name != null) {
      LiqToastOverlay.show(context, 'Hello, $name!');
    }
  }

  Future<void> _showPasswordAlert(BuildContext context) async {
    final password = await LiqTextInputDialog.show(
      context: context,
      title: 'Enter Password',
      description: 'Please enter your password to continue',
      placeholder: 'Password',
      obscureText: true,
      confirmText: 'Authenticate',
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
    );

    if (context.mounted && password != null) {
      LiqToastOverlay.show(context, 'Authentication successful');
    }
  }

  void _showErrorAlert(BuildContext context) {
    LiqAlert.showError(
      context: context,
      title: 'Error',
      description:
          'Unable to connect to the server. Please check your internet connection and try again.',
      buttonText: 'Dismiss',
    );
  }

  void _showLongMessageAlert(BuildContext context) {
    LiqAlert.showMessage(
      context: context,
      title: 'Terms of Service',
      description: 'By using this application, you agree to our terms of service '
          'and privacy policy. These terms may be updated from time to time '
          'without prior notice. Your continued use of the application '
          'constitutes acceptance of any changes.',
    );
  }

  void _showCustomContentAlert(BuildContext context) {
    LiqAlert.show<void>(
      context: context,
      title: 'Storage Usage',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 150,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _StorageRow(
                  label: 'Photos',
                  value: 0.4,
                  color: context.appleColors.blue,
                ),
                _StorageRow(
                  label: 'Apps',
                  value: 0.3,
                  color: context.appleColors.red,
                ),
                _StorageRow(
                  label: 'System',
                  value: 0.2,
                  color: context.appleColors.gray,
                ),
                _StorageRow(
                  label: 'Other',
                  value: 0.1,
                  color: context.appleColors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '32 GB of 128 GB Used',
            style: TextStyle(
              fontSize: 14,
              color: context.appleColors.gray,
            ),
          ),
        ],
      ),
      actions: <LiqAlertAction>[
        LiqAlertAction(
          label: 'OK',
          onPressed: () => Navigator.of(context).pop(),
        ),
        LiqAlertAction(
          label: 'Manage Storage',
          style: LiqAlertActionStyle.filled,
          onPressed: () {
            Navigator.of(context).pop();
            LiqToastOverlay.show(context, 'Opening storage settings');
          },
        ),
      ],
      layout: LiqAlertActionLayout.sideBySide,
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StorageRow extends StatelessWidget {
  const _StorageRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: context.appleColors.label,
            ),
          ),
        ),
        Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: 14,
            color: context.appleColors.gray,
          ),
        ),
      ],
    );
  }
}
