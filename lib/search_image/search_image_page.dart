import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'bloc.dart';

class SearchImagePage extends StatelessWidget {
  final TextEditingController _filter = TextEditingController();

  SearchImagePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _filter,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Recherche Image...',
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              BlocProvider.of<SearchImageBloc>(context)
                  .dispatch(LaunchSearchImageEvent(query: query));
            }
          },
        ),
      ),
      body: BlocBuilder<SearchImageBloc, SearchImageState>(
          builder: (context, state) {
        if (state is SearchImageInitialState) {
          return Container();
        } else if (state is SearchImageLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SearchImageErrorState) {
          return Center(child: Text('Pas d\'image trouvé'));
        } else if (state is SearchImageSuccessState) {
          if (state.urlResult.length == 0) {
            return Center(child: Text('Pas d\'image trouvé'));
          } else {
            return GridView.builder(
                itemCount: state.urlResult.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Card(
                        elevation: 5.0,
                        child: Container(
                            alignment: Alignment.center,
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              imageUrl: state.urlResult[index],
                              cacheManager: DefaultCacheManager(),
                            ))),
                    onTap: () {
                      print('select ' + state.urlResult[index]);
                      Navigator.of(context).pop();
                    },
                  );
                });
          }
        } else {
          return Container();
        }
      }),
    );
  }
}

//Navigator.of(context).pop();
