import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musa_app/Repository/ApiServices/api_client.dart';
import 'package:musa_app/Repository/AppResponse/social_musa_list_response.dart';
import 'package:musa_app/Resources/api_url.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:musa_app/Utility/shared_preferences.dart';
import 'carosel_cubit_state.dart';

class CarouselCubit extends Cubit<List<String>> {
  CarouselCubit()
      : super([
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
        ]);
  final ApiClient _apiClient = ApiClient();
  void updateImageList(List<String> newList) {
    emit(newList);
  }

  void updateIndex(int index) {
    emit(state);
  }

  void deleteMusa(MusaData musaData) {
    deleteMusaApi(musaId: musaData.id.toString(), userId: musaData.userId);
  }

  //Event for delete musa api
  Future<void> deleteMusaApi({required String musaId, userId}) async {
    // emit(DeletMusaLoading());
    await Connectivity().checkConnectivity().then((value) async {
      if (value != ConnectivityResult.none) {
        try {
          final token = Prefs.getString(PrefKeys.token);
          final response = await _apiClient.post(ApiUrl.deleteMusa,
              headers: {'Authorization': 'Bearer $token'},
              body: {'musa_id': musaId});
          if (response['status'] == 200) {
            print("DELETED SSSSSSSSSSS");
            // emit(DeleteMusaSuccess());
          } else {}
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
