
import 'package:equatable/equatable.dart';

abstract class SongEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Fetch extends SongEvent {}