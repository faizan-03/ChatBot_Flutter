class Message {
  final String sender;
  final String text;
  final DateTime timestamp;

  Message({required this.sender, required this.text, required this.timestamp});

  Map<String, dynamic> toJson() => {
    // Converts the Message object to a JSON map
    'sender': sender,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
  };

  static Message fromJson(Map<String, dynamic> json) => Message(
    // Creates a Message object from a JSON map
    sender: json['sender'],
    text: json['text'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
