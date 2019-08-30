import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_hike/model/hike.dart';
import 'package:shared_hike/firecloud/hike_bloc/bloc.dart';
import 'package:shared_hike/search_image/search_image_page.dart';

class HikeForm extends StatefulWidget {
  final String _currentUser;
  final Hike _hike;

  HikeForm({Key key, String currentUser, Hike hike})
      : _currentUser = currentUser,
        _hike = hike,
        super(key: key);

  State<HikeForm> createState() => _HikeFormState();
}

class _HikeFormState extends State<HikeForm>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _elevationController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  HikeBloc _hikeBloc;
  bool _isLoading = false;
  bool _isEdit = false;
  DateTime _selectDate;

  String get _currentUser => widget._currentUser;

  Hike get _hike => widget._hike;

  bool get isPopulated =>
      _titleController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty;

  bool isAddButtonEnabled(HikeState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _hikeBloc = BlocProvider.of<HikeBloc>(context);

    if (_hike != null) {
      setState(() {
        _isEdit = true;
        _titleController.text = _hike.title;
        _descriptionController.text = _hike.description;
        _imageController.text = _hike.image;
        _elevationController.text = _hike.elevation.toString();
        _distanceController.text = _hike.distance.toString();
        _selectDate = _hike.hikeDate;
      });
    } else {
      _selectDate = DateTime.now();
    }

    _titleController.addListener(_onTitleChanged);
    _descriptionController.addListener(_onDescriptionChanged);
    _distanceController.addListener(_onDistanceChanged);
    _elevationController.addListener(_onElevationChanged);
    _imageController.addListener(_onImageChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HikeBloc, HikeState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          setState(() {
            _isLoading = true;
          });
        }
        if (state.isSuccess) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          setState(() {
            _isLoading = false;
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
      child: _isLoading
          ? CircularProgressIndicator()
          : BlocBuilder<HikeBloc, HikeState>(
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Form(
                    child: ListView(
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
                          controller: _imageController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.photo_size_select_actual),
                              labelText: 'Adresse image',
                              suffix: IconButton(
                                color: Colors.black,
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return SearchImagePage();
                                    }),
                                  );
                                },
                              )),
                          obscureText: false,
                          autocorrect: false,
                          autovalidate: true,
                          validator: (_) {
                            return !state.isImageValid
                                ? 'Image invalide'
                                : null;
                          },
                        ),
                        TextFormField(
                          controller: _elevationController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.arrow_upward),
                            labelText: 'Denivelé positif (en m)',
                          ),
                          obscureText: false,
                          autocorrect: false,
                          autovalidate: true,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          validator: (_) {
                            return !state.isElevationValid
                                ? 'Denivelé invalide'
                                : null;
                          },
                        ),
                        TextFormField(
                          controller: _distanceController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.straighten),
                            labelText: 'Distance (en m)',
                          ),
                          obscureText: false,
                          autocorrect: false,
                          autovalidate: true,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
                          validator: (_) {
                            return !state.isDistanceValid
                                ? 'Distance invalide'
                                : null;
                          },
                        ),
                        FlatButton(
                            onPressed: () async {
                              final DateTime pickDate = await showDatePicker(
                                  context: context,
                                  initialDate: _selectDate,
                                  firstDate: DateTime(2019),
                                  lastDate: DateTime(2100));
                              if (pickDate != null) {
                                final TimeOfDay pickTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: 8, minute: 0),
                                );
                                if (pickTime != null) {
                                  _onDateChanged(DateTime(
                                      pickDate.year,
                                      pickDate.month,
                                      pickDate.day,
                                      pickTime.hour,
                                      pickTime.minute));
                                }
                              }
                            },
                            child: Text(
                              'Date randonnée: ' +
                                  DateFormat('dd-MM-yyyy – kk:mm')
                                      .format(_selectDate),
                            )),
                        RaisedButton(
                            child: _isEdit
                                ? Text("Mise à jour Rando")
                                : Text("Ajout Rando"),
                            onPressed: () => isAddButtonEnabled(state)
                                ? _onFormSubmitted()
                                : null,
                            color: isAddButtonEnabled(state)
                                ? Colors.blue
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)))
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
    _hikeBloc.dispatch(
      TitleChanged(title: _titleController.text),
    );
  }

  void _onDescriptionChanged() {
    _hikeBloc.dispatch(
      DescriptionChanged(description: _descriptionController.text),
    );
  }

  void _onDateChanged(date) {
    setState(() {
      _selectDate = date;
    });
    _hikeBloc.dispatch(
      DateChanged(date: _selectDate),
    );
  }

  void _onElevationChanged() {
    _hikeBloc.dispatch(
      ElevationChanged(elevation: int.parse(_elevationController.text)),
    );
  }

  void _onDistanceChanged() {
    _hikeBloc.dispatch(
      DistanceChanged(distance: int.parse(_distanceController.text)),
    );
  }

  void _onImageChanged() {
    _hikeBloc.dispatch(
      UrlImageChanged(urlImage: _imageController.text),
    );
  }

  void _onFormSubmitted() {
    if (_isEdit) {
      _hikeBloc.dispatch(
        UpdateHikeEvent(
          hike: Hike(
              _hike.id,
              _titleController.text,
              _descriptionController.text,
              _imageController.text,
              int.parse(_elevationController.text),
              int.parse(_distanceController.text),
              _selectDate,
              _hike.owner),
        ),
      );
    } else {
      _hikeBloc.dispatch(
        CreateHikeEvent(
            title: _titleController.text,
            description: _descriptionController.text,
            date: _selectDate,
            owner: _currentUser,
            urlImage: _imageController.text,
            elevation: int.parse(_elevationController.text),
            distance: int.parse(_distanceController.text)),
      );
    }
  }
}
