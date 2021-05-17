import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  TextEditingController id = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 300),
              child: TextField(
                controller: id,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'username',
                    hintText: 'Enter valid username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: pass,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  var string =
                      "http://10.0.2.2:5000/login?username=${id.text}&password=${pass.text}";
                  var resp = await http.get(string);
                  var respbody = jsonDecode(resp.body);
                  if (respbody['login'] == 'True') {
                    Fluttertoast.showToast(msg: 'Logged in');
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => DetailsPage(
                            name: respbody['name'].toString(),
                          ),
                        ));
                  } else {
                    return Fluttertoast.showToast(msg: 'Login failed');
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => RegisterPage()));
              },
              child: Text(
                'new User? Create account',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final name;
  DetailsPage({Key key, @required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController numd = TextEditingController();
    TextEditingController nums = TextEditingController();
    TextEditingController nume = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 300),
              child: TextField(
                controller: nume,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter number of employees',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: numd,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter number of days(max = 7)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: nums,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter number of shifts',
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EmployeeSchedulePage(
                          numd: numd.text,
                          nume: nume.text,
                          nums: nums.text,
                        ),
                      ));
                },
                child: Text(
                  'Get employee schedule',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController uname = TextEditingController();
    TextEditingController pass = TextEditingController();
    TextEditingController name = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 300),
              child: TextField(
                controller: uname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: pass,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter name',
                ),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  var url =
                      "http://10.0.2.2:5000/register?username=${uname.text}&password=${pass.text}&name=${name.text}";
                  await http.get(url);
                  return Fluttertoast.showToast(msg: 'Registered Successfully');
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Employee {
  int day;
  int employee;
  int shift;

  Employee({this.day, this.employee, this.shift});

  Employee.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    employee = json['employee'];
    shift = json['shift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['employee'] = this.employee;
    data['shift'] = this.shift;
    return data;
  }
}

Future<List<Employee>> fetchdata(String url) async {
  final response = await http.get(url);
  return compute(parsedata, response.body);
}

List<Employee> parsedata(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var employe = list.map((model) => Employee.fromJson(model)).toList();
  return employe;
}

class EmployeeSchedulePage extends StatefulWidget {
  final nums, numd, nume;
  EmployeeSchedulePage(
      {Key key, @required this.nums, @required this.numd, @required this.nume})
      : super(key: key);
  @override
  _EmployeeSchedulePageState createState() => _EmployeeSchedulePageState();
}

class _EmployeeSchedulePageState extends State<EmployeeSchedulePage> {
  List<Employee> n = List<Employee>();
  bool _isloading = true;
  int len = 1;
  @override
  void initState() {
    loaddata();
  }

  loaddata() async {
    String url =
        "http://10.0.2.2:5000/scheduler?nums=${widget.nums}&nume=${widget.nume}&numd=${widget.numd}";
    print(url);
    fetchdata(url).then((value) {
      n.addAll(value);
      var x = n.length;
      print(x);
      len = n[n.length - 1].day;
      print(len);
      setState(() {
        _isloading = false;
        len = n[n.length - 1].day;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Login Page"),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (!_isloading) {
              return _listItem(index);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          itemCount: len + 2,
        ));
  }

  _listItem(index) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(
              'Day ' + index.toString(),
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "Employee" +
                  n[index].employee.toString() +
                  "works on shift " +
                  n[index].shift.toString() +
                  '\nEmployee' +
                  n[index + 1].employee.toString() +
                  "works on shift " +
                  n[index + 1].shift.toString() +
                  '\nEmployee' +
                  n[index + 2].employee.toString() +
                  "works on shift " +
                  n[index + 2].shift.toString(),
              style: TextStyle(fontSize: 23),
            ),
          ],
        ));
  }
}
