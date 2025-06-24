class AboutyourselfState {}

class AboutyourselfInitial extends AboutyourselfState {}

class AboutyourselfLoading extends AboutyourselfState {}

class AboutyourselfSuccess extends AboutyourselfState {}

class AboutyourselfFailure extends AboutyourselfState {
  final String errorMessage;

  AboutyourselfFailure(this.errorMessage);
}
