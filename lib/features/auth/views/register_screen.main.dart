part of 'imports/register_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _controller = Get.put(RegisterController());
  bool obscureText = true;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WCustomAppBar(
        customBackButton: true,
        customAction: true,
        backgroundColor: Colors.white,
        onPressed: () {
          if (_controller.currentStep.value != RegisterStep.name) {
            _controller.previousStep();
          } else {
            _controller.resetStep();
            Get.back();
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tampilkan form sesuai tahap registrasi
            Obx(() {
              switch (_controller.currentStep.value) {
                case RegisterStep.name:
                  return RegisterForm(
                    controller: _controller.nameController,
                    hintText: 'Masukkan nama anda disini',
                    labelTitle: 'Masukkan nama lengkap anda',
                    labelSubtitle: 'Pastikan nama sesuai dengan KTP',
                  );
                case RegisterStep.email:
                  return RegisterForm(
                    controller: _controller.emailController,
                    hintText: 'Masukkan alamat email anda',
                    labelTitle: 'Masukkan alamat email anda',
                    labelSubtitle: 'Pastikan alamat email benar',
                    keyboardType: TextInputType.emailAddress,
                  );
                case RegisterStep.whatsapp:
                  return RegisterForm(
                    controller: _controller.whatsappController,
                    hintText: 'Masukkan nomor WhatsApp anda',
                    labelTitle: 'Masukan nomor WhatsApp anda',
                    labelSubtitle: 'Pastikan noor WhatsApp benar',
                    keyboardType: TextInputType.phone,
                  );
                case RegisterStep.password:
                  return RegisterForm(
                    controller: _controller.passwordController,
                    hintText: 'Masukkan kata sandi anda',
                    labelTitle: 'Buat kata sandi anda',
                    labelSubtitle:
                        'Pastikan kata sandi mengandung huruf besar, kecil, dan juga angka',
                    keyboardType: TextInputType.visiblePassword,
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
                  );
                case RegisterStep.confirmPassword:
                  return RegisterForm(
                    controller: _controller.confirmPasswordController,
                    hintText: 'Konfirmasi password',
                    labelTitle: 'Konfirmasi kata sandi anda',
                    labelSubtitle: 'Pastikan konfirmasi kata sandi sesuai',
                    keyboardType: TextInputType.visiblePassword,
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
                  );
              }
            }),

            // Tampilkan pesan error
            Obx(() {
              if (_controller.errorMessage.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8),
                  child: Text(
                    _controller.errorMessage.value,
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            const Spacer(),

            // Tombol navigasi
            Obx(() {
              return WCustomButton(
                onPressed: _controller.nextStep,
                verticalPadding: 16,
                buttonText: _controller.currentStep.value ==
                        RegisterStep.confirmPassword
                    ? 'Daftar'
                    : 'Selanjutnya',
              );
            }),
          ],
        ),
      ),
    );
  }
}
