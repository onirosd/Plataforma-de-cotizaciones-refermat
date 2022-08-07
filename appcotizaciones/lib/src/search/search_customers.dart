import 'package:flutter/material.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:provider/provider.dart';
import 'package:appcotizaciones/src/providers/customer_provider.dart';

class CustomerSearchDelegate extends SearchDelegate {
  // @override
  // TODO: implement searchFieldLabel
  //String? get searchFieldLabel => 'Buscar Cliente';
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions

    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear)) // Icon(Icons.person_search))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text('buildResults');
  }

  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 130,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    //return Text('buildSuggestions: $query');
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);
    customerProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: customerProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Customer>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final customer = snapshot.data!;

        return ListView.builder(
            itemCount: customer.length,
            itemBuilder: (_, int index) => _CustomerItem(customer[index]));
      },
    );
  }
}

class _CustomerItem extends StatelessWidget {
  final Customer customer;

  const _CustomerItem(this.customer);

  @override
  Widget build(BuildContext context) {
    customer.selectid = 'search-${customer.codCustomer}';

    return ListTile(
      leading: Hero(
        tag: customer.selectid!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'),
          image: AssetImage(
              'assets/no-image.jpg'), //NetworkImage( movie.fullPosterImg ),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text(customer.strName!),
      subtitle: Text('Ruc : ' + customer.numRucCustomer.toString()),
      trailing: Wrap(
        spacing: -20, // space between two icons
        children: <Widget>[
          TextButton(
            onPressed: () => {
              if (customer.flagForceMultimedia! == 1)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'Gallery_customer', (route) => false,
                      arguments: customer)
                }
              else
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'listQuotas', (route) => false,
                      arguments: customer)
                }
            },
            //color: Colors.orange,
            //padding: EdgeInsets.all(10.0),
            child: Column(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(Icons.receipt_long),
                Text(
                  "Cotización",
                  style: TextStyle(fontSize: 9),
                )
              ],
            ),
          ),
          TextButton(
            onPressed: () => {
              if (customer.flagForceMultimedia! == 1)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'Gallery_customer', (route) => false,
                      arguments: customer)
                }
              else
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'listBilling', (route) => false,
                      arguments: customer)
                }
            },
            child: Column(
              children: <Widget>[
                Icon(Icons.request_page_outlined),
                Text(
                  "Recibo",
                  style: TextStyle(fontSize: 9),
                )
              ],
            ),
          ),
          TextButton(
            onPressed: () => {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'Gallery_customer', (route) => false,
                  arguments: customer)
            },
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.image,
                ),
                Text(
                  "Galeria",
                  style: TextStyle(fontSize: 9),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchButtonPressed() {}
}
