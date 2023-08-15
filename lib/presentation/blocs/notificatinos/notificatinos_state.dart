part of 'notificatinos_bloc.dart';

class NotificatinosState extends Equatable {

  final AuthorizationStatus status;
  final List<PushMessage> notificatinos;

  const NotificatinosState({
    this.status       = AuthorizationStatus.notDetermined,
    this.notificatinos = const [],
  });

  NotificatinosState copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notificatinos
  }) => NotificatinosState(
    status: status ?? this.status,
    notificatinos: notificatinos ?? this.notificatinos,
  );
  
  @override
  List<Object> get props => [ status, notificatinos ];

}
