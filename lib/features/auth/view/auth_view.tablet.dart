import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../models/auth_failure.dart';

class AuthViewTablet extends ConsumerStatefulWidget {
  const AuthViewTablet({super.key});

  @override
  ConsumerState<AuthViewTablet> createState() => _AuthViewTabletState();
}

class _AuthViewTabletState extends ConsumerState<AuthViewTablet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _isSignUp = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = ref.read(authViewModelProvider.notifier);
    if (_isSignUp) {
      viewModel.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _displayNameController.text.trim().isEmpty
            ? null
            : _displayNameController.text.trim(),
      );
    } else {
      viewModel.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  String? _getErrorMessage(AuthFailure? failure) {
    if (failure == null) return null;
    return failure.when(
      invalidCredentials: () => 'Invalid email or password',
      emailAlreadyInUse: () => 'This email is already registered',
      weakPassword: () => 'Password is too weak',
      network: () => 'Network error. Please check your connection',
      unexpected: (message) => message ?? 'An unexpected error occurred',
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final isLoading = state.isLoading;
    final errorMessage = _getErrorMessage(state.failure);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      _isSignUp ? 'Create Account' : 'Welcome Back',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isSignUp
                          ? 'Sign up to get started'
                          : 'Sign in to continue',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 56),
                    if (_isSignUp)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: isIOS
                            ? CupertinoTextField(
                                controller: _displayNameController,
                                placeholder: 'Display Name (Optional)',
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              )
                            : TextFormField(
                                controller: _displayNameController,
                                decoration: InputDecoration(
                                  labelText: 'Display Name (Optional)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: isIOS
                          ? CupertinoTextField(
                              controller: _emailController,
                              placeholder: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            )
                          : TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28.0),
                      child: isIOS
                          ? CupertinoTextField(
                              controller: _passwordController,
                              placeholder: 'Password',
                              obscureText: _obscurePassword,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey6,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffix: CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                child: Icon(
                                  _obscurePassword
                                      ? CupertinoIcons.eye_slash
                                      : CupertinoIcons.eye,
                                ),
                              ),
                            )
                          : TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 56,
                      child: isIOS
                          ? CupertinoButton.filled(
                              onPressed: isLoading ? null : _handleSubmit,
                              child: isLoading
                                  ? const CupertinoActivityIndicator()
                                  : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
                            )
                          : ElevatedButton(
                              onPressed: isLoading ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
                            ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignUp = !_isSignUp;
                          if (state.failure != null) {
                            ref.read(authViewModelProvider.notifier).clearFailure();
                          }
                        });
                      },
                      child: Text(
                        _isSignUp
                            ? 'Already have an account? Sign In'
                            : 'Don\'t have an account? Sign Up',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

