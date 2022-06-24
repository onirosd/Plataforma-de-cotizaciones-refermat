import 'dart:async';

import 'package:appcotizaciones/src/helpers/debouncer_helper.dart';
import 'package:appcotizaciones/src/models/customer.dart';
import 'package:appcotizaciones/src/modelscrud/customer_crt.dart';
import 'package:flutter/cupertino.dart';

class CustomerProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey_receipt = GlobalKey<FormState>();
/*
  List<Customer> customer;
  User user;
  User prevUser;

  UserProvider({this.users, this.user});

  getUsers() => this.users;
  setUsers(List<User> users) => this.users = users;

  getUser() => this.user;
  setUser(User user) => this.user = user;


*/
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );

  final StreamController<List<Customer>> _suggestionStreamContoller =
      new StreamController.broadcast();

  Stream<List<Customer>> get suggestionStream =>
      this._suggestionStreamContoller.stream;

  Future<List<Customer>> searchCustomer(String query) async {
    CustomerCtr crt = new CustomerCtr();
    return crt.getCustomerByName(query);
  }

  void getSuggestionsByQuery(String searchTerm) async {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar: $value');
      final results = await this.searchCustomer(value);
      this._suggestionStreamContoller.add(results);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }

  insertCustomer(Customer customer) async {
    CustomerCtr crt = new CustomerCtr();
    return crt.insertCustomer(customer);
  }

  void insertCustomerbycustomer(Customer customer) async {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar: $value');
      final results = await this.insertCustomer(customer);
      this._suggestionStreamContoller.add(results);
    };

    // final timer = Timer.periodic(Duration(milliseconds: 100), (_) {
    // debouncer.value = customer;
    // });

    // Future.delayed(Duration(milliseconds: 101)).then((_) => timer.cancel());
  }

  // List<Customer> findRuc(String ruc , String company) async {

  //   CustomerCtr crt = new CustomerCtr();
  //   List<Customer> res =  await crt.getCustomerByRUC(ruc, company);

  //  return res;
  // }
}
