import 'dart:convert';

import 'package:chainmetric/models/assets/asset.dart';
import 'package:chainmetric/platform/adapters/hyperledger.dart';

class AssetsController {
  static Future<AssetsResponse?> getAssets(
      {AssetsQuery? query, int? limit, String? scrollID}) async {
    query ??= AssetsQuery(limit: limit, scrollID: scrollID);
    final data = await Hyperledger.evaluateTransaction(
        "assets", "Query", json.encode(query.toJson()));
    try {
      return data != null && data.isNotEmpty
          ? AssetsResponse.fromJson(json.decode(data))
          : AssetsResponse();
    } on Exception catch (e) {
      print(e.toString());
    }
    return AssetsResponse();
  }

  static Future<bool> upsertAsset(Asset asset) async {
    final jsonData = json.encode(asset.toJson());
    return Hyperledger.trySubmitTransaction("assets", "Upsert", jsonData);
  }

  static Future<bool> deleteAsset(String? id) async {
    return Hyperledger.trySubmitTransaction("assets", "Remove", id);
  }
}