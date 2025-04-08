import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../blocs/attractions_bloc/attractions_bloc.dart';
import '../blocs/attractions_bloc/attractions_event.dart';
import '../blocs/attractions_bloc/attractions_state.dart';
import '../../domain/entities/attraction_entity.dart';
import 'attraction_detail_screen.dart';

class SearchAttractionPage extends StatefulWidget {
  static const routeName = '/search-attractions';

  const SearchAttractionPage({Key? key}) : super(key: key);

  @override
  State<SearchAttractionPage> createState() => _SearchAttractionPageState();
}

class _SearchAttractionPageState extends State<SearchAttractionPage> {
  final _searchController = TextEditingController();

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<AttractionsBloc>().add(SearchAttractionsEvent(query));
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We can do an AnimatedList or a simple ListView for results
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Attractions"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // The search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search by name...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Results
          Expanded(
            child: BlocBuilder<AttractionsBloc, AttractionsState>(
              builder: (context, state) {
                if (state.status == AttractionsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == AttractionsStatus.error) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? "Error searching attractions",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state.attractions.isEmpty) {
                  return const Center(child: Text("No results found."));
                }

                return ListView.builder(
                  itemCount: state.attractions.length,
                  itemBuilder: (context, index) {
                    final attraction = state.attractions[index];
                    return _SearchResultItem(attraction: attraction);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final AttractionEntity attraction;

  const _SearchResultItem({Key? key, required this.attraction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = "https://via.placeholder.com/120x90.png?text=No+Image";

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: CachedNetworkImage(
          imageUrl: attraction.image ?? placeholder,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(attraction.name),
      subtitle: Text("Rating: ${attraction.averageRating.toStringAsFixed(1)}"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AttractionDetailPage(attractionId: attraction.id),
          ),
        );
      },
    );
  }
}
