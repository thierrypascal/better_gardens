import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyGardenEdit extends StatefulWidget {
  MyGardenEdit({Key key}) : super(key: key);

  @override
  _MyGardenEditState createState() => _MyGardenEditState();
}

class _MyGardenEditState extends State<MyGardenEdit> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _gartenType;
  String _address;

  final List<String> menuItems = [
    'Familiengarten',
    'Hausgarten',
    'Dachgarten',
    'Balkon / Terrase',
    'Gemeinschaftsgarten',
    'Innenhof'
  ];

  @override
  Widget build(BuildContext context) {
    final garden = Provider.of<Garden>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Garten'),
      ),
      drawer: MyDrawer(),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$_name bearbaiten'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: TextFormField(
                  initialValue: garden.name,
                  decoration: const InputDecoration(
                      labelText: 'Spitzname Garten',
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) => _name = value,
                ),
              ),
              const SizedBox(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _gartenType,
                      items: [
                        //TODO do not hardcode these values
                        const DropdownMenuItem<String>(
                          value: '1',
                          child: Center(child: Text('Familiengarten')),
                        ),
                        const DropdownMenuItem<String>(
                          value: '2',
                          child: Center(child: Text('Hausgarten')),
                        ),
                        const DropdownMenuItem<String>(
                          value: '3',
                          child: Center(child: Text('Dachgarten')),
                        ),
                        const DropdownMenuItem<String>(
                          value: '4',
                          child: Center(child: Text('Balkon / Terrase')),
                        ),
                        const DropdownMenuItem<String>(
                          value: '5',
                          child: Center(child: Text('Gemeinschaftsgarten')),
                        ),
                        const DropdownMenuItem<String>(
                          value: '6',
                          child: Center(child: Text('Innenhof')),
                        ),
                      ],

                      onChanged: (String _value) => {
                        setState(() {
                          _gartenType = _value;

                          print(_value);
                        }),
                      },
                      //hint: const Text('Gartentyp'),
                    ),
                  ),
                ),
              ),

              const SizedBox(),

              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: TextFormField(
                  initialValue: garden.street,
                  decoration: const InputDecoration(
                      labelText: 'Garten Adresse',
                      contentPadding: EdgeInsets.symmetric(vertical: 4)),
                  onSaved: (value) => _address = value,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.cancel_outlined),
                            ),
                            const Text('Abbrechen')
                          ]),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _formKey.currentState.save();
                            // garden.updateGardenData(
                            //   newGarten: _name,
                            //   newAddress: _address,
                            //   newType: _gartenType,
                            // );
                            Navigator.of(context).pop();
                          },
                          child: Row(children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(Icons.save),
                            ),
                            const Text('Speichern')
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              //Todo IMAGE select and show
            ],
          ),
        ),
      ),
    );
  }
}
// _handleTopMenu(String value, BuildContext context) {

// switch(value){
//   case 'EditGardenPage':
//   {
//     var setState;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//           insetPadding: const EdgeInsets.all(5),
//           scrollable: true,
//           title: const Center(child: Text('Garten bearbeiten')),
//           content: StatefulBuilder(
//             builder: (BuildContext context,setState){
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 child: Form(
//                   key: _formKey,

//               );
//             }
//             ),
//             actions: [
//               ElevatedButton(
//                 child: Row(children: [
//                   const Padding(
//                     padding: EdgeInsets.only(right: 8),
//                     child: Icon(Icons.cancel_outlined),
//                   ),
//                   const Text('Abbrechen')
//                 ]),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               ElevatedButton(
//                 child: Row(children: [
//                   const Padding(
//                     padding: EdgeInsets.only(right: 8),
//                     child: Icon(Icons.save),
//                   ),
//                   const Text('Speichern')
//                 ]),
//                 onPressed: (){
//                   _formKey.currentState.save();
//                   // garden.updateGardenData(
//                   //   newGarten: _name,
//                   //   newAddress: _address,
//                   //   newType: _gartenType,
//                   // );
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//     ),
//     );
//     break;
//   }
