import 'package:flutter/material.dart';
import 'package:wo1/ApiHandler/api_handler.dart';
import 'package:wo1/Pages/UserHome/Fragments/Accounts/Page/accounts_details_edite.dart';

class AccountsFragment extends StatefulWidget {
  final bool isBusinessUser;

  const AccountsFragment({super.key, required this.isBusinessUser});

  @override
  State<AccountsFragment> createState() => _AccountsFragmentState();
}

class _AccountsFragmentState extends State<AccountsFragment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserDetailsPage(userDetails: ApiHandler.userDetails),
                ),
              );
            },
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Row
                    Row(
                      children: [
                        // Rounded Image
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(ApiHandler.userDetails
                              .photoUrl), // No background image if URL is not valid
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Basic Details
                        Text(
                          ApiHandler.userDetails.fullName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
