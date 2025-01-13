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
  final TextEditingController _searchController = TextEditingController();
  late Future<MoviesListModel> _moviesFuture;
  String searchText = "watchmen";

  @override
  void initState() {
    super.initState();
    _moviesFuture = ServiceImp().getMoviesList(searchText); // Fetch movies once
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            TextField(
              controller: _searchController,
              onEditingComplete: () {
                if (_searchController.text.length >= 2) {
                  searchText = _searchController.text;
                  _moviesFuture = ServiceImp().getMoviesList(searchText);
                  _searchController.clear();
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
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: moviesList.results?.length ?? 0,
                    itemBuilder: (context, index) {
                      return LayoutBuilder(builder: (context, constraints) => ConstrainedBox(constraints: constraints,
                      child: Card(
                        // Her cihazda aynı deneyimi sunmak için bir image generator servisi kullanabiliriz.
                        // Bu sayede widgetın width ve height bilgisi ile image'ın width ve height bilgisini hesaplayabiliriz.
                        child: Image.network(Constans.IMAGE_URL(constraints.minWidth, constraints.minHeight, moviesList.results?[index].posterPath), fit: BoxFit.cover,errorBuilder: (context, error, stackTrace) => const Center(child: Text('Error: Image not found')),),
                      )
                      ));
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
    );
  }

}
