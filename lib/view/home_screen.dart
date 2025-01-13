import 'package:fenix_mobile_case_study/model/movies_list_model.dart';
import 'package:fenix_mobile_case_study/core/service_imp.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<MoviesListModel> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = ServiceImp().getMoviesList(); // Fetch movies once
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MoviesListModel>(
        future:
            _moviesFuture, // This future is only initialized in `initState`, so it shouldn't cause repeated builds.
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final moviesList = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: moviesList.results?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  child: Text(moviesList.results?[index].id.toString() ?? ""),
                );
              },
              shrinkWrap: true,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

}
