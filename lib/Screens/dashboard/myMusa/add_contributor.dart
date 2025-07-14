import 'package:musa_app/Cubit/dashboard/Contributor/add_contributor_cubit.dart';
import 'package:musa_app/Cubit/dashboard/Contributor/add_contributor_state.dart';
import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';

class AddContributor extends StatefulWidget {
  final List<String> initialSelectedContributors; // Receive selected users
  final bool? isComeFromProfile;
  final String? musaId;
  final Function(int)? contributorAddCount;

  const AddContributor(
      {super.key,
      required this.initialSelectedContributors,
      this.isComeFromProfile,
      this.musaId,
      this.contributorAddCount});

  @override
  State<AddContributor> createState() => _AddContributorState();
}

class _AddContributorState extends State<AddContributor> {
  AddContributorCubit cubit = AddContributorCubit();

  late Map<String, String> _selectedContributors;
  bool isComeFromProfile = false;

  TextEditingController searchController = TextEditingController();
  ValueNotifier<String> searchQuery = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    // cubit.resetState();
    _selectedContributors = {};
    isComeFromProfile =
        widget.isComeFromProfile != null && widget.isComeFromProfile!;

    if (widget.isComeFromProfile != null && widget.isComeFromProfile!) {
      print(
          'iscomefromprofile---------------->${widget.musaId} ${widget.isComeFromProfile}');
      cubit.selectedContributors = {};
      cubit.getContributorUsersListWithStatus(widget.musaId);
    } else {
      cubit.getContributorUsersList();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // cubit.init();
      cubit.stream.listen((state) {
        for (var id in widget.initialSelectedContributors) {
          var user = cubit.contributorList.firstWhere((u) => u.id == id);
          cubit.selectedContributors[id] = "${user.firstName} ${user.lastName}";
        }
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AddContributorCubit, AddContributorState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is AddContributorError) {
            MusaPopup.popUpDialouge(
                context: context,
                onPressed: () => context.pop(true),
                buttonText: 'Okay',
                title: 'Error',
                description: state.errorMessage);
          }
          if (state is AddedContributorsInMusa) {
            widget.contributorAddCount!(
                cubit.selectedContributors.length.toInt());
            // Return true to indicate contributors were successfully added
            Navigator.pop(context, true);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              buildAddContributorSection(),
              state is AddContributorLoading
                  ? MusaWidgets.loader(context: context, isForFullHeight: true)
                  : Container()
            ],
          );
        },
      ),
    );
  }

  buildAddContributorSection() {
    return Container(
      color: Color(0xFFF8FDFA),
      child: Column(
        children: [
          // AppBarMusa1(
          //   title: "Add Contributor",
          //   appBarBtn: () {
          //     if (widget.isComeFromProfile != null && widget.isComeFromProfile!) {
          //       cubit.addContributorsInMyMusa(widget.musaId);
          //     } else {
          //       Navigator.pop(context, cubit.selectedContributors);
          //     }
          //   },
          //   appBarBtnText: 'X',
          // ),
          Container(
            padding:
                const EdgeInsets.only(top: 60, bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Color(0xFFF8FDFA),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.1),
              //     spreadRadius: 1,
              //     blurRadius: 3,
              //     offset: Offset(0, 1),
              //   ),
              // ],
            ),
            child: Row(
              children: [
                Text(
                  "Add Contributors",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (widget.isComeFromProfile != null &&
                        widget.isComeFromProfile!) {
                      // Check if new contributors were selected
                      if (cubit.selectedContributors.isNotEmpty) {
                        // Call the contributorAddCount callback before popping
                        widget.contributorAddCount
                            ?.call(cubit.selectedContributors.length.toInt());
                        // Make the API call to add contributors
                        cubit.addContributorsInMyMusa(widget.musaId);
                        // Return true to indicate contributors were added
                        Navigator.pop(context, true);
                      } else {
                        // Return false to indicate no contributors were added
                        Navigator.pop(context, false);
                      }
                    } else {
                      Navigator.pop(context, cubit.selectedContributors);
                    }
                  },
                  child: Text(
                    '✕',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildContributorUserSearch(),
          SizedBox(height: 10),
          buildContributorUserList(),
        ],
      ),
    );
  }

  Widget buildContributorUserList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8FDFA),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: BlocBuilder<AddContributorCubit, AddContributorState>(
          bloc: cubit,
          builder: (context, state) {
            return ValueListenableBuilder<String>(
              valueListenable: searchQuery,
              builder: (context, query, _) {
                final filteredContributors =
                    cubit.contributorList.where((contributor) {
                  bool isAlreadyContributor = contributor.contributeStatus == 1;
                  String userName =
                      "${contributor.firstName ?? ''} ${contributor.lastName ?? ''}"
                          .trim();
                  return userName.isNotEmpty &&
                      !isAlreadyContributor &&
                      userName.toLowerCase().contains(query);
                }).toList();

                print(
                    "Filtered Contributors----------->: ${filteredContributors.length}");

                return filteredContributors.isEmpty
                    ? Center(child: Text("No contributors available"))
                    : ListView.separated(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                        itemCount: filteredContributors.length,
                        separatorBuilder: (_, index) => Divider(
                          color: Color(0xFFE9E9E9),
                          thickness: 0.4,
                        ),
                        itemBuilder: (_, index) {
                          var contributor = filteredContributors[index];
                          var user = contributor.id;
                          bool isSelected =
                              _selectedContributors.containsKey(user);

                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: FadeInImage(
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                    image:
                                        NetworkImage(contributor.photo ?? ""),
                                    placeholder:
                                        NetworkImage(Assets.emptyProfile),
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.network(Assets.emptyProfile,
                                          fit: BoxFit.cover);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 6,
                                child: Text(
                                  "${contributor.firstName} ${contributor.lastName}"
                                      .trim(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF222222),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedContributors.remove(user);
                                      cubit.selectedContributors.remove(user);
                                    } else {
                                      _selectedContributors[user.toString()] =
                                          "${contributor.firstName} ${contributor.lastName}";
                                      cubit.selectedContributors[
                                              user.toString()] =
                                          "${contributor.firstName} ${contributor.lastName}";
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: isSelected
                                        ? Color(0xFFFFF6F6)
                                        : Color(0xFFE6F6EE),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Text(
                                        isSelected ? "Remove" : "Select",
                                        style: TextStyle(
                                          color: !isSelected
                                              ? Color(0xFF00674E)
                                              : Color(0xFFFF4343),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildContributorUserSearch() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8FDFA),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextField(
          controller: searchController,
          cursorColor: Colors.grey, // Added cursor color
          onChanged: (value) {
            searchQuery.value =
                value.trim().toLowerCase(); // Update search query
          },
          decoration: InputDecoration(
            // prefixIcon: Icon(Icons.search, color: AppColor.grey),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/svgs/search.svg',
                fit: BoxFit.contain, // This helps maintain aspect ratio
                width: 20,
                height: 20,
              ),
            ),
            hintText: 'Search...',
            hintStyle: TextStyle(
              color: AppColor.grey,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: Color(0xFFF8FDFA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: Color(0xFFB4C7B9), width: 1.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide:
                  BorderSide(color: Color(0xFFB4C7B9)), // Changed to #B4C7B9
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide:
                  BorderSide(color: Color(0xFFB4C7B9)), // Changed to #B4C7B9
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          ),
        ),
      ),
    );
  }
}
