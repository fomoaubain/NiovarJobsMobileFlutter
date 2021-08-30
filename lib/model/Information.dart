class Information
{
  var id;
  var Ins_id;
  var lettre ;
  var competence ;


  Information({
    required this.id, this.Ins_id, this.lettre, this.competence});

  factory Information.fromJson(Map<String, dynamic> json) {

    return Information(
      id: json['id'],
      Ins_id: json['Ins_id'],
      lettre: json['lettre'],
      competence: json['competence'],
    );
  }

}

class Experiences
{
  var id;
  var Ins_id;
  var etablissement ;
  var fonction ;
  var periode ;
  var description ;
  var enCour ;

  Experiences({
    required this.id, this.Ins_id, this.etablissement, this.fonction,this.periode,this.description,this.enCour});

  factory Experiences.fromJson(Map<String, dynamic> json) {
    return Experiences(
      id: json['id'],
      Ins_id: json['Ins_id'],
      etablissement: json['etablissement'],
      fonction: json['fonction'],
      periode: json['periode'],
      description: json['description'],
      enCour: json['enCour'],
    );
  }

}


class Autre
{
  var id;
  var Ins_id;
  var etablissement ;
  var fonction ;
  var periode ;
  var description ;
  var enCour ;


  Autre({
    required this.id, this.Ins_id, this.etablissement, this.fonction,this.periode,this.description,this.enCour});

  factory Autre.fromJson(Map<String, dynamic> json) {

    return Autre(
      id: json['id'],
      Ins_id: json['Ins_id'],
      etablissement: json['etablissement'],
      fonction: json['fonction'],
      periode: json['periode'],
      description: json['description'],
      enCour: json['enCour'],
    );
  }

}

class Education
{
  var id;
  var Ins_id;
  var etablissement ;
  var diplome ;
  var periode ;
  var description ;

  Education({
    required this.id, this.Ins_id, this.etablissement, this.diplome,this.periode,this.description});

  factory Education.fromJson(Map<String, dynamic> json) {

    return Education(
      id: json['id'],
      Ins_id: json['Ins_id'],
      etablissement: json['etablissement'],
      diplome: json['diplome'],
      periode: json['periode'],
      description: json['description'],
    );
  }

}