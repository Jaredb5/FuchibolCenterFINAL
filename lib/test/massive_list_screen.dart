import 'package:flutter/material.dart';

class MassiveListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> datosMasivos = List.generate(10000, (index) => 'Dato $index');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Masiva'),
      ),
      body: ListView.builder(
        itemCount: datosMasivos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(datosMasivos[index]),
          );
        },
      ),
    );
  }
}
