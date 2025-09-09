<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'registration_page.dart';
import 'main_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'padma@gmail.com');
  final _pw = TextEditingController(text: 'padma@123');
  bool _loading = false, _obscure = true;

  @override void dispose() { _email.dispose(); _pw.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = await AuthService.signIn(_email.text, _pw.text);
      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override Widget build(BuildContext c) {
    final isMobile = MediaQuery.of(c).size.width < 600;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400),
            child: Column(
              children: [
                Text('Foodie Admin', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height:24),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText:'Email', prefixIcon: Icon(Icons.email)),
                      validator: (v)=>v!=null&&v.contains('@')?null:'Invalid email',
                    ),
                    const SizedBox(height:16),
                    TextFormField(
                      controller: _pw,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText:'Password', prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure?Icons.visibility:Icons.visibility_off),
                          onPressed: ()=>setState(()=>_obscure=!_obscure),
                        ),
                      ),
                      validator:(v)=>v!=null&&v.length>=6?null:'Min 6 chars',
                    ),
                    const SizedBox(height:24),
                    SizedBox(
                      width: double.infinity, height:48,
                      child: ElevatedButton(
                        onPressed:_loading? null:_login,
                        child:_loading?const CircularProgressIndicator(color:Colors.white)
                                     :Text('Sign In', style: GoogleFonts.poppins(fontSize:16)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height:16),
                TextButton(
                  onPressed:()=>Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder:(_)=>const RegistrationPage()),
                  ),
                  child: Text('Don’t have an account? Register', style: GoogleFonts.poppins()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'registration_page.dart';
import 'main_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'padma@gmail.com');
  final _pw = TextEditingController(text: 'padma@123');
  bool _loading = false, _obscure = true;

  @override void dispose() { _email.dispose(); _pw.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = await AuthService.signIn(_email.text, _pw.text);
      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override Widget build(BuildContext c) {
    final isMobile = MediaQuery.of(c).size.width < 600;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 400),
            child: Column(
              children: [
                Text('Foodie Admin', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height:24),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText:'Email', prefixIcon: Icon(Icons.email)),
                      validator: (v)=>v!=null&&v.contains('@')?null:'Invalid email',
                    ),
                    const SizedBox(height:16),
                    TextFormField(
                      controller: _pw,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText:'Password', prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure?Icons.visibility:Icons.visibility_off),
                          onPressed: ()=>setState(()=>_obscure=!_obscure),
                        ),
                      ),
                      validator:(v)=>v!=null&&v.length>=6?null:'Min 6 chars',
                    ),
                    const SizedBox(height:24),
                    SizedBox(
                      width: double.infinity, height:48,
                      child: ElevatedButton(
                        onPressed:_loading? null:_login,
                        child:_loading?const CircularProgressIndicator(color:Colors.white)
                                     :Text('Sign In', style: GoogleFonts.poppins(fontSize:16)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height:16),
                TextButton(
                  onPressed:()=>Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder:(_)=>const RegistrationPage()),
                  ),
                  child: Text('Don’t have an account? Register', style: GoogleFonts.poppins()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
>>>>>>> a330a6beaf92aaae151a5a3470617d41e51bbcdf
