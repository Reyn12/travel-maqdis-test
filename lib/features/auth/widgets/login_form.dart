import 'package:flutter/material.dart';
import 'package:maqdis_connect/core/common/widgets/w_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    super.key,
    required this.onPressed,
  });

  final dynamic Function() onPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<LoginForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<LoginForm> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          WTextField(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: widget.emailController,
            hintText: 'Masukkan alamat email kamu',
          ),
          const SizedBox(height: 20),
          WTextField(
            label: 'Kata Sandi',
            textButton: true,
            buttonText: 'Lupa Kata Sandi?',
            onPressed: widget.onPressed,
            keyboardType: TextInputType.visiblePassword,
            controller: widget.passwordController,
            hintText: 'Masukkan kata sandi kamu',
            obscureText: obscureText,
            suffixIcon: IconButton(
              onPressed: () => setState(
                () => obscureText = !obscureText,
              ),
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
