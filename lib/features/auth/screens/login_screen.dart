import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/sign_in_button.dart';
import 'package:reddit_tutorial/core/common/utils/lang/app_localizations.dart';
import 'package:reddit_tutorial/core/constants/constant.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGest(BuildContext context, WidgetRef ref) async {
    ref.read(authControllerProvider.notifier).signInAsGest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    final currenTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currenTheme.backgroundColor,
        actions: [
          TextButton(
            onPressed: () => signInAsGest(context, ref),
            child: Text('Skip'.tr(context)),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(height: 30),
              Image.asset(
                Constant.logoPath,
                width: 40,
              ),
              const SizedBox(height: 18),
              Text(
                'Dive into any thing'.tr(context),
                style:
                    const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Image.asset(
                Constant.loginEmotePath,
                width: 400,
              ),
              const SizedBox(height: 25),
              const SignInButton(),
            ]),
    );
  }
}
