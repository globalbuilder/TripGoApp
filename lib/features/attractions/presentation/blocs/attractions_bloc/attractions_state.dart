// lib/features/attractions/presentation/blocs/attractions_bloc/attractions_state.dart

import 'package:equatable/equatable.dart';
import '../../../domain/entities/attraction_entity.dart';

enum AttractionsStatus { initial, loading, loaded, error }

class AttractionsState extends Equatable {
  final AttractionsStatus status;

  final List<AttractionEntity> attractions;
  final AttractionEntity? selectedAttraction; // For detail
  final String? errorMessage;

  const AttractionsState({
    required this.status,
    required this.attractions,
    this.selectedAttraction,
    this.errorMessage,
  });

  factory AttractionsState.initial() => const AttractionsState(
        status: AttractionsStatus.initial,
        attractions: [],
      );

  AttractionsState copyWith({
    AttractionsStatus? status,
    List<AttractionEntity>? attractions,
    AttractionEntity? selectedAttraction,
    String? errorMessage,
  }) {
    return AttractionsState(
      status: status ?? this.status,
      attractions: attractions ?? this.attractions,
      selectedAttraction: selectedAttraction,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, attractions, selectedAttraction, errorMessage];
}
