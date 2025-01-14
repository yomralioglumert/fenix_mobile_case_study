import 'package:fenix_mobile_case_study/constant/constans.dart';
import 'package:fenix_mobile_case_study/model/movies_list_model.dart';
import 'package:fenix_mobile_case_study/core/service_imp.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  late Future<MoviesListModel> _moviesFuture;
  String searchText = "watchmen";

  @override
  void initState() {
    super.initState();
    _moviesFuture = Service().getMoviesList(searchText); // Fetch movies once
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                CustomTextField(searchController: searchController,
                 onEditingComplete: () {
                    if (searchController.text.length >= 2) {
                      searchText = searchController.text;
                      _moviesFuture = Service().getMoviesList(searchText);
                      searchController.clear();
                      setState(() {});
                    }
                  },
                ),
                FutureBuilder<MoviesListModel>(
                  future:
                      _moviesFuture, // This future is only initialized in `initState`, so it shouldn't cause repeated builds.
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      final moviesList = snapshot.data!;
                      return GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                             SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0),
                        itemCount: moviesList.results?.length ?? 0,
                        itemBuilder: (context, index) {
                          return ImageCard(movieResult: moviesList.results?[index],);
                        },
                        shrinkWrap: true,
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.searchController,
    required this.onEditingComplete,
  });

  final TextEditingController searchController;
  final Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onEditingComplete: onEditingComplete ,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
      required this.movieResult,
    super.key,
  });

  final Results? movieResult;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        spacing: 10,
        children: [
          Text(movieResult?.title ?? '', style: const TextStyle(fontSize: 18)),
          Expanded(
            child: Image.network(
              Constans.IMAGE_URL(
                 0,0,
                 movieResult?.posterPath),
              fit: BoxFit.cover,
              errorBuilder: (context, error,
                      stackTrace) =>
                  Center(child: Icon(Icons.error)),
              loadingBuilder: (BuildContext context,
                  Widget child,
                  ImageChunkEvent?
                      loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress
                                .expectedTotalBytes !=
                            null
                        ? loadingProgress
                                .cumulativeBytesLoaded /
                            loadingProgress
                                .expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
