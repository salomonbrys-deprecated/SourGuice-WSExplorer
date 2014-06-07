
library WSMethods;

import 'package:angular/angular.dart';
import 'dart:html';

@NgComponent(
  selector: 'ws-methods',
  templateUrl: 'WSMethods/WSMethods.html',
  cssUrl: 'WSMethods/WSMethods.css',
  publishAs: 'ctrl'
)
class WSMethods {

  @NgTwoWay('version')
  String version = "1.5";

  @NgOneWay('description')
  set description(Map d) { _description = d; search = ""; }
  Map get description => _description;
  Map _description = {};

  List<String> get endpointNames => _description.keys.toList();
  List<String> methodNamesIn(String endpoint) => description[endpoint]['methods'].keys.toList();

  int selection = -1;

  List<String> _methods = [];

  final ShadowRoot _element;

  WSMethodFilter _methodFilter;

  WSMethods(this._element, Parser parser) {
    _methodFilter = new WSMethodFilter(parser);
    search = "";
  }

  String _search = "";
  String get search => _search;
  set search (String v) {
    _search = v;
    _methods = [];
    _description.forEach((String endpoint, _) {
      _methods.addAll(_methodFilter.call(methodNamesIn(endpoint), _search, endpoint).map((method) => endpoint + '.' + method));
    });
    if (_search.isNotEmpty) selection = 0;
  }

  bool isSelected(String endpoint, String method) => _methods.indexOf(endpoint + '.' + method) == selection;

  checkScroll() {
    LIElement li = _element.querySelector('#method-' + _methods[selection].replaceAll('.', '-'));
    int liOffset = li.offset.top - _element.host.offset.top;
    if ( liOffset < _element.host.scrollTop // Above
      || liOffset + li.clientHeight > _element.host.scrollTop + _element.host.clientHeight // Below
    ) {
      _element.host.scrollTop = (liOffset + (li.clientHeight / 2) - (_element.host.clientHeight / 2)).toInt();
    }
  }

  keyDown(KeyboardEvent e) {
    switch (e.keyCode) {
      case KeyCode.DOWN:
        e.preventDefault();
        if (selection < _methods.length - 1) ++selection;
        checkScroll();
      break ;
      case KeyCode.UP:
        e.preventDefault();
        if (selection > 0) --selection;
        checkScroll();
      break ;
      case KeyCode.ENTER:
        final data = _element.querySelector('.selected').dataset;
        window.location.href = "#/m/" + data['endpoint'] + "." + data['method'];
      break ;
    }
  }

  focus() { if (_search.isNotEmpty) selection = 0; }

  endpointClick(String endpoint) {
    search = endpoint + '.';
    _element.querySelector('#filter').focus();
  }
}

@NgFilter(
    name: "filter_endpoint"
)
class WSEndpointFilter {
  WSMethodFilter _methodFilter;

  WSEndpointFilter(Parser p) {
    _methodFilter = new WSMethodFilter(p);
  }

  List<String> call(List<String> endpoints, String search, Map description) {
    return endpoints.where((endpoint) {
      final List<String> methods = description[endpoint]['methods'].keys.toList();
      return _methodFilter.call(methods, search, endpoint).isNotEmpty;
    }).toList();
  }
}

@NgFilter(
    name: "filter_method"
)
class WSMethodFilter {
  FilterFilter _filterFilter;

  WSMethodFilter(Parser p) {
    _filterFilter = new FilterFilter(p);
  }

  List<String> call(List<String> methods, String search, String endpoint) {
    return _filterFilter.call(methods.map((name) => endpoint + '.' + name), search).map((name) => name.substring(endpoint.length + 1)).toList();
  }
}
