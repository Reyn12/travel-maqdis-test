part of 'imports/login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginScreen> {
  final loginController = Get.put(LoginController());
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSecurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Expanded(
                    child: Center(
                      child:
                          Image.asset('assets/logo_maqdis_new.png', height: 48),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Selamat Datang Kembali',
                      style: GoogleFonts.lato(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Center(
                    child: Text(
                      'Masukkan detail kamu',
                      style: GoogleFonts.lato(
                        color: const Color(0xFFB1B1B1),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  WCustomButton(
                    onPressed: () {
                      loginController.signInWithGoogle();
                    },
                    leading: true,
                    border:
                        Border.all(color: const Color(0xFFE9E9E9), width: 1.5),
                    buttonColor: Colors.white,
                    verticalPadding: 14,
                    fontColor: Colors.black,
                    fontSize: 16,
                    radius: 14,
                    buttonText: 'Masuk dengan Google',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFB1B1B1),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'atau',
                          style: GoogleFonts.lato(
                            color: const Color(0xFFB1B1B1),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFB1B1B1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  LoginForm(
                    emailController: email,
                    passwordController: password,
                    formKey: formKey,
                    onPressed: () {
                      Get.offAll(
                        () => const ForgotPasswordScreen(),
                        transition: Transition.fadeIn,
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  WCustomButton(
                    onPressed: _onLoginPressed,
                    verticalPadding: 14,
                    fontSize: 16,
                    radius: 14,
                    buttonText: 'Masuk',
                  ),
                  const SizedBox(height: 25),
                  Align(
                    child: WTextButton(
                      leadingText: 'Belum punya akun?',
                      buttonText: 'Daftar disini',
                      onPressed: () {
                        Get.offAll(
                          () => const RegisterLandingScreen(),
                          transition: Transition.fadeIn,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
            Obx(() {
              if (loginController.isLoading.value) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: WEnumLoadingAnim()),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  void _onLoginPressed() {
    if (formKey.currentState!.validate()) {
      loginController.login(email.text, password.text);
    }
  }
}
