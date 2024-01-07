import 'package:drive_front/features/auth/cubit/login/login_cubit.dart';
import 'package:drive_front/features/auth/cubit/signup/signup_cubit.dart';
import 'package:drive_front/features/auth/model/signup.dart';
import 'package:drive_front/features/home/screens/home.dart';
import 'package:drive_front/utils/widgets/page_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: PageDecoration(
        scaffold: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Let's get you started by creating an account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                    color: Colors.grey.shade400,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 50),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // First & Last name
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      expands: false,
                                      controller: firstnameController,
                                      validator: (value) => value!.isEmpty
                                          ? 'first name cannot be blank'
                                          : null,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        hintText: "First name",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      expands: false,
                                      controller: lastnameController,
                                      validator: (value) => value!.isEmpty
                                          ? 'last name cannot be blank'
                                          : null,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        hintText: "Last name",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Username
                              TextFormField(
                                controller: usernameController,
                                validator: (value) => value!.isEmpty
                                    ? 'username cannot be blank'
                                    : null,
                                decoration: const InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.supervised_user_circle),
                                  hintText: "Username",
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // email
                              TextFormField(
                                controller: emailController,
                                validator: (value) => value!.isEmpty
                                    ? 'Email cannot be blank'
                                    : null,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  hintText: "Email",
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Password
                              TextFormField(
                                controller: passwordController,
                                validator: (value) => value!.isEmpty
                                    ? 'Password cannot be blank'
                                    : null,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: "Password",
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // Confirm password
                              TextFormField(
                                controller: confirmPasswordController,
                                validator: (value) => value!.isEmpty
                                    ? 'Confirm Password cannot be blank'
                                    : null,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: "Confirm Password",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: BlocConsumer<SignupCubit, SignupState>(
                            listener: (context, state) {
                              if (state is SignupFailureState) {
                                emailController.clear();
                                usernameController.clear();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text(
                                      "Username or email already taken",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    shape: Border.all(
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              }
                              if (state is SignupSuccessState) {
                                Navigator.of(context).pushReplacementNamed('/');
                              }
                            },
                            builder: (context, state) {
                              bool isLoading = state is SignupLoadingState;
                              return ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          final SignupModel data = SignupModel(
                                            userName: usernameController.text,
                                            email: emailController.text,
                                            firstName: firstnameController.text,
                                            lastName: lastnameController.text,
                                            password: passwordController.text,
                                            cPassword:
                                                confirmPasswordController.text,
                                          );
                                          context
                                              .read<SignupCubit>()
                                              .signup(data);
                                        }
                                      },
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text("Signup"),
                              );
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Already Have an Account?"),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
