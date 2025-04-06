import 'package:flutter/material.dart';

class CustomerLoginPage extends StatefulWidget {
  @override
  _CustomerLoginPageState createState() => _CustomerLoginPageState();
}

class _CustomerLoginPageState extends State<CustomerLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Login"),
        backgroundColor: Color(0xFF1D5049),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Log in logic goes here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logged in as Customer')),
                );
                // You can navigate to the homepage of the app
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1D5049),  // Corrected parameter
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              ),
              child: Text("Login", style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the Sign Up page
              },
              child: Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
