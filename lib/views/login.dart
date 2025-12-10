// lib/main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SecureUrlApp());
}

class SecureUrlApp extends StatelessWidget {
  const SecureUrlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureURL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF071426),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/home': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/reset': (_) => const ResetPasswordPage(),
      },
    );
  }
}

/* ---------------------- LOGIN / AUTH SCREEN ---------------------- */
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final TextEditingController emailcntl = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  final TextEditingController nameCntl = TextEditingController();

  int selectedTab = 0; // 0: Login, 1: Sign Up, 2: Reset
  bool obscurePassword = true;

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfo(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Basic email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Basic password policy validation used for signup and login (login only checks non-empty + length)
  String? _validatePasswordForSignup(String password) {
    if (password.isEmpty) return 'Password cannot be empty';
    if (password.length < 8) return 'Password must be at least 8 characters long';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Include at least one uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Include at least one lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'Include at least one number';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) return 'Include at least one special character';
    return null;
  }

  void _handlePrimaryAction() {
    final email = emailcntl.text.trim();
    final password = pass.text;

    if (selectedTab == 0) {
      // LOGIN logic
      if (email.isEmpty) {
        _showError('Email cannot be empty');
        return;
      }
      if (!_isValidEmail(email)) {
        _showError('Please enter a valid email address');
        return;
      }
      if (password.isEmpty) {
        _showError('Password cannot be empty');
        return;
      }
      if (password.length < 6) {
        _showError('Password must be at least 6 characters');
        return;
      }

      // TODO: replace with real authentication call
      _showInfo('Login successful — navigating to Home');
      Navigator.pushReplacementNamed(context, '/home');
    } else if (selectedTab == 1) {
      // SIGN UP logic
      final name = nameCntl.text.trim();
      final confirm = confirmPass.text;

      if (name.isEmpty) {
        _showError('Name cannot be empty');
        return;
      }
      if (email.isEmpty) {
        _showError('Email cannot be empty');
        return;
      }
      if (!_isValidEmail(email)) {
        _showError('Please enter a valid email address');
        return;
      }

      final passError = _validatePasswordForSignup(password);
      if (passError != null) {
        _showError(passError);
        return;
      }

      if (password != confirm) {
        _showError('Passwords do not match');
        return;
      }

      // TODO: call register API
      _showInfo('Account created successfully. You can now login.');
      // Optionally auto-login or navigate:
      setState(() {
        selectedTab = 0;
        pass.clear();
        confirmPass.clear();
      });
    } else {
      // RESET logic (selectedTab == 2)
      if (email.isEmpty) {
        _showError('Email cannot be empty');
        return;
      }
      if (!_isValidEmail(email)) {
        _showError('Please enter a valid email address');
        return;
      }

      // TODO: call password-reset API to send email link
      _showInfo('If that email exists, a password reset link has been sent.');
      // Optionally navigate to Reset page with more flow:
      // Navigator.pushNamed(context, '/reset');
    }
  }

  @override
  Widget build(BuildContext context) {
    // button label depending on selectedTab
    final primaryButtonText = selectedTab == 0
        ? 'Login'
        : selectedTab == 1
            ? 'Sign Up'
            : 'Send Reset Link';

    return Scaffold(
      // no appBar to match your design
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.8, -0.6),
            radius: 1.2,
            colors: [
              const Color(0xFF041022),
              const Color(0xFF071626).withOpacity(0.95),
              const Color(0xFF081826).withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.12),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: Colors.cyan.withOpacity(0.05)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.shield_outlined,
                      size: 36,
                      color: const Color(0xFF00E5FF),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'SecureURL',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00E5FF),
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Protect yourself from malicious links',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.65),
                  ),
                ),
                const SizedBox(height: 30),

                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF091018).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.03),
                            blurRadius: 1,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Authentication',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Sign in or create an account to get started',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.6)),
                          ),
                          const SizedBox(height: 18),

                          // Segmented control
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D1A22),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                _buildSegment('Login', 0),
                                _buildSegment('Sign Up', 1),
                                _buildSegment('Reset', 2),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),

                          // If Sign Up show name field
                          if (selectedTab == 1) ...[
                            const Padding(
                              padding: EdgeInsets.only(left: 6.0, bottom: 6),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            _buildTextField(
                              controller: nameCntl,
                              hint: 'Your full name',
                              prefix: Icons.person_outline,
                              obscure: false,
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Email field (used in all tabs)
                          const Padding(
                            padding: EdgeInsets.only(left: 6.0, bottom: 6),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          _buildTextField(
                            controller: emailcntl,
                            hint: 'Enter your email',
                            prefix: Icons.email_outlined,
                            obscure: false,
                          ),
                          const SizedBox(height: 14),

                          // Password field: hide for Reset tab
                          if (selectedTab != 2) ...[
                            const Padding(
                              padding: EdgeInsets.only(left: 6.0, bottom: 6),
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            _buildTextField(
                              controller: pass,
                              hint: selectedTab == 1
                                  ? 'Create a strong password'
                                  : 'Enter your password',
                              prefix: Icons.lock_outline,
                              obscure: obscurePassword,
                              showVisibilityToggle: true,
                              onToggleVisibility: () =>
                                  setState(() => obscurePassword = !obscurePassword),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Confirm password only for Sign Up
                          if (selectedTab == 1) ...[
                            const Padding(
                              padding: EdgeInsets.only(left: 6.0, bottom: 6),
                              child: Text(
                                'Confirm Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            _buildTextField(
                              controller: confirmPass,
                              hint: 'Re-enter password',
                              prefix: Icons.lock_outline,
                              obscure: true,
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Primary button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _handlePrimaryAction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00E5FF),
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                foregroundColor: Colors.black,
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              child: Text(primaryButtonText),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Small footer actions
                          if (selectedTab == 0) Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => setState(() => selectedTab = 1),
                                child: const Text('Create account'),
                              ),
                              TextButton(
                                onPressed: () => setState(() => selectedTab = 2),
                                child: const Text('Forgot password?'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegment(String label, int index) {
    final selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF071823) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? const Color(0xFF00E5FF) : Colors.white70,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? prefix,
    bool obscure = false,
    bool showVisibilityToggle = false,
    VoidCallback? onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefix == null
            ? null
            : Icon(prefix, color: Colors.white70, size: 20),
        suffixIcon: showVisibilityToggle
            ? IconButton(
                onPressed: onToggleVisibility,
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white54,
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF051219),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan.withOpacity(0.35)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailcntl.dispose();
    pass.dispose();
    confirmPass.dispose();
    nameCntl.dispose();
    super.dispose();
  }
}

/* ---------------------- PLACEHOLDER PAGES ---------------------- */



class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register (placeholder)')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This is a placeholder Register page.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            )
          ],
        ),
      ),
    );
  }
}

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password (placeholder)')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('This is a placeholder Reset Password flow.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            )
          ],
        ),
      ),
    );
  }
}
