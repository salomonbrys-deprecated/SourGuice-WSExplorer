
library WSCaller;

import 'package:angular/angular.dart';
import 'dart:html';
import 'dart:convert';

@NgComponent(
  selector: 'ws-caller',
  templateUrl: 'WSCaller/WSCaller.html',
  cssUrl: 'WSCaller/WSCaller.css',
  publishAs: 'ctrl'
)
class WSCaller {

  String get endpoint => _routeProvider.parameters['endpoint'];
  String get method =>   _routeProvider.parameters['method'];

  final RouteProvider _routeProvider;

  WSCaller(this._routeProvider);

  String get json => JSON.stringify()

//  @NgTwoWay('endpoint')
//  String endpoint;
//
//  @NgTwoWay('method')
//  String method;

}
