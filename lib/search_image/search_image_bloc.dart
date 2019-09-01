import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_hike/model/search_image.dart';
import './bloc.dart';

class SearchImageBloc extends Bloc<SearchImageEvent, SearchImageState> {
  @override
  SearchImageState get initialState => SearchImageInitialState();

  @override
  Stream<SearchImageState> mapEventToState(
    SearchImageEvent event,
  ) async* {
    if(event is LaunchSearchImageEvent){
      yield SearchImageLoadingState();
      try{
        var result = await SearchImage().searchImages(event.query);
        yield SearchImageSuccessState(result);
      }catch(e){
        yield SearchImageErrorState();
      }
    }else if(event is ResultSearchImageEvent){
      if(event.result.isEmpty){
        yield ResultSearchErrorState();
      }else{
        yield ResultSearchSuccessState(event.result);
      }
    }
  }
}
