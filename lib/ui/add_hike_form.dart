import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_hike/fireauth/authentication_bloc/bloc.dart';
import 'package:shared_hike/firecloud/addhike_bloc/bloc.dart';

class AddHikeForm extends StatefulWidget {
  final String _currentUser;

  AddHikeForm({Key key, @required String currentUser})
      : assert(currentUser != null),
        _currentUser = currentUser,
        super(key: key);

  State<AddHikeForm> createState() => _AddHikeFormState();
}

class _AddHikeFormState extends State<AddHikeForm>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _elevationController = TextEditingController();
  AddHikeBloc _addHikeBloc;
  bool isloading = false;
  DateTime _selectDate;

  String get _currentUser => widget._currentUser;

  bool get isPopulated =>
      _titleController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty;

  bool isAddButtonEnabled(AddHikeState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _selectDate = DateTime.now();
    _addHikeBloc = BlocProvider.of<AddHikeBloc>(context);
    _titleController.addListener(_onTitleChanged);
    _descriptionController.addListener(_onDescriptionChanged);
    _distanceController.addListener(_onDistanceChanged);
    _elevationController.addListener(_onElevationChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddHikeBloc, AddHikeState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          setState(() {
            isloading = true;
          });
        }
        if (state.isSuccess) {
          setState(() {
            isloading = false;
          });
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          setState(() {
            isloading = false;
          });
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
      child: isloading
          ? CircularProgressIndicator()
          : BlocBuilder<AddHikeBloc, AddHikeState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.title),
                            labelText: 'Titre de la randonnée',
                          ),
                          autocorrect: true,
                          autovalidate: true,
                          validator: (_) {
                            return !state.isTitleValid
                                ? 'Titre invalide'
                                : null;
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
                        TextFormField(
                          controller: _elevationController,
                          decoration: InputDecoration(
                            labelText: 'Denivelé positif',
                          ),
                          obscureText: false,
                          autocorrect: false,
                          autovalidate: true,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          validator: (_) {
                            return !state.isDescriptionValid
                                ? 'Denivelé invalide'
                                : null;
                          },
                        ),
                        TextFormField(
                          controller: _distanceController,
                          decoration: InputDecoration(
                            labelText: 'Distance',
                          ),
                          obscureText: false,
                          autocorrect: false,
                          autovalidate: true,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          validator: (_) {
                            return !state.isDescriptionValid
                                ? 'Distance invalide'
                                : null;
                          },
                        ),
                        FlatButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true, onConfirm: (date) {
                                _onDateChanged(date);
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.fr);
                            },
                            child: Text(
                              'Date randonnée: ' +
                                  DateFormat('dd-MM-yyyy – kk:mm')
                                      .format(_selectDate),
                            )),
                        RaisedButton(
                            child: Text("Ajout Rando"),
                            onPressed: () => isAddButtonEnabled(state)
                                ? _onFormSubmitted()
                                : null,
                            color: isAddButtonEnabled(state)
                                ? Colors.blue
                                : Colors.grey,
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

  void _onDateChanged(date) {
    setState(() {
      _selectDate = date;
    });
    _addHikeBloc.dispatch(
      DateChanged(date: _selectDate),
    );
  }

  void _onElevationChanged() {
    _addHikeBloc.dispatch(
      ElevationChanged(elevation: int.parse(_elevationController.text)),
    );
  }

  void _onDistanceChanged() {
    _addHikeBloc.dispatch(
      DistanceChanged(distance: int.parse(_distanceController.text)),
    );
  }

  void _onFormSubmitted() {
    _addHikeBloc.dispatch(
      Submitted(
          title: _titleController.text,
          description: _descriptionController.text,
          date: _selectDate,
          owner: _currentUser,
          elevation: int.parse(_elevationController.text),
          distance: int.parse(_distanceController.text)),
    );
  }
}
