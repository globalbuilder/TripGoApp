import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/attraction_entity.dart';
import '../blocs/attractions_bloc/attractions_bloc.dart';
import '../blocs/attractions_bloc/attractions_event.dart';
import '../blocs/attractions_bloc/attractions_state.dart';
import 'attraction_detail_screen.dart';

class AttractionsPage extends StatefulWidget {
  static const routeName = '/attractions';

  const AttractionsPage({Key? key}) : super(key: key);

  @override
  State<AttractionsPage> createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  @override
  void initState() {
    super.initState();
    // Trigger fetching of all attractions
    context.read<AttractionsBloc>().add(const FetchAllAttractionsEvent());
  }

  Future<void> _onRefresh() async {
    // Re-fetch attractions
    context.read<AttractionsBloc>().add(const FetchAllAttractionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Attractions"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<AttractionsBloc, AttractionsState>(
        builder: (context, state) {
          if (state.status == AttractionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == AttractionsStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? "Error loading attractions",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state.attractions.isEmpty) {
            return const Center(child: Text("No attractions found."));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: state.attractions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final attraction = state.attractions[index];
                  return _AttractionGridItem(attraction: attraction);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AttractionGridItem extends StatelessWidget {
  final AttractionEntity attraction;

  const _AttractionGridItem({Key? key, required this.attraction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = "https://via.placeholder.com/300x200.png?text=No+Image";

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AttractionDetailPage.routeName,
          arguments: attraction.id,
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: attraction.image ?? placeholder,
                  fit: BoxFit.cover,
                  placeholder: (ctx, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (ctx, url, err) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
              // Dark overlay + name
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    attraction.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
