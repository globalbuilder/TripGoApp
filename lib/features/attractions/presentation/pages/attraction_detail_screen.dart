import 'dart:math' as math;
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

import '../blocs/feedback_bloc/feedback_bloc.dart';
import '../blocs/feedback_bloc/feedback_event.dart';
import '../blocs/feedback_bloc/feedback_state.dart';

class AttractionDetailPage extends StatefulWidget {
  static const routeName = '/attraction-detail';

  final int attractionId;
  const AttractionDetailPage({Key? key, required this.attractionId})
      : super(key: key);

  @override
  State<AttractionDetailPage> createState() => _AttractionDetailPageState();
}

class _AttractionDetailPageState extends State<AttractionDetailPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<AttractionsBloc>()
        .add(FetchAttractionDetailEvent(widget.attractionId));

    // also load feedbacks (needed for the histogram)
    context.read<FeedbackBloc>().add(FetchFeedbacksEvent(widget.attractionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AttractionsBloc, AttractionsState>(
        builder: (context, state) {
          if (state.status == AttractionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == AttractionsStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Error',
                  style: const TextStyle(color: Colors.red)),
            );
          }

          final attraction = state.selectedAttraction;
          if (attraction == null) {
            return const Center(child: Text('No data'));
          }
          return _DetailSliverView(attraction: attraction);
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────

class _DetailSliverView extends StatelessWidget {
  final AttractionEntity attraction;
  const _DetailSliverView({super.key, required this.attraction});

  static const _assetPlaceholder = 'assets/images/empty_image_placeholder.jpg';

  @override
  Widget build(BuildContext context) {
    Widget background() {
      final url = attraction.image;
      if (url != null && url.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (_, __) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (_, __, ___) =>
              Image.asset(_assetPlaceholder, fit: BoxFit.cover),
        );
      }
      return Image.asset(_assetPlaceholder, fit: BoxFit.cover);
    }

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
                background(),
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
            padding: const EdgeInsets.all(16),
            child: _DetailBody(attraction: attraction),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  final AttractionEntity attraction;
  const _DetailBody({required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // address + rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(attraction.address ?? 'No address',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            Text('Rating: ${attraction.averageRating.toStringAsFixed(1)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),

        if (attraction.description != null)
          Text(attraction.description!, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),

        Text('Price: \$${attraction.price.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // animated favourite button
        BlocBuilder<FavoritesBloc, FavoritesState>(
          buildWhen: (p, c) => p.ids != c.ids,
          builder: (context, favState) {
            final isFav = favState.contains(attraction.id);
            return Center(
              child: IconButton(
                iconSize: 40,
                splashRadius: 28,
                tooltip: isFav ? 'Remove from favourites' : 'Add to favourites',
                onPressed: () => context
                    .read<FavoritesBloc>()
                    .add(ToggleFavorite(attraction.id)),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (c, anim) =>
                      ScaleTransition(scale: anim, child: c),
                  child: isFav
                      ? const Icon(Icons.favorite,
                          key: ValueKey('f'), color: Colors.red)
                      : const Icon(Icons.favorite_border,
                          key: ValueKey('o'), color: Colors.grey),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // feedback histogram
        BlocBuilder<FeedbackBloc, FeedbackState>(
          builder: (context, fbState) {
            if (fbState.status == FeedbackStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final feedbacks = fbState.feedbacks;
            if (feedbacks.isEmpty) {
              return const Text('No feedback yet.');
            }

            final counts = List<int>.filled(5, 0); // 0→4 == 1→5 stars
            for (final f in feedbacks) {
              if (f.rating >= 1 && f.rating <= 5) counts[f.rating - 1]++;
            }
            final maxCount = counts.reduce(math.max).clamp(1, 999);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reviews (${feedbacks.length})',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...List.generate(5, (i) {
                  final stars = 5 - i; // show 5★ on top
                  final value = counts[stars - 1];
                  final fraction = value / maxCount;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text('$stars★',
                              style: const TextStyle(fontSize: 12)),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: fraction,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('$value'),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 12),
              ],
            );
          },
        ),

        // actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('View on Map'),
              onPressed: () =>
                  Navigator.pushNamed(context, '/map', arguments: [attraction]),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.comment),
              label: const Text('Feedback'),
              onPressed: () => Navigator.pushNamed(
                context,
                '/feedback',
                arguments: attraction.id,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
