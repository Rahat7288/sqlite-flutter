import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImpotant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChnagedNumber;
  final ValueChanged<String> onChnagedTitle;
  final ValueChanged<String> onChnagedDescription;
  const NoteFormWidget({
    Key? key,
    this.isImpotant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChnagedNumber,
    required this.onChnagedTitle,
    required this.onChnagedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Switch(
                    value: isImpotant ?? false,
                    onChanged: onChangedImportant,
                  ),
                  Expanded(
                    child: Slider(
                      value: (number ?? 0).toDouble(),
                      min: 0,
                      max: 5,
                      divisions: 5,
                      onChanged: (number) => onChnagedNumber(
                        number.toInt(),
                      ),
                    ),
                  ),
                ],
              ),
              buildTitle(),
              const SizedBox(
                height: 8,
              ),
              buildDescription(),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      );
  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(
            color: Colors.white70,
          ),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'this title cannot be empty'
            : null,
        onChanged: onChnagedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: const TextStyle(
          color: Colors.white60,
          fontSize: 18,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something',
          hintStyle: TextStyle(
            color: Colors.white60,
          ),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'the description can not be empty'
            : null,
        onChanged: onChnagedDescription,
      );
}
