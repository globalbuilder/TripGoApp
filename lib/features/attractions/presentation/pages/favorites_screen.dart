import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../blocs/favorites_bloc/favorites_bloc.dart';
import '../blocs/favorites_bloc/favorites_event.dart';
import '../blocs/favorites_bloc/favorites_state.dart';
import '../../domain/entities/favorite_entity.dart';
import 'attraction_detail_screen.dart';

class FavoritesPage extends StatefulWidget {
  static const routeName = '/favorites';

  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(const FetchFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favorites"),
      ),
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (context, state) {
          if (state.status == FavoritesStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? "Error fetching favorites.")),
            );
          }
        },
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.favorites.isEmpty) {
            return const Center(child: Text("No favorites found."));
          }

          return ListView.builder(
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final fav = state.favorites[index];
              return _FavoriteListItem(favorite: fav);
            },
          );
        },
      ),
    );
  }
}

class _FavoriteListItem extends StatelessWidget {
  final FavoriteEntity favorite;

  const _FavoriteListItem({Key? key, required this.favorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = "https://via.placeholder.com/200x150.png?text=No+Image";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: placeholder, // or if you stored the attraction's image
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(favorite.attractionName ?? "Attraction #${favorite.attractionId}"),
        subtitle: Text("ID: ${favorite.attractionId}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            context.read<FavoritesBloc>().add(RemoveFavoriteEvent(favorite.attractionId));
          },
        ),
        onTap: () {
          // Navigate to attraction detail if you want
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AttractionDetailPage(attractionId: favorite.attractionId),
            ),
          );
        },
      ),
    );
  }
}
