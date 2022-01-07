import 'package:flutter/material.dart';

class MainPage extends StatefulWidget{
  _AgregarWidgetState createState()=> _AgregarWidgetState();
}


class _AgregarWidgetState extends State<MainPage> {
  @override


  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();

    int _value = 1;


    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child:
            Column(children: <Widget>[
               Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Form(
                    key:_formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          //  onSaved: (input) => _con.user.email = input,
                          validator: (input) => !input.contains('@')
                              ? "S.of(context).should_be_a_valid_email"
                              : null,
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
                            prefixIcon: Icon(Icons.contact_mail,
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
                        SizedBox(height: 30),
                        FlatButton(
                          child: Text(
                            "Guardar,",
                            style: TextStyle(
                                color: Theme.of(context).scaffoldBackgroundColor),
                          ),
                          color: Theme.of(context).focusColor.withOpacity(0.8),
                          onPressed: () {
                            //    loadingDialog();
                            //   _con.login();
                          },
                        ),
                        SizedBox(height: 15),



                      ],
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go back!'),
              ),
            ],)


      ),
    );
  }
}