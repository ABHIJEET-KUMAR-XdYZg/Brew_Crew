import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constant.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formkey=GlobalKey<FormState>();
  final List<String> sugars=['0','1','2','3','4'];

  // form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context){

    final user=Provider.of<Uid?>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid:user?.uid).userData,
      builder: (context, snapshot) {

        if(snapshot.hasData){

          UserData? userData=snapshot.data;

          return Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Text(
                  'Update your brew settings',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0,),
                TextFormField(
                  initialValue: userData?.name,
                  decoration: textInputDecoration.copyWith(hintText: 'Your name'),
                  validator: (val) => val==null || val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) => setState(() => _currentName=val),
                ),
                SizedBox(height: 20.0,),
          
                //dropdown
                DropdownButtonFormField(
                  value: _currentSugars ?? userData?.sugars ?? '0',
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _currentSugars=val),
                ),
                //slider
                SizedBox(height: 20.0,),
                Slider(
                  value: (_currentStrength ?? (userData?.strength ?? 100)).toDouble(),
                  activeColor: Colors.brown[_currentStrength ?? (userData?.strength ?? 100)],
                  inactiveColor: Colors.brown[_currentStrength ?? (userData?.strength ?? 100)],
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (val) => setState(() => _currentStrength=val.round()),
                ),
                //button
                ElevatedButton(
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async{
                    if(_formkey.currentState?.validate()==true){
                      await DatabaseService(uid:user?.uid).updateUserData(
                        _currentSugars ?? userData?.sugars ?? '0',
                        _currentName ?? userData?.name ?? 'new crew member',
                        _currentStrength ?? userData?.strength ?? 100
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[400]),
                ),
              ],
            ),
          );
        }
        else{
          return Loading();
        }
      }
    );
  }
}