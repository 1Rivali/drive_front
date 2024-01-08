import 'package:drive_front/features/auth/cubit/login/login_cubit.dart';
import 'package:drive_front/utils/widgets/page_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: PageDecoration(
        scaffold: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Good to see you again",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                    color: Colors.grey.shade400,
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 50),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.5,
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
                              TextFormField(
                                controller: usernameController,
                                validator: (value) => value!.isEmpty
                                    ? 'Email cannot be blank'
                                    : null,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "Username",
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) {
                              if (state is LoginFailureState) {
                                passwordController.clear();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text(
                                      "Wrong Username or Password",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    shape: Border.all(
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              }
                              if (state is LoginSuccessState) {
                                Navigator.of(context).pushReplacementNamed('/');
                              }
                            },
                            builder: (context, state) {
                              bool isLoading = state is LoginLoadingState;
                              return ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<LoginCubit>().login(
                                                username:
                                                    usernameController.text,
                                                password:
                                                    passwordController.text,
                                              );
                                        }
                                      },
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text("Login"),
                              );
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                          child: const Text("Don't have an account?"),
                        )
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
