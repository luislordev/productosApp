import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
              const SizedBox(height: 10),
              Text(
                'Registro',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: _LoginForm(),
              ),
            ],
          )),
          const SizedBox(height: 50),
          TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'login'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  overlayColor: MaterialStateProperty.all(
                    Colors.indigo.withOpacity(0.1),
                  )),
              child: const Text('¿Ya tienes una cuenta?',
                  style: const TextStyle(fontSize: 18, color: Colors.black87))),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: 'prueba@prueba.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_sharp),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);

              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El correo no es válido';
            },
          ),
          SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.text,
            decoration: InputDecorations.authInputDecoration(
                hintText: '******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña tiene que tener minimo 6 caracteres';
            },
          ),
          SizedBox(height: 30),
          MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(loginForm.isLoading ? 'Espere' : 'Iniciar sesión',
                  style: TextStyle(color: Colors.white)),
            ),
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();

                    if (!loginForm.isValidForm()) return;

                    loginForm.isLoading = true;

                    await Future.delayed(Duration(seconds: 2));

                    // TODO Validar si las credenciales son correctas
                    loginForm.isLoading = false;

                    Navigator.pushReplacementNamed(context, 'home');
                  },
          )
        ]),
      ),
    );
  }
}
