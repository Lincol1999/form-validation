import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  //Este formKey es para validar un formulario.
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();
  ProductoModel producto = new ProductoModel();

  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    //Comprobamos si ese producto es nuevo o viene con argumentos
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Productos'),
      //onSaved es para establecer lo escrito a  initialValue.
      onSaved: (value) {
        producto.titulo = value;
      },
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      //Para que dea el punto de 2 maneras
      keyboardType: TextInputType.number,
      // keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) {
        producto.valor = double.parse(value);
      },
      validator: (value) {
        //recibe el value como el valor de la validacion, donde por el isNumeric lo parsea
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  void _submit() async {
    //devuelve true si es valido y false cuando no lo es.
    if (!formKey.currentState.validate()) return;

    //dispara el save de todos los TextFormField. osea mostrara en consola
    //lo ingresado por consola del titulo y valor.
    formKey.currentState.save();

    setState(() {
      //aqui sabemos que guardamos la informacion
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(foto);
    }

    if (producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
      Navigator.pushNamed(context, 'home');
    }
    setState(() {
      //aqui sabemos que guardamos la informacion
      _guardando = false;
    });
    //LLamamos al mostrarSnackbar para mostrar el mensaje en la parte
    //inferior del dispositivo
    mostrarSnackbar('Registro Guardado');

    //De otra manera
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text('Registro Guardado'),
    //   duration: Duration(milliseconds: 1500),
    // ));
  }

  mostrarSnackbar(String mensaje) {
    final snackbar = ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    ));

    return snackbar;
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      //Si tiene una foto
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        //foto ?.path ?? 'assets/no-image.png' => si la foto tiene info y este tiene el
        //path se mostrara, pero si es null muestra el assets
        image:
            foto != null ? FileImage(foto) : AssetImage('assets/no-image.png'),

        height: 300,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origin) async {
    //Hasta que el usuario responda o almacene una img, lo almacenare en foto
    final pickedFile = await ImagePicker().getImage(source: origin);
    // pickedFile es de tipo string y lo convertimos a tipo File
    foto = File(pickedFile.path);

    // if (foto != null) {
    //   //Limpieza
    // }
    // setState(() {});
    setState(() {
      if (foto != null) {
        //Actualizar la foto al editar.
        producto.fotoUrl = null;
      } else {
        mostrarSnackbar('Imagen no seleccionada');
      }
    });
  }
}
