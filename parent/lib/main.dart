import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDXnR2ToEK4pYw2Oa4BOVYYCzpIsnqaX-4',
      authDomain: 'digitalwellbeingms.firebaseapp.com',
      projectId: 'digitalwellbeingms',
      storageBucket: 'digitalwellbeingms.appspot.com',
      messagingSenderId: '891881982946',
      appId: '1:891881982946:android:8cf5e91ed951d6e7f207bb',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Parent Interface",
      theme: ThemeData(
        primaryColor: Colors.red, // Set primary color directly
        appBarTheme: AppBarTheme(
          color: Colors.white, // Ensure AppBar uses the primary color
        ),
      ),
      home: MyTabs(),

    );
  }
}

class MyTabs extends StatefulWidget {
  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Usimamizi wa Mtoto Kidigitali',
            style: TextStyle(
              fontSize: 25.0, // Set your desired font size here
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(child: Text(
                'Ona Matumizi',
                style: TextStyle(fontSize: 20), // Set the desired font size here
              ),),
              Tab(child: Text(
                'Thibiti Matumizi',
                style: TextStyle(fontSize: 20), // Set the desired font size here
              ),),
              Tab(child: Text(
                'Pata Ufahamu',
                style: TextStyle(fontSize: 20), // Set the desired font size here
              ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ViewTab(),
            ControlTab(),
            EffectsOfLackOfParentalControlScreen(),
          ],
        ),
      ),
    );
  }
}

class ViewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Apps').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Unganisha simu na mtandao'));
        }

        return SingleChildScrollView(
          child: Center(
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Jina la App',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Muda wa Matumizi\n', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: '(Dakika:Sekunde)', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    textAlign: TextAlign.center, // Center align the text
                  ),
                ),
              ],
              rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(data['appName'] ?? 'Unknown')),
                    DataCell(Text((data['usageTime'] ?? 'Unknown').toString())),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class ControlTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text(
                'Chaguzi za Udhibiti Matumizi',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
          rows: <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(
                  ListTile(
                    title: Text('Weka Kikomo cha Muda'),
                    onTap: () {
                      showFloatingWidget(context);
                    },
                  ),
                ),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(
                  ListTile(
                    title: Text('Zuia Matumizi ya App'),
                    onTap: () {
                      showFloatingWidgett(context);
                    },
                  ),
                ),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(
                  ListTile(
                    title: Text('Weka Kipindi cha Muda'),
                    onTap: () {
                      showTimeFrameWidget(context);
                    },
                  ),
                 ),
              ],
            ),

            DataRow(
              cells: <DataCell>[
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      blockAllApps(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: Text(
                      'Fungia App Zote',
                      style: TextStyle(color: Colors.white), // Change text color here
                    ),
                  ),
                ),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      unBlockAllApps(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    child: Text(
                      'Fungulia App Zote',
                      style: TextStyle(color: Colors.white), // Change text color here
                    ),
                  ),
                ),
              ],
            )
// Add more controls as needed
          ],
        ),
      ),
    );
  }

  void showFloatingWidget(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FloatingWidget();
      },
    );
  }

  void showFloatingWidgett(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FloatingWidgett();
      },
    );
  }

  void showTimeFrameWidget(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TimeFrameWidget();
      },
    );
  }
  void blockAllApps(BuildContext context) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Apps').get();
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (DocumentSnapshot document in snapshot.docs) {
        batch.update(document.reference, {'blocked': true});
      }

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('App zote zimedhibitiwa matumizi!'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imeshindikana kudhibiti matumizi, tafadhali jaribu tena.'),
        ),
      );
    }
  }
}

void unBlockAllApps(BuildContext context) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Apps').get();
    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (DocumentSnapshot document in snapshot.docs) {
      batch.update(document.reference, {'blocked': false});
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('App zote zimefunguliwa matumizi!'),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Imeshindikana kufungulia matumizi, tafadhali jaribu tena.'),
      ),
    );
  }
}



