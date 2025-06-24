import 'package:musa_app/Screens/profile/settings_view/plan_subscription_view.dart';
import '../../../Utility/packages.dart';

class ChoosePlanScreen extends StatefulWidget {
  const ChoosePlanScreen({super.key});

  @override
  State<ChoosePlanScreen> createState() => _ChoosePlanScreenState();
}

class _ChoosePlanScreenState extends State<ChoosePlanScreen> {
  // State to keep track of the selected plan. 'Basic' is selected by default.
  String _selectedPlan = 'Basic';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light gray background
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: TextButton(
              onPressed: () {
                // Navigate to Plan History Screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SubscriptionHistoryScreen()));
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFE6F6EE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  // side: BorderSide(
                  //   color: const Color(0xFF00674E).withOpacity(0.5),
                  //   width: 1,
                  // ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                "Plan History",
                style: TextStyle(
                  color: Color(0xFF00674E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFreemiumCard(),
              const SizedBox(height: 24),
              _buildUpgradeSectionHeader(),
              const SizedBox(height: 16),
              _buildSelectablePlanCard(
                price: '\$5',
                planName: 'Basic Plan',
                storage: '5 GB in High Resolution Media Storage',
                videoInfo: 'Upload up to 2 mins video in HD (720p)',
                isSelected: _selectedPlan == 'Basic',
                onTap: () {
                  setState(() {
                    _selectedPlan = 'Basic';
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildSelectablePlanCard(
                price: '\$10',
                planName: 'Premium Plan',
                storage: '50 GB in High Resolution Media Storage',
                videoInfo: 'Upload up to 10 mins video in HD (1080p)',
                isSelected: _selectedPlan == 'Premium',
                onTap: () {
                  setState(() {
                    _selectedPlan = 'Premium';
                  });
                },
              ),
              const SizedBox(
                  height: 40), // Provide ample space before the button
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 24.0),
          child: ElevatedButton(
            onPressed: () {
              // Handle continue action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00674E), // Dark Teal
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for the top "Freemium" card
  Widget _buildFreemiumCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F6EE), // Light mint green
        border: Border.all(color: const Color(0xFF9FE2DC).withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Freemium',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFE6F6EE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Assets.planIcon,
                      fit: BoxFit.fill,
                      width: 18,
                    ),
                    const SizedBox(
                        width: 6), // Add some spacing between icon and text
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Color(0xFF00674E),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildFeatureRow('1 GB in High Resolution Media Storage'),
          const SizedBox(height: 8),
          _buildFeatureRow('Unlimited Low Resolution Media Storage'),
          const SizedBox(height: 8),
          _buildFeatureRow('Video Upload: Not available'),
        ],
      ),
    );
  }

  // Header for the "Upgrade to Premium" section
  Widget _buildUpgradeSectionHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upgrade to Premium',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00674E)),
        ),
        const SizedBox(height: 4),
        Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // Reusable widget for the selectable plan cards (Basic & Premium)
  Widget _buildSelectablePlanCard({
    required String price,
    required String planName,
    required String storage,
    required String videoInfo,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color borderColor =
        isSelected ? const Color(0xFF008080) : Colors.grey[300]!;
    final double borderWidth = isSelected ? 1.5 : 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$price per month',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    planName,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    'Bill Monthly',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureRow(storage),
                  const SizedBox(height: 8),
                  _buildFeatureRow('Unlimited Low Resolution Media Storage'),
                  const SizedBox(height: 8),
                  _buildFeatureRow(videoInfo),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildCustomRadioButton(isSelected),
          ],
        ),
      ),
    );
  }

  // A helper to build feature list items consistently
  Widget _buildFeatureRow(String text) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          child: Center(
            child: SvgPicture.asset(
              'assets/svgs/tick_icon.svg',
              fit: BoxFit.fill,
              width: 20,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
      ],
    );
  }

  // Custom widget to replicate the radio button in the image
  Widget _buildCustomRadioButton(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFF00674E) : Colors.transparent,
        border: Border.all(
          color: isSelected ? const Color(0xFF00674E) : Color(0xFF00674E),
          width: 1,
        ),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }
}
