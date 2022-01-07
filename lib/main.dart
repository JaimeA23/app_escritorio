import 'package:flutter/material.dart';
import 'ClientModel.dart';
import 'clases/agregar.dart';
import 'dart:math' as math;
import 'clases/usuario.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class TodoItem {
  String title;
  bool done;

  TodoItem({this.title, this.done});

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['title'] = title;
    m['done'] = done;

    return m;
  }
}

class TodoList {
  List<User> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

class _MyAppState extends State<MyApp> {
  final TodoList list = new TodoList();
  final LocalStorage storage = new LocalStorage('data_thera_app');
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hello Thera"),
          backgroundColor: Colors.red.withOpacity(0.8),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Agregar();
                    },
                    child: Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      setState(() {});
                    },
                    child: Icon(Icons.autorenew),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      advertenciaactualizar();
                    },
                    child: Icon(Icons.payment),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      eliminarultimo();
                    },
                    child: Icon(Icons.delete),
                  )
                ],
              ),
            )
          ],
        ),
        body: Container(
            padding: EdgeInsets.all(10.0),
            constraints: BoxConstraints.expand(),
            child: FutureBuilder(
              future: storage.ready,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!initialized) {
                  var items = storage.getItem('todos');
                  print("items");
                  print(items);
                  if (items != null) {
                    list.items = List<User>.from(
                      (items as List).map(
                        (item) => User(
                          id: item['id'],
                          nombre: item['Nombre'],
                          tier1: item['tier1'],
                          tier2: item['tier2'],
                          tier3: item['tier3'],
                          puntaje: item['puntaje'],
                          reward: item['reward'],
                          actividad: item['activo'],
                          tierActual: item['tieractual'],
                          Fechacreacion: item['fechacreacion'],
                          Fechaedicion: item['fechadeedicion'],
                        ),
                      ),
                    );
                  }

                  initialized = true;
                }

                List<Widget> widgets = list.items.map((item) {
                  return Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        advertenciadelete(item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: item.reward > 0 ? Colors.red : Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: <Widget>[
                            ExpansionTile(
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1, // 20%
                                    child: Column(
                                      children: <Widget>[
                                        item.tierActual == "1"
                                            ? Image(
                                                image:
                                                    AssetImage("assets/1.png"),
                                                height: 30)
                                            : item.tierActual == "2"
                                                ? Image(
                                                    image: AssetImage(
                                                        "assets/2.png"),
                                                    height: 30)
                                                : Image(
                                                    image: AssetImage(
                                                        "assets/3.png"),
                                                    height: 30),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5, // 20%
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                item.nombre,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4, // 20%
                                    // child: Text("${DateTime.parse(item.Fechaedicion).minute} - ${DateTime.parse(item.Fechaedicion).month}/${DateTime.parse(item.Fechaedicion).year}",style: TextStyle(color: Colors.black),),
                                    child: Text(
                                      "${DateTime.parse(item.Fechaedicion).day} / ${DateTime.parse(item.Fechaedicion).month} / ${DateTime.parse(item.Fechaedicion).year}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1, // 20%
                                    child: Checkbox(
                                      onChanged: (bool value) {
                                        _toggleItem(item);
                                        setState(() {});
                                      },
                                      value: item.actividad == null
                                          ? false
                                          : item.actividad,
                                    ),
                                  ),
                                ],
                              ),
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text("Toronja:  "),
                                            Text(" ${item.tier1}"),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("Lime:  "),
                                            Text(" ${item.tier2}"),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "Pomegranate:  ",
                                              maxLines: 1,
                                            ),
                                            Text(" ${item.tier3}"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 2, // 20%
                                      child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Text("Point"),
                                              Text(" ${item.puntaje}/12"),
                                            ],
                                          ),
                                          color: Colors.grey.withOpacity(0.9)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 2, // 20%
                                      child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Text("Reward"),
                                              Text(" ${item.reward}"),
                                            ],
                                          ),
                                          color: Colors.grey.withOpacity(0.9)),
                                    ),
                                    Expanded(
                                      flex: 2, // 20%
                                      child: FlatButton(
                                        onPressed: () {
                                          Editar(item);
                                        },
                                        child: Icon(Icons.edit),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2, // 20%
                                      child: FlatButton(
                                        onPressed: () {
                                          if (item.reward > 0) {
                                            advertenentrega(item);
                                          }
                                        },
                                        child: Icon(Icons.check),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ));
                }).toList();

                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ListView(
                        children: widgets,
                      ),
                    ),
                  ],
                );
              },
            )));
  }

  void Agregar() {
    final _formKey = GlobalKey<FormState>();
    User usernv = User();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Nombre:"),
                          TextFormField(
                            onChanged: (text) {
                              usernv.nombre = text;
                            },
                            //  onSaved: (input) => usernv.nombre = input,
                            decoration: InputDecoration(
                              labelText: "Nombre",
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColorDark),
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'Ingresa el Name',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.perm_identity,
                                  color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Tier Actual:"),
                          Row(
                            children: <Widget>[
                              Image(
                                  image: AssetImage("assets/1.png"),
                                  height: 30),
                              Text("Toronja"),
                              Checkbox(
                                onChanged: (bool value) {
                                  usernv.tierActual = "1";
                                  setState(() {
                                    usernv.tierActual = "1";
                                  });
                                },
                                value: usernv.tierActual == "1" ? true : false,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Image(
                                  image: AssetImage("assets/2.png"),
                                  height: 30),
                              Text("Lime"),
                              Checkbox(
                                onChanged: (bool value) {
                                  usernv.tierActual = "2";
                                  setState(() {
                                    usernv.tierActual = "2";
                                  });
                                },
                                value: usernv.tierActual == "2" ? true : false,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Image(
                                  image: AssetImage("assets/3.png"),
                                  height: 30),
                              Text("PomoGranate"),
                              Checkbox(
                                onChanged: (bool value) {
                                  usernv.tierActual = "3";
                                  setState(() {
                                    usernv.tierActual = "3";
                                  });
                                },
                                value: usernv.tierActual == "3" ? true : false,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  "Guardar",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.8),
                                onPressed: () async {
                                  Agregarfuncion(usernv);
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FlatButton(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                                color: Colors.red.withOpacity(0.8),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void Agregarfuncion(usernv) async {
    if (usernv.nombre == null || usernv.tierActual == null) {
      print(usernv.nombre);
      print(usernv.tierActual);
    } else {
      switch (usernv.tierActual) {
        case "1":
          {
            usernv.tier1 = 1;
            usernv.tier2 = 0;
            usernv.tier3 = 0;
          }
          break;
        case "2":
          {
            usernv.tier1 = 0;
            usernv.tier2 = 1;
            usernv.tier3 = 0;
          }
          break;
        case "3":
          {
            usernv.tier1 = 0;
            usernv.tier2 = 0;
            usernv.tier3 = 1;
          }
          break;
      }

      usernv.puntaje = 0;
      usernv.reward = 0;
      usernv.actividad = true;
      usernv.Fechacreacion = "${DateTime.now()}";
      usernv.Fechaedicion = "${DateTime.now()}";

      print(usernv.nombre);
      print(usernv.Fechacreacion);
      print("${usernv}");

      setState(() {});
      //    loadingDialog();
      //   _con.login();
      Navigator.pop(context);
    }

    _addItem(usernv);
  }

  _toggleItem(User item) {
    setState(() {
      item.actividad = !item.actividad;
      _saveToStorage();
    });
  }

  _addItem(usernv) {
    setState(() {
      //  final item = new TodoItem(title: title, done: false);
      final item = usernv;
      list.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('todos', list.toJSONEncodable());
  }

  void advertenciaactualizar() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              content: Container(
                padding: EdgeInsets.all(10),
                height: 110,
                child: Column(
                  children: <Widget>[
                    Text(
                        'Estas segura que ya actualizaste los datos de tus patreons'),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          color: Colors.green,
                          onPressed: () {
                            actualizar();
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text("si"),
                        ),
                        SizedBox(width: 20),
                        FlatButton(
                          color: Colors.red,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text("No"),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  void Editar(item) {
    final _formKey = GlobalKey<FormState>();
    User usernv = User();
    usernv = item;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Nombre:"),
                          TextFormField(
                            onChanged: (text) {
                              usernv.nombre = text;
                            },
                            //  onSaved: (input) => usernv.nombre = input,
                            decoration: InputDecoration(
                              labelText: item.nombre,
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColorDark),
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'Ingresa el Name',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.perm_identity,
                                  color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Tier Actual:"),
                          Row(
                            children: <Widget>[
                              Image(
                                  image: AssetImage("assets/1.png"),
                                  height: 30),
                              Text("Toronja"),
                              Checkbox(
                                onChanged: (bool value) {
                                  usernv.tierActual = "1";
                                  setState(() {
                                    usernv.tierActual = "1";
                                  });
                                },
                                value: usernv.tierActual == "1" ? true : false,
                              ),
                              Container(
                                width: 50,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) {
                                    usernv.tier1 = int.parse(text);
                                  },
                                  decoration: InputDecoration(
                                    labelText: "${item.tier1}",
                                    labelStyle: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: 'Ingresa el Numero del tier',
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.7)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Image(
                                  image: AssetImage("assets/2.png"),
                                  height: 30),
                              Text("Lime"),
                              Checkbox(
                                onChanged: (bool value) {
                                  usernv.tierActual = "2";
                                  setState(() {
                                    usernv.tierActual = "2";
                                  });
                                },
                                value: usernv.tierActual == "2" ? true : false,
                              ),
                              Container(
                                width: 50,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) {
                                    usernv.tier2 = int.parse(text);
                                  },
                                  decoration: InputDecoration(
                                    labelText: "${item.tier2}",
                                    labelStyle: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: 'Ingresa el Numero del tier',
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.7)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Image(
                                  image: AssetImage("assets/3.png"),
                                  height: 30),
                              Text("PomoGranate"),
                              Checkbox(
                                onChanged: (bool value) {
                                  usernv.tierActual = "3";
                                  setState(() {
                                    usernv.tierActual = "3";
                                  });
                                },
                                value: usernv.tierActual == "3" ? true : false,
                              ),
                              Container(
                                width: 50,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) {
                                    usernv.tier3 = int.parse(text);
                                  },
                                  decoration: InputDecoration(
                                    labelText: "${item.tier3}",
                                    labelStyle: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorDark),
                                    contentPadding: EdgeInsets.all(12),
                                    hintText: 'Ingresa el Numero del tier',
                                    hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.7)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2))),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5))),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text("Acumulado Reward:"),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              usernv.reward = int.parse(text);
                            },
                            //   onSaved: (input) => usernv.tierActual = input,
                            decoration: InputDecoration(
                              labelText: "${item.reward}",
                              labelStyle: TextStyle(
                                  color: Theme.of(context).primaryColorDark),
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'Ingresa cantidad de reward',
                              hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.7)),
                              prefixIcon: Icon(Icons.dialpad,
                                  color: Theme.of(context).primaryColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.2))),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              FlatButton(
                                child: Text(
                                  "Cambiar",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.8),
                                onPressed: () async {
                                  if (usernv.nombre == null ||
                                      usernv.tierActual == null) {
                                    print(usernv.nombre);
                                    print(usernv.tierActual);
                                  } else {
                                    var temppuntaje = usernv.tier1 +
                                        usernv.tier2 * 2 +
                                        usernv.tier3 * 3;
                                    if (temppuntaje >= 12) {
                                      var restemp = 0;

                                      if (usernv.tier3 >= 4) {
                                        usernv.tier3 = usernv.tier3 - 4;
                                        usernv.reward = usernv.reward + 1;
                                      } else {
                                        restemp = usernv.tier3 * 3;
                                        usernv.tier3 = 0;

                                        while (
                                            restemp < 12 && usernv.tier2 > 0) {
                                          restemp = restemp + 2;
                                          usernv.tier2 = usernv.tier2 - 1;
                                        }

                                        if (restemp >= 12) {
                                          usernv.reward = usernv.reward + 1;
                                        } else {
                                          while (restemp < 12) {
                                            restemp = restemp + 1;
                                            usernv.tier1 = usernv.tier1 - 1;
                                          }

                                          if (restemp >= 12) {
                                            usernv.reward = usernv.reward + 1;
                                          }
                                        }
                                      }
                                    }
                                    temppuntaje = usernv.tier1 +
                                        usernv.tier2 * 2 +
                                        usernv.tier3 * 3;
                                    usernv.puntaje = temppuntaje;
                                    _saveToStorage();
                                    setState(() {});

                                    Navigator.pop(context);
                                  }
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FlatButton(
                                child: Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                ),
                                color: Colors.red.withOpacity(0.8),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void advertenentrega(item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              content: Container(
                padding: EdgeInsets.all(10),
                height: 110,
                child: Column(
                  children: <Widget>[
                    Text(
                        'Estas segura que ya entregaste la recompensa a este usuario?'),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          color: Colors.green,
                          onPressed: () {
                            entregar(item);
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text("si"),
                        ),
                        SizedBox(width: 20),
                        FlatButton(
                          color: Colors.red,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text("No"),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  entregar(User item) {
    setState(() {
      item.reward = item.reward - 1;
      _saveToStorage();
    });
  }

  void actualizar() async {
    list.items.map((item) {
      print("item probando autoactualizar");
      print(item);
      mesificador(item);
    }).toList();

    setState(() {});
  }

  void mesificador(item) async {
    var mesactual = DateTime.now().month;
    var mesusuario = DateTime.parse(item.Fechaedicion).month;

    if (item.actividad) {
      if (mesactual != mesusuario) {
        switch (item.tierActual) {
          case "1":
            {
              item.tier1 = item.tier1 + 1;
            }
            break;
          case "2":
            {
              item.tier2 = item.tier2 + 1;
            }
            break;
          case "3":
            {
              item.tier3 = item.tier3 + 1;
            }
            break;
        }
        var temppuntaje = item.tier1 + item.tier2 * 2 + item.tier3 * 3;

        if (temppuntaje >= 12) {
          var restemp = 0;

          if (item.tier3 >= 4) {
            item.tier3 = item.tier3 - 4;
            item.reward = item.reward + 1;
          } else {
            restemp = item.tier3 * 3;
            item.tier3 = 0;

            print("prewghile $restemp");
            while (restemp < 12 && item.tier2 > 0) {
              restemp = restemp + 2;
              item.tier2 = item.tier2 - 1;
              print("in while t2 ${item.tier2} restep $restemp");
            }

            if (restemp >= 12) {
              item.reward = item.reward + 1;
            } else {
              while (restemp < 12) {
                restemp = restemp + 1;
                item.tier1 = item.tier1 - 1;
              }

              if (restemp >= 12) {
                item.reward = item.reward + 1;
              }
            }
          }
        }
        temppuntaje = item.tier1 + item.tier2 * 2 + item.tier3 * 3;
        item.puntaje = temppuntaje;
        item.Fechaedicion = DateTime.now();
        //   await DBProvider.db.editUser(item);
      } else {
        var temppuntaje = item.tier1 + item.tier2 * 2 + item.tier3 * 3;
        if (temppuntaje >= 12) {
          var restemp = 0;

          if (item.tier3 >= 4) {
            item.tier3 = item.tier3 - 4;
            item.reward = item.reward + 1;
          } else {
            restemp = item.tier3 * 3;
            item.tier3 = 0;

            print("prewghile $restemp");
            while (restemp < 12 && item.tier2 > 0) {
              restemp = restemp + 2;
              item.tier2 = item.tier2 - 1;
              print("in while t2 ${item.tier2} restep $restemp");
            }

            if (restemp >= 12) {
              item.reward = item.reward + 1;
            } else {
              while (restemp < 12) {
                restemp = restemp + 1;
                item.tier1 = item.tier1 - 1;
              }

              if (restemp >= 12) {
                item.reward = item.reward + 1;
              }
            }
          }
        }
        temppuntaje = item.tier1 + item.tier2 * 2 + item.tier3 * 3;
        item.puntaje = temppuntaje;
        // await DBProvider.db.editUsersinmodificarfecha(item);
      }
    } else {
      var temppuntaje = item.tier1 + item.tier2 * 2 + item.tier3 * 3;
      if (temppuntaje >= 12) {
        var restemp = 0;

        if (item.tier3 >= 4) {
          item.tier3 = item.tier3 - 4;
          item.reward = item.reward + 1;
        } else {
          restemp = item.tier3 * 3;
          item.tier3 = 0;

          print("prewghile $restemp");
          while (restemp < 12 && item.tier2 > 0) {
            restemp = restemp + 2;
            item.tier2 = item.tier2 - 1;
            print("in while t2 ${item.tier2} restep $restemp");
          }

          if (restemp >= 12) {
            item.reward = item.reward + 1;
          } else {
            while (restemp < 12) {
              restemp = restemp + 1;
              item.tier1 = item.tier1 - 1;
            }

            if (restemp >= 12) {
              item.reward = item.reward + 1;
            }
          }
        }
      }
      temppuntaje = item.tier1 + item.tier2 * 2 + item.tier3 * 3;
      item.puntaje = temppuntaje;
      //  await DBProvider.db.editUsersinmodificarfecha(item);
    }

    _saveToStorage();
  }

  void advertenciadelete(item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              content: Container(
                padding: EdgeInsets.all(10),
                height: 140,
                child: Column(
                  children: <Widget>[
                    Text(
                        'Estas segura que quieres eliminar este patreon? los datos no se podran recuperar'),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          color: Colors.green,
                          onPressed: () {
                            borrraritem(item);
                            //              DBProvider.db.deleteClient2(itemid);
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text("si"),
                        ),
                        SizedBox(width: 20),
                        FlatButton(
                          color: Colors.red,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text("No"),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  void borrraritem(itemborrrar) {
    list.items.removeWhere((item) => item == itemborrrar);
    _saveToStorage();
  }

  void eliminarultimo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              content: Container(
                padding: EdgeInsets.all(10),
                height: 110,
                child: Column(
                  children: <Widget>[
                    Text(
                        'Estas segura que quieres eliminar el ultimo item'),
                    Row(
                      children: <Widget>[
                        FlatButton(
                          color: Colors.green,
                          onPressed: () {
                            borrarultimo();
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text("si"),
                        ),
                        SizedBox(width: 20),
                        FlatButton(
                          color: Colors.red,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                          child: Text("No"),
                        )
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  void borrarultimo() {
    list.items.removeLast();
    _saveToStorage();
  }
}
