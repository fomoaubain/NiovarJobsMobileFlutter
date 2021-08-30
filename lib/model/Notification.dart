import 'package:niovarjobs/model/Inscrire.dart';

class Notifications {
  int id;
  String chemin;
  String description;
  Inscrire sender;
  Inscrire receiver;
  String created;

  Notifications(
      {
        required  this.id,
        required this.chemin,
        required  this.description,
        required this.sender,
        required this.receiver,
        required this.created,
      });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      chemin: json['chemin'],
      description: json['description'],
      sender:Inscrire.fromJson(json['sender']) ,
      receiver:Inscrire.fromJson(json['receiver']) ,
      created: json['created'],

    );
  }


}