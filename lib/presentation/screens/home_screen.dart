import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/blocs/notificatinos/notificatinos_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NotificatinosBloc, NotificatinosState>(
          builder: (context, state) {
            return Text('${state.status}');
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.read<NotificatinosBloc>().requestPermission();
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<NotificatinosBloc, NotificatinosState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount  : state.notificatinos.length,
          itemBuilder: (context, index) {

            final notification = state.notificatinos[index];

            return ListTile(
              title   : Text(notification.title),
              subtitle: Text(notification.body),
              leading : notification.imageUrl != null ? Image.network(notification.imageUrl!) : null,
              onTap: () {
                context.push('/push-details/${notification.messageId}');
              },
            );
          },
        );
      },
    );
  }
}
