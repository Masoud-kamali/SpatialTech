import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../bloc/dashboard_bloc.dart';
import '../widgets/safety_metric_card.dart';
import '../widgets/alert_summary_card.dart';
import '../widgets/compliance_chart.dart';
import '../widgets/recent_alerts_list.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(LoadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏗️ SitEye Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardBloc>().add(RefreshDashboard());
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to alerts page
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(LoadDashboardData());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(RefreshDashboard());
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Safety Metrics Row
                    Row(
                      children: [
                        Expanded(
                          child: SafetyMetricCard(
                            title: 'Active Sites',
                            value: state.data.activeSites.toString(),
                            icon: MdiIcons.officeBuildingMarker,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SafetyMetricCard(
                            title: 'Workers',
                            value: state.data.activeWorkers.toString(),
                            icon: MdiIcons.hardHat,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Alert Summary Row
                    Row(
                      children: [
                        Expanded(
                          child: AlertSummaryCard(
                            title: 'Active Alerts',
                            count: state.data.activeAlerts,
                            color: Colors.red,
                            icon: MdiIcons.alertCircle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SafetyMetricCard(
                            title: 'Compliance',
                            value: '${state.data.complianceScore}%',
                            icon: MdiIcons.shieldCheck,
                            color: state.data.complianceScore > 90 
                                ? Colors.green 
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Compliance Chart
                    const Text(
                      'Safety Compliance Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ComplianceChart(data: state.data.complianceData),
                    
                    const SizedBox(height: 24),
                    
                    // Recent Alerts
                    const Text(
                      'Recent Alerts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RecentAlertsList(alerts: state.data.recentAlerts),
                  ],
                ),
              ),
            );
          }
          
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to live monitoring
        },
        child: const Icon(MdiIcons.cctv),
        tooltip: 'Live Monitoring',
      ),
    );
  }
}

// Placeholder classes for the bloc
abstract class DashboardEvent {}
class LoadDashboardData extends DashboardEvent {}
class RefreshDashboard extends DashboardEvent {}

abstract class DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
class DashboardLoaded extends DashboardState {
  final DashboardData data;
  DashboardLoaded(this.data);
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardLoading());
}

class DashboardData {
  final int activeSites;
  final int activeWorkers;
  final int activeAlerts;
  final double complianceScore;
  final List<ComplianceDataPoint> complianceData;
  final List<AlertItem> recentAlerts;
  
  DashboardData({
    required this.activeSites,
    required this.activeWorkers,
    required this.activeAlerts,
    required this.complianceScore,
    required this.complianceData,
    required this.recentAlerts,
  });
}

class ComplianceDataPoint {
  final String category;
  final double value;
  final Color color;
  
  ComplianceDataPoint({
    required this.category,
    required this.value,
    required this.color,
  });
}

class AlertItem {
  final String type;
  final String description;
  final String severity;
  final DateTime timestamp;
  
  AlertItem({
    required this.type,
    required this.description,
    required this.severity,
    required this.timestamp,
  });
}
