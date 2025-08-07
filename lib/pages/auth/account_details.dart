import 'package:blood_glucose_monitor/controllers/auth_controller.dart';
import 'package:blood_glucose_monitor/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountDetailsForm extends StatefulWidget {
  const AccountDetailsForm({required this.email, super.key});

  final String email;

  @override
  State<AccountDetailsForm> createState() => _AccountDetailsFormState();
}

class _AccountDetailsFormState extends State<AccountDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AuthController _authController;
  late AuthState _authState;

  @override
  void initState() {
    super.initState();

    _authController = Provider.of<AuthController>(context, listen: false);
    _authController.addListener(() {
      if (_authState.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_authState.message)));
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    _authState = context.watch<AuthController>().state;

    return Scaffold(
      appBar: AppBar(title: const Text('Account details')),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(60),
                              onTap: () {
                                // Add image picker logic here
                              },
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundColor:
                                        theme.colorScheme.surfaceVariant,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 80,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  IconButton.filled(
                                    onPressed: () {},
                                    icon: Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Enter your account details',
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a username';
                              }
                              if (value.trim().length < 3 ||
                                  value.trim().length > 64) {
                                return 'Must be 3-64 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
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
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 8) {
                                return 'Must be at least 8 characters long';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final creds = await _authController.signUp(
                            email: widget.email,
                            username: _usernameController.text.trim(),
                            password: _passwordController.text.trim(),
                          );

                          if (creds != null && context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => HomePage()),
                              (route) => false,
                            );
                          }
                        }
                      },
                      child: _authState.isLoading
                          ? SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: const CircularProgressIndicator(
                                padding: EdgeInsets.all(4.0),
                                strokeWidth: 3.0,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Continue'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
