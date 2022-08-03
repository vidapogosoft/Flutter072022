import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    items: List<ListItem>.generate(
      1000,
      (i) => i % 6 == 0
          ? HeadingItem("Cabecera $i")
          : MessageItem("Detalle $i", "Mensaje del detalle $i"),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final List<ListItem> items;
  const MyApp({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Mixed List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          // Deja que ListView sepa cuántos elementos necesita para construir
          itemCount: items.length,
          // Proporciona una función de constructor. ¡Aquí es donde sucede la magia! Vamos a
          // convertir cada elemento en un Widget basado en el tipo de elemento que es.
          itemBuilder: (context, index) {
            final item = items[index];

            if (item is HeadingItem) {
              return ListTile(
                title: Text(
                  item.heading,
                  style: Theme.of(context).textTheme.headline1,
                ),
              );
            } else if (item is MessageItem) {
              return ListTile(
                title: Text(item.sender),
                subtitle: Text(item.body),
              );
            }
          },
        ),
      ),
    );
  }
}

// La clase base para los diferentes tipos de elementos que la Lista puede contener
abstract class ListItem {}

// Un ListItem que contiene datos para mostrar un encabezado
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);
}

// Un ListItem que contiene datos para mostrar un mensaje
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);
}
