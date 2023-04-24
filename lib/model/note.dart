// ignore_for_file: public_member_api_docs, sort_constructors_first
final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    id,
    isImportant,
    number,
    time,
    titile,
    description,
  ];
  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String titile = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;
  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
        id: id ?? this.id,
        createdTime: createdTime ?? this.createdTime,
        description: description ?? this.description,
        isImportant: isImportant ?? this.isImportant,
        number: number ?? this.number,
        title: title ?? this.title,
      );
// help us to read the data from the database
  static Note fromJson(Map<String, dynamic?> json) => Note(
        id: json[NoteFields.id] as int?,
        isImportant: json[NoteFields.isImportant] == 1,
        number: json[NoteFields.number] as int,
        title: json[NoteFields.titile] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
      );

  //  converting file to json for crud

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.titile: title,
        NoteFields.description: description,
        NoteFields.number: number,
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.time: createdTime.toIso8601String(),
      };
}
