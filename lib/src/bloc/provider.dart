import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart';

import 'package:formvalidation/src/bloc/productos_bloc.dart';
export 'package:formvalidation/src/bloc/productos_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = new LoginBloc();
  final _productosBloc = new ProductosBloc();
  //Para poder mantener la info del usuario y pass
  static Provider _instancia;

  //factory, si necesitamos regresar una nueva instancia o la existente
  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      //si es null creamos una nueva instancia
      _instancia = new Provider._internal(key: key, child: child);
    }
    //Si ya hay info solo lo retorna
    return _instancia;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  // static LoginBloc of(BuildContext context) {
  //   return (context.inheritFromWidgetOfExactType(Provider) as Provider)
  //       .loginBloc;
  // }
  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>()).loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())
        ._productosBloc;
  }
}
