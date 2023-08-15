import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/domain/entities/push_message.dart';

import 'package:push_app/firebase_options.dart';

part 'notificatinos_event.dart';
part 'notificatinos_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificatinosBloc extends Bloc<NotificatinosEvent, NotificatinosState> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  int pushNumberId = 0;
  final Future<void> Function()? requestLocalNotificationsPermission;
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })? showLocalNotifications;

  NotificatinosBloc({
    this.requestLocalNotificationsPermission,
    this.showLocalNotifications
  }) : super( const NotificatinosState() ) {
    on<NotificationStatusChanged>( _notificationStatusChanged );
    on<NotificationReceived>( _onOushMessageReceived );
    _initialStatusCheck();
    _onForegraoundMessage();
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add( NotificationStatusChanged( settings.authorizationStatus ) );
    _getAccesToken();
  }

  void handleRemoteMessage( RemoteMessage message ) {

    if( message.notification == null ) return;

    final notification = PushMessage(
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title    : message.notification!.title ?? '',
      body     : message.notification!.body ?? '',
      sentDate : message.sentTime ?? DateTime.now(),
      data     : message.data,
      imageUrl : Platform.isAndroid ? message.notification!.android?.imageUrl : message.notification!.apple?.imageUrl
    );

    if( showLocalNotifications != null ) {
      showLocalNotifications!(
        id    : ++pushNumberId,
        body  : notification.body,
        data  : notification.messageId,
        title : notification.title
      );
    }

    add(NotificationReceived(notification));
  }

  void _onForegraoundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void _notificationStatusChanged( NotificationStatusChanged event, Emitter<NotificatinosState> emit ) {
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getAccesToken();
  }

  void _onOushMessageReceived( NotificationReceived event, Emitter<NotificatinosState> emit ) {
    emit(
      state.copyWith(
        notificatinos: [event.notifications, ...state.notificatinos ]
      )
    );
    _getAccesToken();
  }

    void _getAccesToken() async {

      if( state.status != AuthorizationStatus.authorized ) return;

      final token = await messaging.getToken();
      // ignore: avoid_print
      print('token: $token');
    }

  static Future<void> initializedFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void requestPermission() async {

    NotificationSettings settings = await messaging.requestPermission(
      alert         : true,
      announcement  : false,
      badge         : true,
      carPlay       : false,
      criticalAlert : true,
      provisional   : false,
      sound         : true,
    );

    if( requestLocalNotificationsPermission != null ) {
      await requestLocalNotificationsPermission!();
      // await LocalNotiofications.requestPermissionLocalNotifications();
    } 

    add( NotificationStatusChanged(settings.authorizationStatus) );
  }

  PushMessage? getMessageById( String pushMessageId ) {
    final exist = state.notificatinos.any( (message) => message.messageId == pushMessageId );
    if( !exist ) return null;

    return state.notificatinos.firstWhere((message) => message.messageId == pushMessageId );
  }

}
