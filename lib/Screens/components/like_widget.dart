import '../../Cubit/like_cubit.dart';
import '../../Utility/packages.dart';

class LikeWidget extends StatelessWidget {
  final String musaId;
  final bool isLiked;
  final int likeCount;

  const LikeWidget({super.key, required this.musaId, required this.isLiked, required this.likeCount});

  @override
  Widget build(BuildContext context) {
    final Repository repository = Repository();
    return BlocBuilder<LikeCubit, LikeState?>(
      builder: (context, state) {
        bool currentLikeStatus = state?.musaId == musaId ? state!.isLiked : isLiked;
        int currentLikeCount = state?.musaId == musaId ? state!.likeCount : likeCount;

        return Row(
          children: [
            InkWell(
              onTap: () {
                context.read<LikeCubit>().toggleLike(
                  musaId: musaId,
                  currentLikeStatus: currentLikeStatus,
                  likeCount: currentLikeCount,
                );
                repository.likeMusa(musaId: musaId); // Call API
              },
              child: Icon(
                Icons.favorite,
                color: currentLikeStatus ? Colors.red : Colors.grey,
                size: 20,
              ),
            ),
            SizedBox(width: 5),
            Text(
              currentLikeCount.toString(),
              style: TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
