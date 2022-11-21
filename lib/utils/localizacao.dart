import 'package:geolocator/geolocator.dart';
import 'dart:math';


double valorLatitudeAtual = 0;
double valorLongitudeAtual = 0;

Future<double> getLatitudeAtual()async{
  await getPosicao();
  return valorLatitudeAtual;
}

Future<double> getLongitudeAtual()async {
  await getPosicao();
  return valorLongitudeAtual;
}

Future<void> getPosicao() async {
  try {
    LocationPermission permissao;

    bool ativado = await Geolocator.isLocationServiceEnabled();
    if (!ativado) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permissao == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }
    Position posicao = await Geolocator.getCurrentPosition();

    valorLatitudeAtual = posicao.latitude;
    valorLongitudeAtual = posicao.longitude;
  } catch (e) {
    e.toString();
  }
}

double calcularDistancia(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

Future<double> calcularDistanciaPosicaoAtual(lat2, lon2) async {
  await getPosicao();
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - valorLatitudeAtual) * p) / 2 +
      cos(valorLatitudeAtual * p) *
          cos(lat2 * p) *
          (1 - cos((lon2 - valorLongitudeAtual) * p)) /
          2;
  double dist = 12742 * asin(sqrt(a));
  return double.parse(dist.toStringAsFixed(2));
}
