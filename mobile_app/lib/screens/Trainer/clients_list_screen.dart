import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/clients_provider.dart';
import './client_details_screen.dart';

class ClientsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<ClientsProvider>(context, listen: false).fetchClients(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.error != null) {
            return Center(child: Text('An error occurred!'));
          } else {
            return Consumer<ClientsProvider>(
              builder: (ctx, clientsProvider, _) => ListView.builder(
                itemCount: clientsProvider.clients.length,
                itemBuilder: (ctx, index) {
                  final client = clientsProvider.clients[index];
                  return ListTile(
                    title: Text(client.name),
                    subtitle: Text(client.email),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ClientDetailsScreen(clientId: client.id),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
