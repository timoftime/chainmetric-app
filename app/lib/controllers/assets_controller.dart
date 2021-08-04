import 'package:chainmetric/models/asset_model.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

import 'blockchain_adapter.dart';

class AssetsController {
  static Future<AssetsResponse> getAssets({AssetQuery query, int limit, String scrollID}) async {
    query ??= AssetQuery(limit: limit, scrollID: scrollID);
    final data = await Blockchain.evaluateTransaction(
        "assets", "Query", JsonMapper.serialize(query));
    try {
      return data != null && data.isNotEmpty
          ? JsonMapper.deserialize<AssetsResponse>(data)
          : AssetsResponse();
    } on Exception catch (e) {
      print(e.toString());
    }
    return AssetsResponse();
  }

  static Future<bool> upsertAsset(Asset asset) async {
    final jsonData = JsonMapper.serialize(asset);
    return Blockchain.trySubmitTransaction("assets", "Upsert", jsonData);
  }

  static Future<bool> deleteAsset(String id) async {
    return Blockchain.trySubmitTransaction("assets", "Remove", id);
  }
}
