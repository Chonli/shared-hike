// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_hike/authentification/authentication_bloc/bloc.dart';
import 'package:shared_hike/model/cloud_repository.dart';
import 'package:shared_hike/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final CloudRepository cloudRepository = CloudRepository();
    await tester.pumpWidget(BlocProvider(
        builder: (context) =>
            AuthenticationBloc(cloudRepository: cloudRepository)
              ..dispatch(AppStartedEvent()),
        child: MyApp()));
  });
}
