import 'package:liqkit_ui_icons/liqkit_ui_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:liqkit_ui/liqkit_ui.dart';


class TextFieldDemoScreen extends ConsumerStatefulWidget {
  const TextFieldDemoScreen({super.key});

  @override
  ConsumerState<TextFieldDemoScreen> createState() =>
      _TextFieldDemoScreenState();
}

class _TextFieldDemoScreenState extends ConsumerState<TextFieldDemoScreen> {
  final TextEditingController _basicController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _multilineController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // Manual validation state
  final TextEditingController _vUsernameController = TextEditingController();
  final TextEditingController _vEmailController = TextEditingController();
  final TextEditingController _vAgeController = TextEditingController();
  String? _vUsernameError;
  String? _vEmailError;
  String? _vAgeError;

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _searchController.addListener(() => setState(() {}));
    _multilineController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _basicController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _multilineController.dispose();
    _searchController.dispose();
    _vUsernameController.dispose();
    _vEmailController.dispose();
    _vAgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiqScaffold(
      appBar: const LiqAppBar(title: Text('Text Fields')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Section(
              title: 'Surface Variants',
              description:
                  'Both `LiqTextFieldVariant` values — filled (rounded '
                  'system-fill surface) and plain (transparent row).',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: TextEditingController(),
                    placeholder: 'Filled (default)',
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    placeholder: 'Plain',
                    variant: LiqTextFieldVariant.plain,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Basic',
              description: 'Plain text input with placeholder, label, and trailing icon variants.',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: _basicController,
                    placeholder: 'Enter some text',
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    labelText: 'With Label',
                    placeholder: 'Enter your name',
                    prefixIcon: Icon(
                      LiqMaterialIcons.person,
                      size: 20,
                      color: context.appleColors.gray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    placeholder: 'With suffix icon',
                    suffixIcon: Icon(
                      LiqMaterialIcons.checkCircle,
                      size: 20,
                      color: context.appleColors.green,
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Form Fields',
              description:
                  'Common keyboard types for email, phone, URL, and number inputs.',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    placeholder: 'john.doe@example.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(LiqMaterialIcons.email,
                        size: 20, color: context.appleColors.gray),
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    placeholder: '(555) 123-4567',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(LiqIcons.phone,
                        size: 20, color: context.appleColors.gray),
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    labelText: 'Website',
                    placeholder: 'https://example.com',
                    keyboardType: TextInputType.url,
                    prefixIcon: Icon(LiqIcons.link,
                        size: 20, color: context.appleColors.gray),
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    labelText: 'Age',
                    placeholder: '25',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    prefixIcon: Icon(LiqMaterialIcons.cake,
                        size: 20, color: context.appleColors.gray),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Search Field',
              description:
                  'Search input with built-in clear button and live result list.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  LiqSearchField(
                    controller: _searchController,
                    placeholder: 'Search for items...',
                  ),
                  if (_searchController.text.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 16),
                    Text(
                      'Searching for "${_searchController.text}"',
                      style: context.textStyles.footnote.secondary,
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: LiqCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: <Widget>[
                              Icon(LiqIcons.search,
                                  size: 16, color: context.appleColors.gray),
                              const SizedBox(width: 8),
                              Text(
                                'Result ${i + 1} for "${_searchController.text}"',
                                style: context.textStyles.body,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
            _Section(
              title: 'Secure Field',
              description:
                  'Password field with visibility toggle and live strength meter.',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    placeholder: 'Enter your password',
                    obscureText: !_showPassword,
                    prefixIcon: Icon(LiqIcons.lock,
                        size: 20, color: context.appleColors.gray),
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _showPassword = !_showPassword),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          _showPassword
                              ? LiqMaterialIcons.visibilityOff
                              : LiqMaterialIcons.visibility,
                          size: 20,
                          color: context.appleColors.gray,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    labelText: 'Confirm Password',
                    placeholder: 'Re-enter your password',
                    obscureText: true,
                    prefixIcon: Icon(LiqMaterialIcons.lockOutline,
                        size: 20, color: context.appleColors.gray),
                  ),
                  if (_passwordController.text.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 16),
                    _passwordStrength(),
                  ],
                ],
              ),
            ),
            _Section(
              title: 'Multiline',
              description: 'Expandable text area with character counter.',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: _multilineController,
                    labelText: 'Comments',
                    placeholder: 'Enter your comments here...',
                    maxLines: 5,
                    minLines: 3,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_multilineController.text.length} characters',
                      style: context.textStyles.caption1.secondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    labelText: 'Bio',
                    placeholder: 'Tell us about yourself...',
                    minLines: 4,
                    maxLines: 8,
                    maxLength: 200,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Custom Styled',
              description: 'Text fields with non-default text styles and alignment.',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: TextEditingController(),
                    placeholder: 'Large text input',
                    style: context.textStyles.title3,
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    placeholder: 'Blue themed input',
                    style: TextStyle(color: context.appleColors.blue),
                    prefixIcon: Icon(LiqIcons.palette,
                        size: 20, color: context.appleColors.blue),
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    placeholder: 'Centered text',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Validation',
              description: 'Inline error text driven by submit-time validators.',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: _vUsernameController,
                    labelText: 'Username',
                    placeholder: 'Enter username',
                    errorText: _vUsernameError,
                    onChanged: (_) {
                      if (_vUsernameError != null) {
                        setState(() => _vUsernameError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: _vEmailController,
                    labelText: 'Email',
                    placeholder: 'Enter email',
                    keyboardType: TextInputType.emailAddress,
                    errorText: _vEmailError,
                    onChanged: (_) {
                      if (_vEmailError != null) {
                        setState(() => _vEmailError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: _vAgeController,
                    labelText: 'Age',
                    placeholder: 'Enter age',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    errorText: _vAgeError,
                    onChanged: (_) {
                      if (_vAgeError != null) {
                        setState(() => _vAgeError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: LiqButton(
                      label: 'Submit Form',
                      onPressed: _validateAndSubmit,
                    ),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'Input Formatters',
              description:
                  'Phone number, credit card, date, and currency formatters.',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: TextEditingController(),
                    labelText: 'Phone Number',
                    placeholder: '(555) 123-4567',
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      _PhoneNumberFormatter(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    labelText: 'Credit Card',
                    placeholder: '1234 5678 9012 3456',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      _CreditCardFormatter(),
                    ],
                    prefixIcon: Icon(LiqMaterialIcons.creditCard,
                        size: 20, color: context.appleColors.gray),
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    labelText: 'Date',
                    placeholder: 'MM/DD/YYYY',
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      _DateFormatter(),
                    ],
                    prefixIcon: Icon(LiqMaterialIcons.calendarToday,
                        size: 20, color: context.appleColors.gray),
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    labelText: 'Currency',
                    placeholder: r'$0.00',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    prefixIcon: Icon(LiqMaterialIcons.attachMoney,
                        size: 20, color: context.appleColors.gray),
                  ),
                ],
              ),
            ),
            _Section(
              title: 'States',
              description: 'Disabled, read-only, and error display.',
              child: Column(
                children: <Widget>[
                  LiqTextField(
                    controller: TextEditingController(text: 'Disabled value'),
                    placeholder: 'Disabled',
                    enabled: false,
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller:
                        TextEditingController(text: 'Read-only value'),
                    placeholder: 'Read only',
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  LiqTextField(
                    controller: TextEditingController(),
                    placeholder: 'Field with error',
                    errorText: 'This field has an error',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    String? usernameError;
    String? emailError;
    String? ageError;
    final username = _vUsernameController.text;
    final email = _vEmailController.text;
    final age = _vAgeController.text;
    if (username.isEmpty) {
      usernameError = 'Username is required';
    } else if (username.length < 3) {
      usernameError = 'Username must be at least 3 characters';
    }
    if (email.isEmpty) {
      emailError = 'Email is required';
    } else if (!email.contains('@')) {
      emailError = 'Please enter a valid email';
    }
    if (age.isEmpty) {
      ageError = 'Age is required';
    } else {
      final n = int.tryParse(age);
      if (n == null || n < 18) ageError = 'Must be 18 or older';
    }
    setState(() {
      _vUsernameError = usernameError;
      _vEmailError = emailError;
      _vAgeError = ageError;
    });
    if (usernameError == null && emailError == null && ageError == null) {
      LiqToastOverlay.show(context, 'Form is valid!',
          variant: LiqToastVariant.success);
    }
  }

  Widget _passwordStrength() {
    final password = _passwordController.text;
    final strength = _calculatePasswordStrength(password);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Password Strength',
            style: context.textStyles.footnote.secondary),
        const SizedBox(height: 8),
        Row(
          children: List<Widget>.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: index < strength
                      ? _strengthColor(strength)
                      : context.appleColors.gray.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          _strengthText(strength),
          style: context.textStyles.caption1.copyWith(
            color: _strengthColor(strength),
          ),
        ),
      ],
    );
  }

  int _calculatePasswordStrength(String password) {
    if (password.length < 6) return 0;
    if (password.length < 8) return 1;
    if (password.length < 10 && password.contains(RegExp(r'[0-9]'))) return 2;
    if (password.length >= 10 &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 4;
    }
    return 3;
  }

  Color _strengthColor(int strength) => switch (strength) {
        0 || 1 => context.appleColors.red,
        2 => context.appleColors.orange,
        3 => context.appleColors.yellow,
        4 => context.appleColors.green,
        _ => context.appleColors.gray,
      };

  String _strengthText(int strength) => switch (strength) {
        0 || 1 => 'Weak',
        2 => 'Fair',
        3 => 'Good',
        4 => 'Strong',
        _ => '',
      };
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();
    var digitCount = 0;
    for (var i = 0; i < text.length; i++) {
      if (digitCount == 0) buffer.write('(');
      if (digitCount == 3) buffer.write(') ');
      if (digitCount == 6) buffer.write('-');
      buffer.write(text[i]);
      digitCount++;
      if (digitCount >= 10) break;
    }
    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _CreditCardFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();
    var digitCount = 0;
    for (var i = 0; i < text.length; i++) {
      if (digitCount > 0 && digitCount % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
      digitCount++;
      if (digitCount >= 16) break;
    }
    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    final buffer = StringBuffer();
    var digitCount = 0;
    for (var i = 0; i < text.length; i++) {
      if (digitCount == 2 || digitCount == 4) buffer.write('/');
      buffer.write(text[i]);
      digitCount++;
      if (digitCount >= 8) break;
    }
    final string = buffer.toString();
    return TextEditingValue(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: context.textStyles.title3.copyWith(
              fontWeight: LiqAppleTypography.semibold,
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(description!, style: context.textStyles.subheadline.secondary),
          ],
          const SizedBox(height: 16),
          LiqCard(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}
