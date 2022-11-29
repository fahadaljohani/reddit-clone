import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/common/sign_in_button.dart';
import 'package:reddit_tutorial/core/constants/constant.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.blackColor,
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
              const Text(
                'Dive into any thing',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
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
