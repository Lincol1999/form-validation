// creamos una funcion bool que recibe el valor s
bool isNumeric(String s) {
  //si esta vacio retorna
  if (s.isEmpty) return false;

  //inicializamos s dado que este parsee el vstring  a Int
  final n = num.tryParse(s);

  //retorna si n = null no lo parseo. de lo contrario si.
  return (n == null) ? false : true;
}
