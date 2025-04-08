import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For fancy image loading
import '../../domain/entities/category_entity.dart';
import '../blocs/categories_bloc/categories_bloc.dart';
import '../blocs/categories_bloc/categories_event.dart';
import '../blocs/categories_bloc/categories_state.dart';
import 'category_attractions_screen.dart';

class CategoriesPage extends StatefulWidget {
  static const routeName = '/categories';

  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
    // Fetch all categories from the BLoC
    context.read<CategoriesBloc>().add(const FetchCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          if (state.status == CategoriesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == CategoriesStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? "An error occurred",
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (state.categories.isEmpty) {
            return const Center(child: Text("No categories found."));
          }

          // If loaded successfully
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: state.categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return _CategoryGridItem(category: category);
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  final CategoryEntity category;

  const _CategoryGridItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeholder = "https://via.placeholder.com/300x200.png?text=No+Image";

    return GestureDetector(
      onTap: () {
        // Fetch the category's attractions, then navigate
        context.read<CategoriesBloc>().add(FetchCategoryAttractionsEvent(category.id));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryAttractionsPage(category: category),
          ),
        );
      },
      child: Hero(
        tag: "category_${category.id}",
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Category image (with placeholder if null)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: category.image ?? placeholder,
                  fit: BoxFit.cover,
                  placeholder: (ctx, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (ctx, url, err) => const Icon(Icons.error),
                ),
              ),
              // Gradient overlay at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
