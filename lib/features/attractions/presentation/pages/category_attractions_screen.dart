import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/attraction_entity.dart';
import '../blocs/categories_bloc/categories_bloc.dart';
import '../blocs/categories_bloc/categories_state.dart';
import 'attraction_detail_screen.dart';

class CategoryAttractionsPage extends StatelessWidget {
  final CategoryEntity category;

  const CategoryAttractionsPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String assetPlaceholder = 'assets/images/empty_image_placeholder.jpg';

    return Scaffold(
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          // If the BLoC is still loading category attractions
          if (state.status == CategoriesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == CategoriesStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? "Error loading attractions",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final attractions = state.categoryAttractions;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(category.name),
                  background: Hero(
                    tag: "category_${category.id}",
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: category.image ?? '',
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (_, __, ___) =>
                              Image.asset(assetPlaceholder, fit: BoxFit.cover),
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
              ),

              // List of attractions
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final attraction = attractions[index];
                    return _AttractionListItem(attraction: attraction);
                  },
                  childCount: attractions.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AttractionListItem extends StatelessWidget {
  final AttractionEntity attraction;

  const _AttractionListItem({Key? key, required this.attraction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = "https://via.placeholder.com/200x150.png?text=No+Image";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AttractionDetailPage(attractionId: attraction.id),
            ),
          );
        },
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: attraction.image ?? placeholder,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (ctx, url) => const SizedBox(
                  width: 120,
                  height: 90,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (ctx, url, err) => Container(
                  width: 120,
                  height: 90,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attraction.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (attraction.description != null)
                      Text(
                        attraction.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Text(
                      "Rating: ${attraction.averageRating.toStringAsFixed(1)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
