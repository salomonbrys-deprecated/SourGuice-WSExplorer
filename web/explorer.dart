
import 'dart:html';
import 'package:logging/logging.dart';
import 'package:angular/angular.dart';

import 'WSMethods/WSMethods.dart';
import 'WSCaller/WSCaller.dart';

@NgController(
  selector: '[ng-app]',
  publishAs: 'app'
)
class ExplorerController {
  String version = "1.5";

  Map<String, List<String>> description;

  int errorStatus = -1;

  ExplorerController(Http http) {
    http.get("http://localhost:8080/ws/schema").then(
      (json) {
        window.console.log(json.data);
        description = json.data;
      },
      onError: (HttpResponse r) {
        window.console.log(r);
        errorStatus = r.status;
      }
    );
  }
}

void explorerRouteInitializer(Router router, RouteViewFactory views) {
  window.console.log("INIT");
  views.configure({
      'coucou': ngRoute(
          path: '/m/:endpoint.:method',
          view: 'Views/method.html'
      ),
  });
}

class ExplorerModule extends Module {
  ExplorerModule() {
    type(ExplorerController);

    type(WSMethods);
    type(WSEndpointFilter);
    type(WSMethodFilter);

    type(WSCaller);

    value(RouteInitializerFn, explorerRouteInitializer);
    factory(NgRoutingUsePushState, (_) => new NgRoutingUsePushState.value(false));
  }
}

main() {
  Logger.root.level = Level.FINEST;
  Logger.root.onRecord.listen((LogRecord r) { print(r.message); });

  ngBootstrap(module: new ExplorerModule());
}