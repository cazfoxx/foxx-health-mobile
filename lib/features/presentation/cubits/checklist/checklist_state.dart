part of 'checklist_cubit.dart';

abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object?> get props => [];
}

class ChecklistInitial extends ChecklistState {}

class ChecklistLoading extends ChecklistState {}

class ChecklistCreated extends ChecklistState {
  final ChecklistModel checklist;

  const ChecklistCreated(this.checklist);

  @override
  List<Object?> get props => [checklist];
}

class ChecklistsLoaded extends ChecklistState {
  final List<ChecklistModel> checklists;

  const ChecklistsLoaded(this.checklists);

  @override
  List<Object?> get props => [checklists];
}

class ChecklistLoaded extends ChecklistState {
  final ChecklistModel checklist;

  const ChecklistLoaded(this.checklist);

  @override
  List<Object?> get props => [checklist];
}

class ChecklistUpdated extends ChecklistState {
  final ChecklistModel checklist;

  const ChecklistUpdated(this.checklist);

  @override
  List<Object> get props => [checklist];
}

class ChecklistDeleted extends ChecklistState {
  final int checklistId;

  const ChecklistDeleted(this.checklistId);

  @override
  List<Object> get props => [checklistId];
}

class ChecklistError extends ChecklistState {
  final String message;

  const ChecklistError(this.message);

  @override
  List<Object?> get props => [message];
}