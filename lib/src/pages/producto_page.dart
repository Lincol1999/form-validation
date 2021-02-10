import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  //Este formKey es para validar un formulario.
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final productoProvider = new ProductosProvider();
  ProductoModel producto = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    //Comprobamos si ese producto es nuevo o viene con argumentos
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
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
      onPressed: _submit,
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

  void _submit() {
    //devuelve true si es valido y false cuando no lo es.

    if (!formKey.currentState.validate()) return;

    //dispara el save de todos los TextFormField. osea mostrara en consola
    //lo ingresado por consola del titulo y valor.
    formKey.currentState.save();
    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);
    if (producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }
  }
}
