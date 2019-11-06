import 'package:flutter/material.dart';
import 'package:weathernow/widgets/weather-view.dart';

class Search {
  String name;
  DateTime dateTime;

  Search({this.name, this.dateTime});
}

class SearchPage extends StatefulWidget {
  SearchPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchData());
            },
          )
        ],
      ),
    );
  }
}

class SearchData extends SearchDelegate<String> {
  final cities = ["Oshawa", "Markham", "Toronto", "Kingston", "London"];

  final recentCities = ["Oshawa", "Markham", "Toronto"];

  @override
  List<Widget> buildActions(BuildContext context) {
    //execute app bar actions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //output the result
    print(query);
    return WeatherView(title: query + ', ON');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // multiple selections
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }
}