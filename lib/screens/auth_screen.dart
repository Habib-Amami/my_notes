import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_notes/constants/images.dart';
import 'package:my_notes/services/auth.dart';

class AuthScreen extends StatefulWidget {
  static String routeName = "my_notes/screens/auth_screen.dart";

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isRegistered = true;
  bool _obscureText = true;
  final _formkey = GlobalKey<FormState>();
  late String? _password;
  late String? _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        _isRegistered ? loginScreenImage : registerScreenImage,
                        height: 180,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _isRegistered ? "Login" : "Register",
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        _isRegistered
                            ? "Login to continue using the app"
                            : "Register to join our community",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Row(
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        hintText: "Enter your email",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                        prefixIconColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Theme.of(context).primaryColor;
                            }
                            if (states.contains(MaterialState.error)) {
                              return const Color(0xffc23636);
                            }
                            return Colors.grey;
                          },
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid Email';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (newValue) => _email = newValue!.trim(),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //password form field -----------------------
                  const Row(
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  SizedBox(
                    // height: 60,
                    width: double.infinity,
                    child: TextFormField(
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(
                          fontSize: 12,
                        ),
                        hintText: "Enter your password",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        prefixIconColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused)) {
                              return Theme.of(context).primaryColor;
                            }
                            if (states.contains(MaterialState.error)) {
                              return const Color(0xffc23636);
                            }
                            return Colors.grey;
                          },
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(
                              () {
                                _obscureText = !_obscureText;
                              },
                            );
                          },
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required.';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters long.';
                        }
                        return null; // Password is valid
                      },
                      onFieldSubmitted: (_) {
                        _formkey.currentState!.save();
                        _formkey.currentState!.validate();
                      },
                      onSaved: (newValue) => _password = newValue!.trim(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: FilledButton(
                      style: const ButtonStyle(
                        elevation: MaterialStatePropertyAll(5),
                      ),
                      onPressed: () {
                        if (_isRegistered) {
                          Auth().logIn(
                            ctx: context,
                            email: _email!,
                            password: _password!,
                          );
                        } else {
                          Auth().register(
                            ctx: context,
                            email: _email!,
                            password: _password!,
                          );
                        }
                      },
                      child: Text(
                        _isRegistered ? "Login" : "Register",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _isRegistered
                            ? "Don't have an account ?"
                            : "You already have an account ?",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        style: const ButtonStyle(
                          elevation: MaterialStatePropertyAll(
                            5,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isRegistered = !_isRegistered;
                          });
                        },
                        child: Text(
                          _isRegistered ? "Register" : "Login",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
