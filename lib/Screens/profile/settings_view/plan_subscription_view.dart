import '../../../Utility/packages.dart';

class SubscriptionHistoryScreen extends StatelessWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Subscription History",
          style: AppTextStyle.appBarTitleStyle
              .copyWith(color: AppColor.black, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSubscriptionCard(
              "Monthly", "\$299", "11-May-24", "#687687951", true),
          SizedBox(height: 16),
          _buildSubscriptionCard(
              "Monthly", "\$299", "11-May-24", "#687687951", false),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(String title, String price, String date,
      String transactionId, bool isOngoing) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOngoing ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    price,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              isOngoing
                  ? Text(
                      "Ongoing",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "Expired",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "$date | Transaction ID : $transactionId",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 8),
          if (isOngoing)
            TextButton(
              onPressed: () {},
              child: Text(
                "Cancel Subscription",
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
