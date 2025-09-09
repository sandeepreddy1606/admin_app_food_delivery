<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_page.dart';
import 'main_layout.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override State<RegistrationPage> createState()=>_RegState();
}

class _RegState extends State<RegistrationPage>{
  final _form=GlobalKey<FormState>();
  final _name=TextEditingController();
  final _email=TextEditingController();
  final _pw=TextEditingController();
  final _confirm=TextEditingController();
  bool _load=false, _obs1=true, _obs2=true;

  @override void dispose(){
    _name.dispose();_email.dispose();_pw.dispose();_confirm.dispose();
    super.dispose();
  }

  Future<void> _register()async{
    if(!_form.currentState!.validate())return;
    setState(()=>_load=true);
    try{
      final u=await AuthService.registerAdmin(
        email:_email.text, password:_pw.text,name:_name.text
      );
      if(u!=null && mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder:(_)=>const MainLayout()),
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text(e.toString()),backgroundColor:Colors.red),
      );
    }finally{
      if(mounted)setState(()=>_load=false);
    }
  }

  @override Widget build(BuildContext c){
    final isMobile=MediaQuery.of(c).size.width<600;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding:const EdgeInsets.all(24),
          child:ConstrainedBox(
            constraints:BoxConstraints(maxWidth:isMobile?double.infinity:400),
            child:Column(
              children:[
                Text('Create Admin', style:GoogleFonts.poppins(fontSize:32,fontWeight:FontWeight.bold)),
                const SizedBox(height:24),
                Form(
                  key:_form,
                  child:Column(children:[
                    TextFormField(
                      controller:_name,
                      decoration:const InputDecoration(labelText:'Full Name',prefixIcon:Icon(Icons.person)),
                      validator:(v)=>v!=null&&v.length>=2?null:'Min 2 chars',
                    ),
                    const SizedBox(height:16),
                    TextFormField(
                      controller:_email,
                      decoration:const InputDecoration(labelText:'Email',prefixIcon:Icon(Icons.email)),
                      validator:(v)=>v!=null&&v.contains('@')?null:'Invalid email',
                    ),
                    const SizedBox(height:16),
                    TextFormField(
                      controller:_pw,
                      obscureText:_obs1,
                      decoration:InputDecoration(
                        labelText:'Password',prefixIcon:const Icon(Icons.lock),
                        suffixIcon:IconButton(
                          icon:Icon(_obs1?Icons.visibility:Icons.visibility_off),
                          onPressed:()=>setState(()=>_obs1=!_obs1),
                        ),
                      ),
                      validator:(v)=>v!=null&&v.length>=6?null:'Min 6 chars',
                    ),
                    const SizedBox(height:16),
                    TextFormField(
                      controller:_confirm,
                      obscureText:_obs2,
                      decoration:InputDecoration(
                        labelText:'Confirm Password',prefixIcon:const Icon(Icons.lock),
                        suffixIcon:IconButton(
                          icon:Icon(_obs2?Icons.visibility:Icons.visibility_off),
                          onPressed:()=>setState(()=>_obs2=!_obs2),
                        ),
                      ),
                      validator:(v)=>v==_pw.text?null:'Passwords must match',
                    ),
                    const SizedBox(height:24),
                    SizedBox(
                      width: double.infinity, height:48,
                      child:ElevatedButton(
                        onPressed:_load? null:_register,
                        child:_load?const CircularProgressIndicator(color:Colors.white)
                                   :Text('Register',style:GoogleFonts.poppins(fontSize:16)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height:16),
                TextButton(
                  onPressed:()=>Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder:(_)=>const LoginPage()),
                  ),
                  child:Text('Already have an account? Sign In',style:GoogleFonts.poppins()),
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
import '../services/auth_service.dart';
import 'login_page.dart';
import 'main_layout.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override State<RegistrationPage> createState()=>_RegState();
}

class _RegState extends State<RegistrationPage>{
  final _form=GlobalKey<FormState>();
  final _name=TextEditingController();
  final _email=TextEditingController();
  final _pw=TextEditingController();
  final _confirm=TextEditingController();
  bool _load=false, _obs1=true, _obs2=true;

  @override void dispose(){
    _name.dispose();_email.dispose();_pw.dispose();_confirm.dispose();
    super.dispose();
  }

  Future<void> _register()async{
    if(!_form.currentState!.validate())return;
    setState(()=>_load=true);
    try{
      final u=await AuthService.registerAdmin(
        email:_email.text, password:_pw.text,name:_name.text
      );
      if(u!=null && mounted){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder:(_)=>const MainLayout()),
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text(e.toString()),backgroundColor:Colors.red),
      );
    }finally{
      if(mounted)setState(()=>_load=false);
    }
  }

  @override Widget build(BuildContext c){
    final isMobile=MediaQuery.of(c).size.width<600;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding:const EdgeInsets.all(24),
          child:ConstrainedBox(
            constraints:BoxConstraints(maxWidth:isMobile?double.infinity:400),
            child:Column(
              children:[
                Text('Create Admin', style:GoogleFonts.poppins(fontSize:32,fontWeight:FontWeight.bold)),
                const SizedBox(height:24),
                Form(
                  key:_form,
                  child:Column(children:[
                    TextFormField(
                      controller:_name,
                      decoration:const InputDecoration(labelText:'Full Name',prefixIcon:Icon(Icons.person)),
                      validator:(v)=>v!=null&&v.length>=2?null:'Min 2 chars',
                    ),
                    const SizedBox(height:16),
                    TextFormField(
                      controller:_email,
                      decoration:const InputDecoration(labelText:'Email',prefixIcon:Icon(Icons.email)),
                      validator:(v)=>v!=null&&v.contains('@')?null:'Invalid email',
                    ),
                    const SizedBox(height:16),
                    TextFormField(
                      controller:_pw,
                      obscureText:_obs1,
                      decoration:InputDecoration(
                        labelText:'Password',prefixIcon:const Icon(Icons.lock),
                        suffixIcon:IconButton(
                          icon:Icon(_obs1?Icons.visibility:Icons.visibility_off),
                          onPressed:()=>setState(()=>_obs1=!_obs1),
                        ),
                      ),
                      validator:(v)=>v!=null&&v.length>=6?null:'Min 6 chars',
                    ),
                    const SizedBox(height:16),
                    TextFormField(
                      controller:_confirm,
                      obscureText:_obs2,
                      decoration:InputDecoration(
                        labelText:'Confirm Password',prefixIcon:const Icon(Icons.lock),
                        suffixIcon:IconButton(
                          icon:Icon(_obs2?Icons.visibility:Icons.visibility_off),
                          onPressed:()=>setState(()=>_obs2=!_obs2),
                        ),
                      ),
                      validator:(v)=>v==_pw.text?null:'Passwords must match',
                    ),
                    const SizedBox(height:24),
                    SizedBox(
                      width: double.infinity, height:48,
                      child:ElevatedButton(
                        onPressed:_load? null:_register,
                        child:_load?const CircularProgressIndicator(color:Colors.white)
                                   :Text('Register',style:GoogleFonts.poppins(fontSize:16)),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height:16),
                TextButton(
                  onPressed:()=>Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder:(_)=>const LoginPage()),
                  ),
                  child:Text('Already have an account? Sign In',style:GoogleFonts.poppins()),
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
