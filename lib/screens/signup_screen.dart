import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myboard/bloc/user/user_cubit.dart';
import 'package:myboard/bloc/user/user_state.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is UserAuthenticated) {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
          builder: (context, state) {
            return Column(
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                ElevatedButton(
                  child: Text('Sign Up'),
                  onPressed: () {
                  },
                ),
                if (state is UserLoading) CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
