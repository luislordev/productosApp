import 'package:flutter/material.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
               CardContainer(
                 child: Column(
                   children: [
                     const SizedBox(height:10),
                     Text('Login', style: Theme.of(context).textTheme.headline4,),
                     const SizedBox(height:30),

                     const _LoginForm()
                   ],
                 )
               ),

               const SizedBox(height: 50),
               const Text('Crear una nueva cuenta', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               const SizedBox(height: 50),
            ],
          ),
        )
      )
    );
  }
}


class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:   InputDecorations.authInputDecoration(
                hintText: 'prueba@prueba.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_sharp
              ),
            ),

            SizedBox(height:30),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration:   InputDecorations.authInputDecoration(
                hintText: '******',
                labelText: 'Contraseña',
                prefixIcon:  Icons.lock_outline
              ),
            ),

            SizedBox(height:30),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text('Iniciar sesión',style: TextStyle(color: Colors.white)),
              ),
              onPressed: (){},
            )
          ]
          ),
      ),
    );
  }
}