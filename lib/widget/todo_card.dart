

import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deleteById;
  const TodoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById,

  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        title: Text(item['title']),
        subtitle: Text(item['description']),
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.edit_note),
          onSelected: (value) {
            if (value == 'edit') {
              // Open edit page
              navigateEdit(item);
            } else if (value == 'delete') {
              // Delete and remove item
              deleteById(id);
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ];
          },
        ),
      ),
    );
  }
}
