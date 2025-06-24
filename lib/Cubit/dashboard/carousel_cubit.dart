import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselCubit extends Cubit<List<String>> {
  CarouselCubit()
      : super([
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
          'https://s3-alpha-sig.figma.com/img/ed13/60ee/b0c42500cdbeafedf8e8b652a56ad37f?Expires=1734912000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=po4W5TJ6wpjv0HCnZMt6shaMtiJ05sEKN4lgRDJQrpBawQxjJXUVP8ctI2g795th-UKskiOU~RuUtJj6O~Fa1bZe7ggIzNkhvpT5c6NgdG31Gj3Zvkpzv7MNzNmHU3wAuDhQMH4ubZQ7FUge9PfxYwO36mHp4EeTgVEgO~Adu~ft3HCPq7I5oVlkM9tqM9gVLFetAIs2qolv62YrKIX5xbFoZ32XqZpsd2Na0N4cr3-6cb7C8TlXfA~H6qBCLHeeBYpe9~-yEiiZY2X0mqVorPnUp8XoosnjHbYFAhKZYoQLjP3g2fo9B07UJcnWKb-NEAV4NJYbzQdMpVABC3vuzw__',
        ]);

  void updateImageList(List<String> newList) {
    emit(newList);
  }

  void updateIndex(int index) {
    emit(state);
  }
}
