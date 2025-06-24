import 'package:musa_app/Utility/musa_widgets.dart';
import 'package:musa_app/Utility/packages.dart';
import 'package:musa_app/cubit/mymusa_contributor/mymusa_contributor_cubit.dart';
import 'package:musa_app/cubit/mymusa_contributor/mymusa_contributor_state.dart';
import 'package:musa_app/models/my_musa_contributor_model.dart';

class MyMusaContributors extends StatefulWidget {
  const MyMusaContributors({super.key});

  @override
  State<MyMusaContributors> createState() => _MyMusaContributorsState();
}

class _MyMusaContributorsState extends State<MyMusaContributors> {
  final MyMusaContributorsCubit _cubit = MyMusaContributorsCubit();

  @override
  void initState() {
    super.initState();
    _cubit.fetchMyMusaContributors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Contributors',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: kToolbarHeight + 36.sp, // Increased height from default
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        leadingWidth: 56.sp,
        // shadowColor: Colors.grey.shade100,
      ),
      body: BlocConsumer<MyMusaContributorsCubit, MyMusaContributorsState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state is ContributorRemovalSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColor.greenDark, // Using your app's color
              ),
            );
          } else if (state is ContributorRemovalError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MyMusaContributorsLoading ||
              state is ContributorRemovalLoading) {
            return MusaWidgets.loader(context: context, isForFullHeight: true);
          }
          if (state is MyMusaContributorsError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, color: Colors.black)),
            ));
          }
          if (state is MyMusaContributorsSuccess) {
            // print('state.sections-------->: ${state.sections.length}');
            if (state.sections.isEmpty) {
              return const Center(
                  child: Text("No contributor sections found."));
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  itemCount: state.sections.length,
                  itemBuilder: (context, index) {
                    final section = state.sections[index];
                    // Pass the index and total count to the helper method
                    return _buildPaintingSection(
                      section,
                      index,
                      state.sections.length,
                    );
                  },
                ),
              ),
            );
          }
          // Initial state
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Builds a widget for a single painting section.
  Widget _buildPaintingSection(MusaSection section, int index, int totalItems) {
    // print("section data ---------------->: $section");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
            child: Text(
              section.title ?? 'Untitled Section',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.greenDark, // Teal color
              ),
            ),
          ),
          if (section.contributors == null || section.contributors!.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text("No contributors for this section."),
            )
          else
            Column(
              children: section.contributors!.map((contributor) {
                return _buildContributorRow(
                    section, contributor.contributorDetails);
              }).toList(),
            ),

          // Safely check if this is NOT the last item before adding a divider.
          if (index < totalItems - 1)
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Divider(color: Colors.grey.shade200, height: 1),
            ),
        ],
      ),
    );
  }

  /// Builds a widget for a single contributor row.
  Widget _buildContributorRow(
      MusaSection section, ContributorDetails? details) {
    if (details == null) return const SizedBox.shrink();

    final String fullName =
        '${details.firstName ?? ''} ${details.lastName ?? ''}'.trim();
    // Use a placeholder if photo is null, empty, or not a valid URL
    final String imageUrl = details.photo ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: [
          // CircleAvatar(
          //   radius: 24,
          //   backgroundImage: NetworkImage(imageUrl),
          //   onBackgroundImageError: (exception, stackTrace) {
          //     // You can handle image loading errors here if needed
          //   },
          //   backgroundColor: Colors.grey.shade200,
          // ),
          MusaWidgets.userProfileAvatarEdit(
            imageUrl: imageUrl,
            radius: 24.sp,
            borderWidth: 2.sp,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              fullName.isEmpty ? 'Unnamed Contributor' : fullName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              // Call the new dialog function
              if (section.id != null && details?.id != null) {
                _showRemoveConfirmationDialog(
                  context: context,
                  musaId: section.id!,
                  contributeId: details!.id!,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Missing required IDs.')),
                );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFFFF6F6),
              foregroundColor: Color(0xFFFF4343),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: Color.fromRGBO(255, 0, 0, 0.09)),
              ),
            ),
            child: const Text('Remove',
                style: TextStyle(fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }

  void _showRemoveConfirmationDialog({
    required BuildContext context,
    required String musaId,
    required String contributeId,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Confirm Removal'),
          content:
              const Text('Are you sure you want to remove this contributor?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 78, 76, 76))),
              onPressed: () {
                // Just close the dialog
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Make the remove button stand out
              ),
              child: const Text('Yes, Remove'),
              onPressed: () {
                // Close the dialog first
                Navigator.of(dialogContext).pop();
                // Then, call the cubit to start the removal process
                _cubit.removeContributor(
                  musaId: musaId,
                  contributeId: contributeId,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
