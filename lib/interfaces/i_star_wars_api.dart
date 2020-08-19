import 'dart:async';

import 'package:light_speed_app/models/character.dart';
import 'package:light_speed_app/models/film.dart';
import 'package:light_speed_app/models/planet.dart';


abstract class IStarWarsApi {
  Future<List<Film>> getFilms();
  Future<List<Character>> getCharacters();
  Future<List<Planet>> getPlanets();
}