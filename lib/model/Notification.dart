import 'package:niovarjobs/model/Inscrire.dart';

class Notifications {
  int id;
  var chemin;
  var description;
  var sender;
  var receiver;
  String created;
  String routeApp;

  Notifications(
      {
        required  this.id,
        required this.chemin,
        required  this.description,
        required this.sender,
        required this.receiver,
        required this.created,
        required this.routeApp,
      });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      chemin: json['chemin'],
      description: json['description'],
      sender: json['sender'].toString().isEmpty ? null : Inscrire.fromJson(json['sender']),
      receiver:json['receiver'].toString().isEmpty ? null : Inscrire.fromJson(json['receiver']),
      created: json['created'],
      routeApp: json['routeApp'],

    );
  }


}