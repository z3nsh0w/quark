import 'package:yandex_music/src/objects/cover.dart';

class SearchConcert {
  final String id;
  final String city;
  final String place;
  final String address;
  final String dateTime;
  final String imageUrl;
  final int minPrice;
  final String afishaUrl;
  final List images;
  final String concertTitle;
  final String? contentRaiting;
  final String? priceCurrency;
  final String? priceCurrencySymbol;

  SearchConcert(Map<String, dynamic> concert)
    : id = concert['id'],
      imageUrl = concert['imageUrl'],
      concertTitle = concert['concertTitle'],
      city = concert['city'],
      place = concert['place'],
      address = concert['address'],
      dateTime = concert['datetime'],
      afishaUrl = concert['afishaUrl'],
      contentRaiting = concert['contentRaiting'],
      images = concert['images'],
      minPrice = concert['minPrice']['value'],
      priceCurrencySymbol = concert['minPrice']['currencySymbol'],
      priceCurrency = concert['minPrice']['currencty'];
}

class Concert {
  final String id;
  final String city;
  final String place;
  final String? address;
  final String dateTime;
  final String? imageUrl;
  final int minPrice;
  final String? afishaUrl;
  final List? images;
  final String? cashback;
  final String concertTitle;
  final String? contentRaiting;
  final String? priceCurrency;
  final String? priceCurrencySymbol;
  final Cover2? cover;

  Concert(Map<String, dynamic> concert)
    : id = concert['concert']['id'],
      imageUrl = concert['concert']['imageUrl'],
      concertTitle = concert['concert']['concertTitle'],
      cashback = concert['concert']['cashback']['title'],
      city = concert['concert']['city'],
      cover = Cover2(concert['concert']['cover']),
      place = concert['concert']['place'],
      address = concert['concert']['address'],
      dateTime = concert['concert']['datetime'],
      afishaUrl = concert['concert']['afishaUrl'],
      contentRaiting = concert['concert']['contentRaiting'],
      images = concert['concert']['images'],
      minPrice = concert['minPrice']['value'],
      priceCurrencySymbol = concert['minPrice']['currencySymbol'],
      priceCurrency = concert['minPrice']['currencty'];
}
