import 'package:FourWare/Screens/place._service.dart';
import 'package:flutter/material.dart';

class LocationSearch extends SearchDelegate<Suggestion> {
  final sessionToken;
  PlaceApiProvider apiClient;

  LocationSearch(this.sessionToken) {
    apiClient = PlaceApiProvider(sessionToken);
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: query == "" ? null : apiClient.fetchSuggestions(query),
        builder: (context, snapshot) => query == ""
            ? Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 150.0,
                  vertical: 20.0,
                ),
              )
            : snapshot.hasData
                ? ListView.builder(
                    itemBuilder: (context, i) => ListTile(
                      title: Text((snapshot.data[i] as Suggestion).description),
                      onTap: () {},
                    ),
                    itemCount: snapshot.data.length,
                  )
                : Container(
                    child: Center(child: CircularProgressIndicator()),
                  ));
  }
}
