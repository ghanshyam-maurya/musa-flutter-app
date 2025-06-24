import 'package:musa_app/Cubit/dashboard/CreateMusa/create_musa_cubit.dart';
import 'package:musa_app/Utility/packages.dart';

class MusaLoader {
  static apiLoader() {
    return Center(
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border:
                    Border.all(width: 1.5, color: AppColor.primaryTextColor),
                color: AppColor.txtColor),
            width: 150,
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
                backgroundColor: Colors.black,
              ),
            )));
  }

  static showCreateAlbumDialog(BuildContext context, CreateMusaCubit cubit,
      {bool isSubAlbum = false}) {
    TextEditingController albumController = TextEditingController();
    String? selectedParentAlbumId =
        isSubAlbum ? cubit.selectedAlbum?.id.toString() : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white, // Add this line
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: 30.h,
                      bottom: 30.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isSubAlbum ? "Create Sub-Album" : "Create Album",
                              style: AppTextStyle.mediumTextStyle(
                                color: AppColor.black,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        /// Album Name TextField
                        TextField(
                          cursorColor: AppColor.greenDark, // Add this line
                          controller:
                              albumController, // FIXED: Added controller
                          decoration: InputDecoration(
                            hintText:
                                "Enter ${isSubAlbum ? 'Sub-Album' : 'Album'} Name",
                            hintStyle: AppTextStyle.normalTextStyle(
                              color: AppColor.greyNew,
                              size: 14,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColor.greenDark),
                            ),
                            focusColor: AppColor.greenDark,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 15.h,
                            ),
                          ),
                        ),

                        /// Sub-Album Dropdown
                        if (isSubAlbum) ...[
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: selectedParentAlbumId,
                            decoration: InputDecoration(
                              labelText: "Belongs to Album",
                              labelStyle: TextStyle(color: AppColor.greenDark),
                              floatingLabelStyle:
                                  TextStyle(color: AppColor.greenDark),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: AppColor.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: AppColor.greenDark),
                              ),
                              focusColor: AppColor.greenDark,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 15.h,
                              ),
                            ),
                            items: cubit.musaAlbumList
                                .map<DropdownMenuItem<String>>((album) {
                              return DropdownMenuItem<String>(
                                value: album.id.toString(),
                                child: Text(album.title ?? "Untitled"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedParentAlbumId = value;
                              });
                            },
                          ),
                        ],
                        SizedBox(height: 20.h),

                        /// Create Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              String albumName = albumController.text.trim();

                              if (albumName.isEmpty) {
                                print("Album name cannot be empty");
                                return;
                              }

                              if (isSubAlbum && selectedParentAlbumId == null) {
                                print("Please select a parent album");
                                return;
                              }

                              if (isSubAlbum) {
                                cubit.createSubAlbum(
                                    context, albumName, selectedParentAlbumId!);
                              } else {
                                cubit.createAlbum(context, albumName);
                              }

                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.greenDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                            ),
                            child: Text(
                              'Create',
                              style: AppTextStyle.mediumTextStyle(
                                color: Colors.white,
                                size: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Close Button
                  Positioned(
                    top: 5,
                    right: 15,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon:
                          Icon(Icons.close, color: AppColor.black, size: 25.sp),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
