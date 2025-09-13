import 'package:blood_glucose_monitor/pages/auth/signin.dart';
import 'package:blood_glucose_monitor/pages/auth/signup.dart';
import 'package:blood_glucose_monitor/theme/styles.dart';
import 'package:blood_glucose_monitor/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: GradientBackground(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primaryFixedDim,
            theme.colorScheme.primary,
          ],
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                height: constraints.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(
                          'assets/logo1.svg',
                          height: constraints.height * 0.24,
                        ),
                        SizedBox(height: 36.0),
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'BLOOD GLUCOSE',
                                style: theme.textTheme.displaySmall,
                              ),
                              TextSpan(
                                text: '\nMONITOR',
                                style: theme.textTheme.displayLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => SignInForm()),
                              );
                            },
                            style: AppButtonStylesLight.filled.copyWith(
                              backgroundColor: WidgetStateProperty.all(
                                theme.colorScheme.surface,
                              ),
                              overlayColor: WidgetStateProperty.all(
                                theme.colorScheme.primaryContainer,
                              ),
                              foregroundColor: WidgetStateProperty.all(
                                theme.colorScheme.onSurface,
                              ),
                              textStyle: WidgetStateProperty.all(
                                theme.textTheme.titleMedium,
                              ),
                            ),
                            child: Text('Sign in'),
                          ),
                        ),

                        SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => SignUpForm()),
                              );
                            },
                            style: AppButtonStylesLight.text.copyWith(
                              foregroundColor: WidgetStateProperty.all(
                                theme.colorScheme.surface,
                              ),
                              overlayColor: WidgetStateProperty.all(
                                theme.colorScheme.primaryContainer,
                              ),
                            ),
                            child: Text('Sign up'),
                          ),
                        ),
                      ],
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
