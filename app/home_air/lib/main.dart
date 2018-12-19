import 'package:flutter/material.dart';
import 'model.dart';
import 'statistics.dart';
// import 'local.dart';
import 'request.dart';

void main() => runApp(MyApp());

final levelColors = <Color>[
  Colors.green[300],
  Colors.lightGreen[300],
  Colors.yellow[300],
  Colors.orange[300],
  Colors.red
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[400],
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
          )
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.white
        )
      ),
      home: HomePage(title: '家庭空气环境监测'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _useLocalData = false;
  String _input = '';

  AirHealth _data = AirHealth.fromEmpty();

  TextStyle _getFont1() {
    return new TextStyle(fontSize: 14, color: Colors.black26);
  }

  TextStyle _getFont2() {
    return new TextStyle(fontSize: 14, color: Colors.black38);
  }

  Widget _generateDispalyCard(String field, String name, String unit, AirHealth data, Color cardBg) {
    Map map = data.toJson();
    return new Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8)
      ),
      child: new Column(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(name, style: new TextStyle(
                      fontSize: 16, color: Colors.black54
                    ),),
                    new Text(unit, style: new TextStyle(
                      fontSize: 16, color: Colors.black38
                    ),),
                  ],
                ),
                new Expanded(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new Text(map[field].toString(), style: new TextStyle(
                        fontSize: 36, fontWeight: FontWeight.w500, color: Colors.white
                      ),)
                    ]
                  ),
                )
              ]
            ),
          ),
          new Divider(),
          new Container(
            // padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    new Text('最大', style: _getFont1()),
                    new Text(map['${field}_max'].toString(), style: _getFont2()),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Text('平均', style: _getFont1()),
                    new Text(map['${field}_avg'].toString(), style: _getFont2()),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Text('最小', style: _getFont1()),
                    new Text(map['${field}_min'].toString(), style: _getFont2()),
                  ],
                ),
              ]
            ),
          )
        ],
      )
    );
  }

  List<Widget> _generateMainContent() {
    List<Widget> _ret = [
      new GridView.count(
        childAspectRatio: 1.0,
        shrinkWrap: true,
        primary: false,
        crossAxisSpacing: 24.0,
        mainAxisSpacing: 24.0,
        crossAxisCount: 2,
        children: <Widget>[
          _generateDispalyCard('formaldehyde', '甲醛', 'ppm', _data, levelColors[0]),
          _generateDispalyCard('pm25', 'PM2.5', 'ug/m3', _data, levelColors[0]),
          _generateDispalyCard('temperature', '温度', '度', _data, levelColors[0]),
          _generateDispalyCard('humidity', '湿度', '%', _data, levelColors[0]),
        ],
      ),
      new Divider(),
      new Row(
        children: <Widget>[
          new Expanded(flex: 1, child: new Text('使用局域网实时数据', style: TextStyle(fontSize: 16, color: Colors.black45),),),
          new Switch(
            value: _useLocalData,
            onChanged: (v) {
              setState(() {
                _useLocalData = v;
              });
            },
          )
        ],
      ),
    ];
    if (_data.latest_time != null) {
      _ret.insert(1,
        new Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(0, 12, 0, 4),
          child: new Text('注：最新数据采集于 ${_data.latest_time.toLocal()}', style: new TextStyle(color: Colors.grey[400]),),
        )
      );
    }
    if (_useLocalData) {
      _ret.add(
        new TextField(
          autofocus: true,
          decoration: InputDecoration(labelText: '请输入局域网服务器地址'),
          onChanged: (v) {
            setState(() {
              _input = v;
            });
          },
        )
      );
    }
    return _ret;
  }

  @override
  void initState() {
    super.initState();
    http.getTodayData().then((value) {
      setState(() {
        _data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // printIps();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.equalizer),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                builder: (context) => BarChart.withSampleData()
              ));
            }
          )
        ],
      ),
      body: new SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(24),
        child: new Column(
          children: _generateMainContent(),
        ),
      )
    );
  }
}
