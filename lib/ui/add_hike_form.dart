import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_hike/fireauth/authentication_bloc/bloc.dart';
import 'package:shared_hike/firecloud/addhike_bloc/bloc.dart';

class AddHikeForm extends StatefulWidget {
  State<AddHikeForm> createState() => _AddHikeFormState();
}

class _AddHikeFormState extends State<AddHikeForm>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  AddHikeBloc _addHikeBloc;

  bool get isPopulated =>
      _titleController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty;

  bool isAddButtonEnabled(AddHikeState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _addHikeBloc = BlocProvider.of<AddHikeBloc>(context);
    _titleController.addListener(_onTitleChanged);
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddHikeBloc, AddHikeState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          //TODO display loading
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .dispatch(LoggedInEvent());
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
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<AddHikeBloc, AddHikeState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.title),
                      labelText: 'Titre Rando',
                    ),
                    autocorrect: true,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isTitleValid ? 'Titre invalide' : null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      labelText: 'Description',
                    ),
                    obscureText: false,
                    autocorrect: true,
                    autovalidate: true,
                    maxLines: 5,
                    validator: (_) {
                      return !state.isDescriptionValid
                          ? 'Description invalide'
                          : null;
                    },
                  ),
                  RaisedButton(
                      child: Text("Ajout Rando"),
                      onPressed: () =>
                          isAddButtonEnabled(state) ? _onFormSubmitted() : null,
                      color:
                          isAddButtonEnabled(state) ? Colors.blue : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)))
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
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    _addHikeBloc.dispatch(
      TitleChanged(title: _titleController.text),
    );
  }

  void _onDescriptionChanged() {
    _addHikeBloc.dispatch(
      DescriptionChanged(description: _descriptionController.text),
    );
  }

  void _onFormSubmitted() {
    _addHikeBloc.dispatch(
      Submitted(
        title: _titleController.text,
        description: _descriptionController.text,
      ),
    );
  }
}
