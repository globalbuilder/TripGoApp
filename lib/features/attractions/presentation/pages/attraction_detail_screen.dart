import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/attraction_entity.dart';
import '../blocs/attractions_bloc/attractions_bloc.dart';
import '../blocs/attractions_bloc/attractions_event.dart';
import '../blocs/attractions_bloc/attractions_state.dart';

import '../blocs/favorites_bloc/favorites_bloc.dart';
import '../blocs/favorites_bloc/favorites_event.dart';
import '../blocs/favorites_bloc/favorites_state.dart';

class AttractionDetailPage extends StatefulWidget {
  static const routeName = '/attraction-detail';

  final int attractionId;
  const AttractionDetailPage({Key? key, required this.attractionId}) : super(key: key);

  @override
  State<AttractionDetailPage> createState() => _AttractionDetailPageState();
}

class _AttractionDetailPageState extends State<AttractionDetailPage> {
  @override
  void initState() {
    super.initState();
    // Fetch the detail for this attraction from the BLoC
    context.read<AttractionsBloc>().add(FetchAttractionDetailEvent(widget.attractionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AttractionsBloc, AttractionsState>(
        builder: (context, state) {
          if (state.status == AttractionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == AttractionsStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? "Error loading attraction",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final attraction = state.selectedAttraction;
          if (attraction == null) {
            return const Center(child: Text("No attraction data found."));
          }

          return _DetailSliverView(attraction: attraction);
        },
      ),
    );
  }
}

class _DetailSliverView extends StatelessWidget {
  final AttractionEntity attraction;

  const _DetailSliverView({Key? key, required this.attraction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = "https://via.placeholder.com/350x250.png?text=No+Image";

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(attraction.name),
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: attraction.image ?? placeholder,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _DetailBody(attraction: attraction),
          ),
        ),
      ],
    );
  }
}

class _DetailBody extends StatelessWidget {
  final AttractionEntity attraction;
  const _DetailBody({Key? key, required this.attraction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address & rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                attraction.address ?? "No address",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              "Rating: ${attraction.averageRating.toStringAsFixed(1)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Description
        if (attraction.description != null)
          Text(
            attraction.description!,
            style: const TextStyle(fontSize: 16),
          ),

        const SizedBox(height: 16),
        // Price
        Text(
          "Price: \$${attraction.price.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        // (Existing) Add to favorites button
        BlocConsumer<FavoritesBloc, FavoritesState>(
          listener: (context, favState) {
            if (favState.status == FavoritesStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(favState.errorMessage ?? "Error in favorites")),
              );
            } else if (favState.status == FavoritesStatus.loaded) {
              // Possibly show a "favorites updated" message
            }
          },
          builder: (context, favState) {
            return ElevatedButton.icon(
              icon: const Icon(Icons.favorite_border),
              label: const Text("Add to Favorites"),
              onPressed: () {
                context.read<FavoritesBloc>().add(AddFavoriteEvent(attraction.id));
              },
            );
          },
        ),

        const SizedBox(height: 24),

        // NEW Buttons to open other pages
        _DetailActionsRow(attraction: attraction),
      ],
    );
  }
}

/// Displays a row of 3 buttons:
/// 1) View on Map
/// 2) Open Currency Converter
/// 3) Open Feedback Page
class _DetailActionsRow extends StatelessWidget {
  final AttractionEntity attraction;
  const _DetailActionsRow({Key? key, required this.attraction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 1) Map
        ElevatedButton.icon(
          icon: const Icon(Icons.map),
          label: const Text("Map"),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/map',
              arguments: [attraction], 
              // or pass a single-element list of AttractionEntity
            );
          },
        ),

        // 2) Currency converter
        ElevatedButton.icon(
          icon: const Icon(Icons.attach_money),
          label: const Text("Convert"),
          onPressed: () {
            Navigator.pushNamed(context, '/currency-converter');
          },
        ),

        // 3) Feedback
        ElevatedButton.icon(
          icon: const Icon(Icons.comment),
          label: const Text("Feedback"),
          onPressed: () {
            // If you have existing feedback in attraction, pass it
            Navigator.pushNamed(
              context,
              '/feedback',
              arguments: {
                'attractionId': attraction.id,
                'existingFeedback': [], // or pass real data if available
              },
            );
          },
        ),
      ],
    );
  }
}
