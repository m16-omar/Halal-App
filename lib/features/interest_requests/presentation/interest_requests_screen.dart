import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/components/custom_bottom_nav.dart';

class InterestRequestsScreen extends StatefulWidget {
  const InterestRequestsScreen({super.key});

  @override
  State<InterestRequestsScreen> createState() => _InterestRequestsScreenState();
}

class _InterestRequestsScreenState extends State<InterestRequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _receivedRequests = [
    {
      'name': 'Fatimah Ibrahim',
      'age': '23',
      'state': 'Kaduna',
      'match': '94%',
      'time': '2 hours ago',
      'img': 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Halima Abubakar',
      'age': '25',
      'state': 'Kano',
      'match': '89%',
      'time': '1 day ago',
      'img': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Zainab Idris',
      'age': '22',
      'state': 'Minna',
      'match': '91%',
      'time': '3 days ago',
      'img': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500&auto=format&fit=crop&q=80',
    },
  ];

  final List<Map<String, dynamic>> _sentRequests = [
    {
      'name': 'Aisha Usman',
      'age': '24',
      'state': 'Ilorin',
      'match': '92%',
      'status': 'Accepted',
      'time': '1 day ago',
      'img': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=80',
    },
    {
      'name': 'Maryam Aliyu',
      'age': '26',
      'state': 'Abuja',
      'match': '85%',
      'status': 'Pending',
      'time': '4 days ago',
      'img': 'https://images.unsplash.com/photo-1589156280159-27698a70f29e?w=500&auto=format&fit=crop&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.darkCharcoal, size: 20),
            padding: EdgeInsets.zero,
            onPressed: () => context.pop(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interest Requests',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCharcoal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'View and respond to connection requests',
              style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryGreen,
          unselectedLabelColor: AppTheme.secondaryGrey,
          indicatorColor: AppTheme.primaryGreen,
          labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Received Requests'),
            Tab(text: 'Sent Requests'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAF6),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReceivedTab(),
                  _buildSentTab(),
                ],
              ),
            ),
          ),
          const CustomBottomNav(currentIndex: 1),
        ],
      ),
    );
  }

  // RECEIVED REQUESTS TAB
  Widget _buildReceivedTab() {
    if (_receivedRequests.isEmpty) {
      return Center(
        child: Text(
          'No requests received yet',
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryGrey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _receivedRequests.length,
      itemBuilder: (context, index) {
        final req = _receivedRequests[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  req['img'],
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          req['name'],
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${req['match']} Match',
                            style: GoogleFonts.inter(fontSize: 8, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${req['age']} yrs • ${req['state']}',
                      style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Requested ${req['time']}',
                      style: GoogleFonts.inter(fontSize: 8, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _receivedRequests.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Request declined')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[300]!),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text(
                              'Decline',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondaryGrey),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _receivedRequests.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Request accepted! Click on Wali Chat to start supervised conversation.')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text(
                              'Accept',
                              style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // SENT REQUESTS TAB
  Widget _buildSentTab() {
    if (_sentRequests.isEmpty) {
      return Center(
        child: Text(
          'No sent requests found',
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.secondaryGrey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sentRequests.length,
      itemBuilder: (context, index) {
        final req = _sentRequests[index];
        bool isAccepted = req['status'] == 'Accepted';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  req['img'],
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          req['name'],
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isAccepted ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            req['status'],
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              color: isAccepted ? AppTheme.primaryGreen : const Color(0xFFEF6C00),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${req['age']} yrs • ${req['state']}',
                      style: GoogleFonts.inter(fontSize: 10, color: AppTheme.secondaryGrey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sent ${req['time']}',
                      style: GoogleFonts.inter(fontSize: 8, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
