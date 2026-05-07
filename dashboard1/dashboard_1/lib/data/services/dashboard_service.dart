import '../models/dashboard_model.dart';

class DashboardService {
  DashboardModel getData() {
    return DashboardModel(
      wellbeing: 0.67,
      stress: 0.75,
    );
  }
}