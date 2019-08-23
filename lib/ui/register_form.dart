import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/fireauth/authentication_bloc/bloc.dart';
import 'package:shared_hike/fireauth/register_bloc/bloc.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();
  AnimationController _loginButtonController;
  Animation<double> _buttonAnimation;
  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _pseudoController.addListener(_onPseudoChanged);
    _loginButtonController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _buttonAnimation = Tween(
      begin: 220.0,
      end: 60.0,
    ).animate(CurvedAnimation(parent: _loginButtonController, curve: Interval(0.0, 0.250)))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _loginButtonController.reverse();
        }
      });
  }

  void _playAnimation() async{
    await _loginButtonController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          _playAnimation();
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedInEvent());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Erreur de creation de compte'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? 'Email invalide' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Mot de passe',
                    ),
                    obscureText: true,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPasswordValid ? 'Mot de passe invalide' : null;
                    },
                  ),
                  TextFormField(
                    controller: _pseudoController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.text_fields),
                      labelText: 'Pseudo',
                    ),
                    obscureText: false,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPseudoValid ? 'Pseudo invalide' : null;
                    },
                  ),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: isRegisterButtonEnabled(state) ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.all(const Radius.circular(30.0))),
                        alignment: FractionalOffset.center,
                        width: _buttonAnimation.value,
                        height: 50,
                        child: _buttonAnimation.value > 200
                            ? Text('Créer compte',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                            : CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(
                              Colors.white),
                        )),
                    onTap: () => isRegisterButtonEnabled(state) ? _onFormSubmitted() : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onPseudoChanged() {
    _registerBloc.dispatch(
      PseudoChanged(pseudo: _pseudoController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.dispatch(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
        pseudo: _pseudoController.text,
      ),
    );
  }
}