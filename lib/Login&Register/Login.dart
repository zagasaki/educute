import 'package:educute/Login&Register/Register.dart';
import 'package:educute/Main%20page/Dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggingIn = false;

  Future<void> _loginUser() async {
    setState(() {
      isLoggingIn = true;
    });

    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final email = _emailController.text;
      final password = _passwordController.text;

      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );

      Fluttertoast.showToast(
        msg: 'Login berhasil',
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
        isLoggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
        child: Center(
          child: Column(
            children: [
              const Text("Login"),
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
              const SizedBox(height: 10),
              isLoggingIn
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        _loginUser();
                      },
                      child: const Text("Masuk")),
              Row(
                children: [
                  const Text("Belum Punya Akun?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: const Text("Daftar"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
