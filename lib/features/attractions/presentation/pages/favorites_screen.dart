// lib/features/attractions/presentation/pages/favorites_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    context.read<FavoritesBloc>().add(const FetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: BlocConsumer<FavoritesBloc, FavoritesState>(
        listener: (_, s) {
          if (s.status == FavoritesStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(s.errorMessage ?? 'Error loading favorites')),
            );
          }
        },
        buildWhen: (p, c) => p.favorites != c.favorites || p.status != c.status,
        builder: (_, s) {
          if (s.status == FavoritesStatus.loading && s.favorites.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.favorites.isEmpty) {
            return const Center(child: Text('No favorites found.'));
          }

          return RefreshIndicator(
            onRefresh: () async =>
                context.read<FavoritesBloc>().add(const FetchFavorites()),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: s.favorites.length,
              itemBuilder: (_, i) => _FavoriteTile(fav: s.favorites[i]),
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  final FavoriteEntity fav;
  const _FavoriteTile({required this.fav});

  @override
  Widget build(BuildContext context) {
    const assetPlaceholder = 'assets/images/empty_image_placeholder.jpg';
    final img = fav.attractionImage; // ← use the new field

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: img == null || img.isEmpty
              ? Image.asset(assetPlaceholder,
                  width: 60, height: 60, fit: BoxFit.cover)
              : CachedNetworkImage(
                  imageUrl: img,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      Image.asset(assetPlaceholder, fit: BoxFit.cover),
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
        title: Text(
          fav.attractionName ?? 'Attraction #${fav.attractionId}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('ID: ${fav.attractionId}'),
        trailing: IconButton(
          tooltip: 'Remove from favorites',
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () => context
              .read<FavoritesBloc>()
              .add(ToggleFavorite(fav.attractionId)),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AttractionDetailPage(attractionId: fav.attractionId),
          ),
        ),
      ),
    );
  }
}
