class FAQ
{
  int id;
  var question;
  var reponce ;
  var activer ;
  var image ;
  var video ;
  var file_image ;
  var file_video ;


  FAQ({
    required this.id,
    this.question,
    this.reponce,
    this.activer,
    this.image,
    this.video,
    this.file_image,
    this.file_video
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {

    return FAQ(
      id: json['id'],
      question: json['question'],
      reponce: json['reponce'],
      activer: json['activer'],
      image: json['image'],
      video: json['video'],
      file_image: json['file_image'],
      file_video: json['file_video'],

    );
  }

}