part of 'notificatinos_bloc.dart';

class NotificatinosEvent {
  const NotificatinosEvent();
}

class NotificationStatusChanged extends NotificatinosEvent {
  final AuthorizationStatus status;
  NotificationStatusChanged(this.status);
}

class NotificationReceived extends NotificatinosEvent {
   final PushMessage notifications;
   NotificationReceived(this.notifications);
}
