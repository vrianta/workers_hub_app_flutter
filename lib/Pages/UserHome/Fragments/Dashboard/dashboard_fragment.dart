import 'package:flutter/material.dart';
import 'package:wo1/Models/events.dart';
import 'package:wo1/Pages/UserHome/Fragments/Dashboard/Components/applied_event_handler.dart';
import 'package:wo1/Pages/UserHome/Fragments/Dashboard/Components/details_of_applied_event.dart';

class DashboardFragement extends StatefulWidget {
  const DashboardFragement({super.key});

  @override
  State<DashboardFragement> createState() => _DashboardFragementState();
}

class _DashboardFragementState extends State<DashboardFragement> {
  late AppliedEventHandler events;

  @override
  void initState() {
    super.initState();

    events = AppliedEventHandler(
      showEventDetails: showAppliedEventDetails,
    );

    events.getAppliedEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 247, 247, 247), // Updated background color
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            const Color.fromARGB(255, 247, 247, 247), // Fixed background color
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Applied Events",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            Text(
              "Manage your applied events",
              style: TextStyle(
                color: Theme.of(context).highlightColor,
                fontSize: 16,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 247, 247, 247),
                const Color.fromARGB(255, 247, 247, 247),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        color: Colors.blueAccent,
        child: FutureBuilder<List<Widget>>(
          future: events.getEventCards(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error loading event types"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No Event Type Found"),
              );
            }

            List<Widget>? eventCards = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: eventCards!.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 0);
                  },
                  itemBuilder: (context, index) {
                    return eventCards[index];
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _refreshPage() async {
    setState(() {
      events.clear();
    });

    //await Future.delayed(const Duration(seconds: 2));
    setState(() {
      events.loadData();
    });
  }

  void showAppliedEventDetails(Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 600,
          child: AppliedEventDetailsPage(
            event: event,
            onClose: () => {Navigator.pop(context), _refreshPage()},
          ),
        );
      },
    );
  }
}
