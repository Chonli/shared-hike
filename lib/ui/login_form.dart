import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/db/cloud_repository.dart';
import 'package:shared_hike/fireauth/authentication_bloc/bloc.dart';
import 'package:shared_hike/fireauth/login_bloc/bloc.dart';
import 'package:shared_hike/ui/register_page.dart';
import 'package:shared_hike/util/validators.dart';

class LoginForm extends StatefulWidget {
  final CloudRepository _cloudRepository;

  LoginForm({Key key, @required CloudRepository cloudRepository})
      : assert(cloudRepository != null),
        _cloudRepository = cloudRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AnimationController _loginButtonController;
  Animation<double> _buttonAnimation;
  LoginBloc _loginBloc;

  CloudRepository get _cloudRepository => widget._cloudRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _loginButtonController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _buttonAnimation = Tween(
      begin: 220.0,
      end: 60.0,
    ).animate(CurvedAnimation(
        parent: _loginButtonController, curve: Interval(0.0, 0.250)))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _loginButtonController.reverse();
        }
      });
  }

  void _playAnimation() async {
    await _loginButtonController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Erreur d'authentification"),
                    Icon(Icons.error)
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          _playAnimation();
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .dispatch(LoggedInEvent());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20.0),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    autovalidate: true,
                    autocorrect: false,
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
                    autovalidate: true,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid
                          ? 'Mot de passe invalide'
                          : null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                              margin: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                  color: isLoginButtonEnabled(state)
                                      ? Colors.blue
                                      : Colors.grey,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(30.0))),
                              alignment: FractionalOffset.center,
                              width: _buttonAnimation.value,
                              height: 50,
                              child: _buttonAnimation.value > 200
                                  ? Text(
                                      'Connexion',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  : CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )),
                          onTap: () => isLoginButtonEnabled(state)
                              ? _onFormSubmitted()
                              : null,
                        ),
                        FlatButton(
                            child: Text(
                              'Créer un compte',
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return RegisterPage(
                                      cloudRepository: _cloudRepository);
                                }),
                              );
                            }),
                        FlatButton(
                            child: Text(
                              'Mot de passe oublié ?',
                            ),
                            onPressed: () {
                              manageForgotPassword(context);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void manageForgotPassword(context) {
    TextEditingController emailFieldController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mot de passe oublié ?'),
          content: Column(children: <Widget>[
            const Text(
                'Entrez votre adresse email ci-dessous et nous vous enverrons un lien pour réinitialiser votre mot de passe: '),
            TextFormField(
              controller: emailFieldController,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: 'Email',
              ),
              autovalidate: true,
              autocorrect: false,
              validator: (value) {
                return !Validators.isValidEmail(value)
                    ? 'Email invalide'
                    : null;
              },
            ),
          ]),
          actions: <Widget>[
            FlatButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('Envoyer'),
              onPressed: () {
                _cloudRepository.sendPasswordResetEmail(
                    email: emailFieldController.text);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    print("_onFormSubmitted");
    _loginBloc.dispatch(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
