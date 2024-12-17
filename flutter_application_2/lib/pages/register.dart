import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _name, _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (input) => _name = input!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (input) => _email = input!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                validator: (input) {
                  if (input == null || input.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (input) => _password = input!,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await register();
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.pop(context);
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    final formState = _formKey.currentState;
    if (formState != null && formState.validate()) {
      formState.save();
      try {
        final list = await _auth.fetchSignInMethodsForEmail(_email);
        if (list.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email already registered')),
          );
          return;
        }
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Adiciona nome e email na coleção "users"
        await _firestore.collection('users').doc(user.user?.uid).set({
          'name': _name,
          'email': _email,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered: ${user.user?.email}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${e.toString()}')),
        );
      }
    }
  }
}
