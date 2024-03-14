import 'package:educute/Login&Register/Login.dart';
import 'package:educute/Main%20page/Dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late Map<String, dynamic> userData = {};
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _username = TextEditingController();

  bool isRegistering = false;

  Future<String?> _onSignUp() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _username.text.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Harap isi semua field',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      Fluttertoast.showToast(
        msg: 'Format email tidak valid',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Fluttertoast.showToast(
        msg: 'Konfirmasi password tidak cocok',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }

    setState(() {
      isRegistering = true;
    });

    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final email = _emailController.text;
      final password = _passwordController.text;

      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );

      Fluttertoast.showToast(
        msg: 'Pendaftaran berhasil',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
        msg: error.message ?? "An Error occurred",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        isRegistering = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
        child: Center(
          child: Column(
            children: [
              const Text("Daftarkan Diri Anda"),
              TextField(
                controller: _username,
                decoration: const InputDecoration(
                    labelText: "Nama", hintText: "Masukkan Nama Anda"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: "Email", hintText: "Masukkan Email Anda"),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: "Password", hintText: "Masukkan Password Anda"),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                    labelText: "Konfirmasi Password",
                    hintText: "Masukkan Kembali Password Anda"),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              isRegistering
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        _onSignUp();
                      },
                      child: const Text("Daftar")),
              Row(
                children: [
                  const Text("Sudah Punya Akun?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Masuk"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