class FloatingWidget extends StatefulWidget {
  @override
  _FloatingWidgetState createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget> {
  Future<QuerySnapshot> fetchApps() {
    return FirebaseFirestore.instance.collection('Apps').get();
  }

  void saveTimeLimit(BuildContext context, String appId, String appName, int newTimeLimit) async {
    try {
      await FirebaseFirestore.instance
          .collection('Apps')
          .doc(appId)
          .update({'time_limit': newTimeLimit, 'blocked': false});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Muda wa matumizi kwa ajili ya $appName umewekwa!'),
        ),
      );
      Timer(Duration(minutes: newTimeLimit), () async {
        await FirebaseFirestore.instance
            .collection('Apps')
            .doc(appId)
            .update({'blocked': true, 'time_limit': 0});
      });
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Imeshindikana kuweka muda wa matumizi. Tafadhali jaribu tena.'),
        ),
      );
    }
  }

  DataRow buildAppTimeLimitField(BuildContext context, DocumentSnapshot app) {
    Map<String, dynamic> data = app.data() as Map<String, dynamic>;
    String appId = app.id;
    String appName = data['appName'] ?? 'Unknown App';
    TextEditingController timeLimitController = TextEditingController();

    return DataRow(
      cells: [
        DataCell(Text(appName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        DataCell(
          SizedBox(
            width: 60.0,
            child: TextField(
              controller: timeLimitController,
              decoration: InputDecoration(
                hintText: '0000',
                hintStyle: TextStyle(fontSize: 12),
              ),
              style: TextStyle(fontSize: 12),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 60.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // Remove default padding
                shape: CircleBorder(), // Circular shape for the button
                backgroundColor: Colors.white, // Button color
                side: BorderSide(color: Colors.green, width: 2), // Border color
              ),
              onPressed: () {
                int newTimeLimit = int.tryParse(timeLimitController.text) ?? 0;
                saveTimeLimit(context, appId, appName, newTimeLimit);
              },
              child: Icon(Icons.check, size: 20, color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: fetchApps(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Center(
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(10.0),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Weka Muda wa Matumizi',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 8.0,
                        columns: const <DataColumn>[
                          DataColumn(label: Text('Jina la App', style: TextStyle(fontSize: 12))),
                          DataColumn(label: Text('Muda', style: TextStyle(fontSize: 12))),
                          DataColumn(label: Text('Thibitisha', style: TextStyle(fontSize: 12))),
                        ],
                        rows: snapshot.data?.docs.map((app) => buildAppTimeLimitField(context, app)).toList() ?? [],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FloatingWidgett extends StatefulWidget {
  @override
  _FloatingWidgettState createState() => _FloatingWidgettState();
}

class _FloatingWidgettState extends State<FloatingWidgett> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('Apps').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong', style: TextStyle(fontSize: 14)));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Center(
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(12.0),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Orodha ya Kudhibiti Matumizi',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12.0),
                    DataTable(
                      columnSpacing: 12.0,
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Jina la App', style: TextStyle(fontSize: 12.0))),
                        DataColumn(label: Text('Dhibiti', style: TextStyle(fontSize: 12.0))),
                      ],
                      rows: snapshot.data?.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return DataRow(
                          cells: <DataCell>[
                            DataCell(Text(data['appName'] ?? 'Unknown', style: TextStyle(fontSize: 12.0))),
                            DataCell(Checkbox(
                              value: data['blocked'] ?? false,
                              onChanged: (bool? value) {
                                setState(() {
                                  FirebaseFirestore.instance.collection('Apps').doc(document.id).update({'blocked': value});
                                });
                              },
                            )),
                          ],
                        );
                      }).toList() ?? [],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class TimeFrameWidget extends StatefulWidget {
  @override
  _TimeFrameWidgetState createState() => _TimeFrameWidgetState();
}

class _TimeFrameWidgetState extends State<TimeFrameWidget> {
  Future<QuerySnapshot> fetchApps() {
    return FirebaseFirestore.instance.collection('Apps').get();
  }

  TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0); // Example start time
  TimeOfDay endTime = TimeOfDay(hour: 11, minute: 0); // Example end time

  void updateBlockedStatus(DocumentSnapshot app, TimeOfDay startTime, TimeOfDay endTime) {
    DateTime now = DateTime.now();
    DateTime startDateTime = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
    DateTime endDateTime = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    Map<String, dynamic> data = app.data() as Map<String, dynamic>;
    bool shouldBlock = now.isBefore(startDateTime) || now.isAfter(endDateTime);

    if (data['blocked'] != shouldBlock) {
      FirebaseFirestore.instance.collection('Apps').doc(app.id).update({'blocked': shouldBlock});
    }
  }

  DataRow buildAppTimeFrameField(BuildContext context, DocumentSnapshot app) {
    Map<String, dynamic> data = app.data() as Map<String, dynamic>;
    String appName = data['appName'] ?? 'Unknown App';

    return DataRow(
      cells: [
        DataCell(Text(appName, style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold))),
        DataCell(
          ElevatedButton(
            onPressed: () async {
              final pickedStartTime = await showTimePicker(
                context: context,
                initialTime: startTime,
              );
              if (pickedStartTime != null) {
                setState(() {
                  startTime = pickedStartTime;
                });
              }
            },
            child: Text('Start: ${startTime.format(context)}', style: TextStyle(fontSize: 8.0)),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(70, 24), // Adjust button size
              padding: EdgeInsets.symmetric(horizontal: 4.0),
            ),
          ),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () async {
              final pickedEndTime = await showTimePicker(
                context: context,
                initialTime: endTime,
              );
              if (pickedEndTime != null) {
                setState(() {
                  endTime = pickedEndTime;
                });
              }
            },
            child: Text('End: ${endTime.format(context)}', style: TextStyle(fontSize: 8.0)),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(70, 24), // Adjust button size
              padding: EdgeInsets.symmetric(horizontal: 4.0),
            ),
          ),
        ),
        DataCell(
          ElevatedButton(
            onPressed: () {
              updateBlockedStatus(app, startTime, endTime);
              startPeriodicUpdate(app, startTime, endTime);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kipindi cha kutumia $appName kimewekwa!', style: TextStyle(fontSize: 10.0)),
                ),
              );
              Navigator.pop(context);
            },
            child: Icon(Icons.check, size: 14.0),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(30, 24), // Adjust button size
              padding: EdgeInsets.all(2.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: fetchApps(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error', style: TextStyle(fontSize: 10.0)));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return Center(
          child: Material(
            elevation: 2.0,
            borderRadius: BorderRadius.circular(6.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Weka Kipindi cha Matumizi',
                      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    DataTable(
                      columnSpacing: 4.0,
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Jina la App', style: TextStyle(fontSize: 10.0))),
                        DataColumn(label: Text('Mwanzo', style: TextStyle(fontSize: 10.0))),
                        DataColumn(label: Text('Mwisho', style: TextStyle(fontSize: 10.0))),
                        DataColumn(label: Text('Thibitisha', style: TextStyle(fontSize: 9.0))),
                      ],
                      rows: snapshot.data?.docs.map((app) => buildAppTimeFrameField(context, app)).toList() ?? [],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class EffectsOfLackOfParentalControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jua kuhusu madhara ya ukosefu wa uangalizi wa mzazi mitandaoni.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Ukosefu wa uangalizi wa mzazi mitandaoni kwa watoto chini ya miaka 18 katika matumizi ya mitandao na simu unaweza kuwa na madhara makubwa. Watoto wanapokuwa na uhuru usio na mipaka kwenye mitandao, wanaweza kukutana na maudhui yasiyofaa kama vile ponografia, lugha chafu, na vurugu, ambayo yanaweza kuathiri maadili na tabia zao.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16), // Add space between paragraphs
            Text(
              'Pia, matumizi kupita kiasi ya simu na mitandao ya kijamii yanaweza kuathiri afya yao ya akili na kimwili, ikiwemo matatizo ya usingizi, msongo wa mawazo, na upungufu wa mawasiliano ya ana kwa ana. Ukosefu wa uangalizi unaweza pia kuwaweka watoto katika hatari ya kudhulumiwa mtandaoni na watu wasiojulikana, na hivyo kuongeza uwezekano wa kuwa wahanga wa uhalifu wa mtandao kama vile utapeli na uonevu. Kwa hiyo, ni muhimu kwa wazazi kuweka udhibiti ili kulinda ustawi wa watoto wao.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

void updateBlockedStatus(DocumentSnapshot app, TimeOfDay startTime, TimeOfDay endTime) {
  DateTime now = DateTime.now();
  DateTime startDateTime = DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
  DateTime endDateTime = DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

  Map<String, dynamic> data = app.data() as Map<String, dynamic>;
  bool shouldBlock = now.isBefore(startDateTime) || now.isAfter(endDateTime);

  if (data['blocked'] != shouldBlock) {
    FirebaseFirestore.instance.collection('Apps').doc(app.id).update({'blocked': shouldBlock});
  }
}

void startPeriodicUpdate(DocumentSnapshot app, TimeOfDay startTime, TimeOfDay endTime) {
  Timer.periodic(Duration(minutes: 1), (Timer t) => updateBlockedStatus(app, startTime, endTime));
}
