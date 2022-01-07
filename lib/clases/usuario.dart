class User {
  int id;
  String nombre;
  int tier1;
  int tier2;
  int tier3;
  int puntaje;
  int reward;
  bool actividad;
  String tierActual;
  String Fechacreacion;
  String Fechaedicion;
  User.init();


  User({
    this.id,
    this.nombre,
    this.tier1,
    this.tier2,
    this.tier3,
    this.puntaje,
    this.reward,
    this.actividad,
    this.tierActual,
    this.Fechacreacion,
    this.Fechaedicion,

  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
    id: json["id"],
    nombre: json["Nombre"],
    tier1: json["tier1"],
    tier2: json["tier2"],
    tier3: json["tier3"],
    puntaje: json["puntaje"],
    reward: json["reward"],
    actividad:  json["activo"] == 1,
    tierActual: json["tieractual"],
    Fechacreacion: json["fechacreacion"]==null? json["fechacreacions"] :json["fechacreacion"],
    Fechaedicion: json["fechadeedicion"]==null? json["fechadeedicions"] :json["fechadeedicion"],
  );





  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Nombre': nombre,
      'tier1': tier1,
      'tier2': tier2,
      'tier3': tier3,
      'puntaje': puntaje,
      'reward' : reward,
      'activo': actividad,
      'tieractual': tierActual,
      'fechacreacion': Fechacreacion,
      'fechadeedicion': Fechaedicion,
    };
  }


   toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['id'] = id;
    m['Nombre'] = nombre;
    m['tier1'] = tier1;
    m['tier2'] = tier2;
    m['tier3'] = tier3;
    m['puntaje'] = puntaje;
    m['reward'] = reward;
    m['activo'] = actividad;
    m['tieractual'] = tierActual;
    m['fechacreacion'] = Fechacreacion;
    m['fechadeedicion'] = Fechaedicion;


    return m;
  }
}