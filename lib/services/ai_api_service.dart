import 'dart:convert';
import 'package:http/http.dart' as http;

class AiApiService {
  // AI Monitoring System Base URL - separate from backend API
  final String _aiBaseUrl = "https://7a7fcae57dc8.ngrok-free.app";

  // Default headers including the grok-skip-browser-warning
  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'grok-skip-browser-warning': 'true',
  };

  // Headers with authorization token (if needed)
  Map<String, String> _getAuthHeaders(String? token) {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ============================================================================
  // AI SENSITIVITY SETTINGS
  // ============================================================================

  /// Get current AI sensitivity level
  /// GET /api/settings/ai-sensitivity
  Future<Map<String, dynamic>> getAiSensitivity({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/settings/ai-sensitivity'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Set AI sensitivity level
  /// POST /api/settings/ai-sensitivity-level with body {"level": "low|medium|high"}
  Future<Map<String, dynamic>> setAiSensitivityLevel(
    String level, {
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('$_aiBaseUrl/api/settings/ai-sensitivity-level'),
      headers: _getAuthHeaders(token),
      body: json.encode({'level': level}),
    );

    return _handleResponse(response);
  }

  /// Root Endpoint - Health check for AI Monitoring System
  Future<Map<String, dynamic>> getRootEndpoint({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Health Check Endpoint
  Future<Map<String, dynamic>> getHealthCheck({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/health'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Dashboard Endpoints - AI Monitoring System Analytics

  /// Average Behavior Score
  Future<Map<String, dynamic>> getAverageBehaviorScore({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/average-behavior-score'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Top Branch Performance
  Future<Map<String, dynamic>> getTopBranch({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/top-branch'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Productivity Metrics
  Future<Map<String, dynamic>> getProductivity({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/productivity'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Underperforming Zones
  Future<Map<String, dynamic>> getUnderperformingZones({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/underperforming-zones'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Attendance Pattern
  Future<Map<String, dynamic>> getAttendancePattern({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/attendance-pattern'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Performance Insight
  Future<Map<String, dynamic>> getPerformanceInsight({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/performance-insight'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Staff Performance
  Future<Map<String, dynamic>> getStaffPerformance({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/staff-performance'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Top 5 Employees
  Future<Map<String, dynamic>> getTop5Employees({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/top-5-employees'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Branch Performance
  Future<Map<String, dynamic>> getBranchPerformance({
    String? token,
    String? period,
  }) async {
    String url = '$_aiBaseUrl/api/dashboard/branch-performance';
    if (period != null) {
      url += '?period=$period';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Recent Behaviors
  Future<Map<String, dynamic>> getRecentBehaviors({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/recent-behaviors'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Reports Endpoints

  /// Incidents Report
  Future<Map<String, dynamic>> getIncidents({
    String? token,
    String? period,
  }) async {
    String url = '$_aiBaseUrl/api/reports/incidents';
    if (period != null) {
      url += '?period=$period';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Behaviors Report
  Future<Map<String, dynamic>> getBehaviors({
    String? token,
    String? period,
  }) async {
    String url = '$_aiBaseUrl/api/reports/behaviors';
    if (period != null) {
      url += '?period=$period';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Away Time Report
  Future<Map<String, dynamic>> getAwayTime({
    String? token,
    String? period,
  }) async {
    String url = '$_aiBaseUrl/api/reports/away-time';
    if (period != null) {
      url += '?period=$period';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Incidents with Filters
  Future<Map<String, dynamic>> getIncidentsWithFilters({
    String? token,
    String? startDate,
    String? endDate,
    String? employee,
    String? zone,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;
    if (employee != null) queryParams['employee'] = employee;
    if (zone != null) queryParams['zone'] = zone;

    final uri = Uri.parse(
      '$_aiBaseUrl/api/reports/incidents',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: _getAuthHeaders(token));
    return _handleResponse(response);
  }

  /// Attendance Report
  Future<Map<String, dynamic>> getAttendance({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/reports/attendance'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Attendance with Filters
  Future<Map<String, dynamic>> getAttendanceWithFilters({
    String? token,
    String? startDate,
    String? endDate,
    String? employee,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;
    if (employee != null) queryParams['employee'] = employee;

    final uri = Uri.parse(
      '$_aiBaseUrl/api/reports/attendance',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: _getAuthHeaders(token));
    return _handleResponse(response);
  }

  /// Violations Report
  Future<Map<String, dynamic>> getViolations({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/reports/violations'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Violations with Filters
  Future<Map<String, dynamic>> getViolationsWithFilters({
    String? token,
    String? startDate,
    String? endDate,
    String? violationType,
    String? employee,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;
    if (violationType != null) queryParams['violation_type'] = violationType;
    if (employee != null) queryParams['employee'] = employee;

    final uri = Uri.parse(
      '$_aiBaseUrl/api/reports/violations',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: _getAuthHeaders(token));
    return _handleResponse(response);
  }

  /// Productivity Report
  Future<Map<String, dynamic>> getProductivityReport({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/reports/productivity'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Employee Performance Report
  Future<Map<String, dynamic>> getEmployeePerformanceReport({
    String? token,
  }) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/reports/employee-performance'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Safety Score Report
  Future<Map<String, dynamic>> getSafetyScore({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/reports/safety-score'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Custom Report
  Future<Map<String, dynamic>> getCustomReport({
    String? token,
    String? reportType,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (reportType != null) queryParams['report_type'] = reportType;
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;

    final uri = Uri.parse(
      '$_aiBaseUrl/api/reports/custom',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: _getAuthHeaders(token));
    return _handleResponse(response);
  }

  /// Schedule Report
  Future<Map<String, dynamic>> getSchedule({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/reports/schedule'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Export Incidents Report as PDF
  /// GET /api/reports/incidents/export-pdf
  Future<Map<String, dynamic>> exportIncidentsReportPdf({
    String? token,
    bool includeChartsGraphs = false,
    bool includeImages = true,
  }) async {
    final queryParams = <String, String>{
      'include_charts_graphs': includeChartsGraphs.toString(),
      'include_images': includeImages.toString(),
    };

    final uri = Uri.parse(
      '$_aiBaseUrl/api/reports/incidents/export-pdf',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _getAuthHeaders(token));
    return _handleResponse(response);
  }

  /// Export Behaviors Report as PDF
  /// GET /api/reports/behaviors/export-pdf
  Future<Map<String, dynamic>> exportBehaviorsReportPdf({
    String? token,
    bool includeChartsGraphs = false,
    bool includeImages = true,
  }) async {
    final queryParams = <String, String>{
      'include_charts_graphs': includeChartsGraphs.toString(),
      'include_images': includeImages.toString(),
    };

    final uri = Uri.parse(
      '$_aiBaseUrl/api/reports/behaviors/export-pdf',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _getAuthHeaders(token));
    return _handleResponse(response);
  }

  /// Export Away Time Report as PDF
  /// GET /api/reports/away-time/export-pdf
  Future<Map<String, dynamic>> exportAwayTimeReportPdf({
    String? token,
    bool includeChartsGraphs = false,
    bool includeImages = true,
  }) async {
    final queryParams = <String, String>{
      'include_charts_graphs': includeChartsGraphs.toString(),
      'include_images': includeImages.toString(),
    };

    final uri = Uri.parse(
      '$_aiBaseUrl/api/reports/away-time/export-pdf',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _getAuthHeaders(token));
    return _handleResponse(response);
  }

  /// Generic Export Report method for backward compatibility
  Future<Map<String, dynamic>> getExportReport({
    String? token,
    String? reportId,
    String? format,
  }) async {
    final queryParams = <String, String>{};
    if (reportId != null) queryParams['report_id'] = reportId;
    if (format != null) queryParams['format'] = format;

    final uri = Uri.parse(
      '$_aiBaseUrl/api/reports/export/RPT_001',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(uri, headers: _getAuthHeaders(token));
    return _handleResponse(response);
  }

  // ============================================================================
  // EMPLOYEE MANAGEMENT ENDPOINTS
  // ============================================================================

  /// Get Employees List
  Future<Map<String, dynamic>> getEmployeesList({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/employees/list'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Employee Details
  Future<Map<String, dynamic>> getEmployeeDetails({
    String? token,
    required String employeeId,
  }) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/employees/$employeeId'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Employee Performance
  Future<Map<String, dynamic>> getEmployeePerformance({
    String? token,
    required String employeeId,
  }) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/employees/$employeeId/performance'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Employee Violations
  Future<Map<String, dynamic>> getEmployeeViolations({
    String? token,
    required String employeeId,
  }) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/employees/$employeeId/violations'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get All Employees Productivity
  Future<Map<String, dynamic>> getAllEmployeesProductivity({
    String? token,
  }) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/employees/productivity'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Event Time Segments
  Future<Map<String, dynamic>> getEventTimeSegments({
    String? token,
    String period = '24hr',
  }) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/analytics/event-time-segments?period=$period'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Employee Performance Chart
  Future<Map<String, dynamic>> getEmployeePerformanceChart({
    String? token,
    required String employeeName,
    String chartType = 'bar',
    String period = '30d',
  }) async {
    final response = await http.get(
      Uri.parse(
        '$_aiBaseUrl/api/employees/performance-chart?employee=$employeeName&chart_type=$chartType&period=$period',
      ),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Compare Staff Chart
  Future<Map<String, dynamic>> getCompareStaffChart({
    String? token,
    String metric = 'productivity',
    String chartType = 'bar',
    String period = '1d',
  }) async {
    final response = await http.get(
      Uri.parse(
        '$_aiBaseUrl/api/analytics/compare-chart?employees=Basit&employees=Talha&employees=Ali&metric=$metric&chart_type=$chartType&period=$period',
      ),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Analytics Endpoints

  /// Get Analytics Events
  Future<Map<String, dynamic>> getAnalyticsEvents({
    String? token,
    String period = '24hr',
  }) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/analytics/events?period=$period'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Analytics Event Time Segments
  Future<Map<String, dynamic>> getAnalyticsEventTimeSegments({
    String? token,
    String period = '24hr',
  }) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/analytics/event-time-segments?period=$period'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Employee Attendance
  Future<Map<String, dynamic>> getEmployeeAttendance({
    String? token,
    required String employeeId,
  }) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/employees/$employeeId/attendance'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Employee Frame Snapshots
  Future<Map<String, dynamic>> getEmployeeFrameSnapshots({
    String? token,
    required String employeeName,
  }) async {
    // URL encode the employee name to handle spaces and special characters
    // Don't clean the name - preserve original spacing as API expects it
    final encodedName = Uri.encodeComponent(employeeName);

    print('🔍 Original name: "$employeeName"');
    print('🔗 Encoded name: "$encodedName"');
    print(
      '🌐 Full URL: $_aiBaseUrl/api/employees/frame-snapshots/$encodedName',
    );

    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/employees/frame-snapshots/$encodedName'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Employee Break Time
  Future<Map<String, dynamic>> getEmployeeBreakTime({
    String? token,
    required String employeeName,
  }) async {
    // URL encode the employee name to handle spaces and special characters
    final encodedName = Uri.encodeComponent(employeeName);

    print('🔍 Fetching break time for: "$employeeName"');
    print('🔗 Encoded name: "$encodedName"');
    print(
      '🌐 Full URL: $_aiBaseUrl/api/employees/break-time?employee_name=$encodedName',
    );

    final response = await http.get(
      Uri.parse(
        '$_aiBaseUrl/api/employees/break-time?employee_name=$encodedName',
      ),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Employee Work Hours
  Future<Map<String, dynamic>> getEmployeeWorkHours({
    String? token,
    required String employeeName,
  }) async {
    // URL encode the employee name to handle spaces and special characters
    final encodedName = Uri.encodeComponent(employeeName);

    print('🔍 Fetching work hours for: "$employeeName"');
    print('🔗 Encoded name: "$encodedName"');
    print(
      '🌐 Full URL: $_aiBaseUrl/api/employees/work-hours?employee_name=$encodedName',
    );

    final response = await http.get(
      Uri.parse(
        '$_aiBaseUrl/api/employees/work-hours?employee_name=$encodedName',
      ),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Employee Zone Absence
  Future<Map<String, dynamic>> getEmployeeZoneAbsence({
    String? token,
    required String employeeName,
  }) async {
    // URL encode the employee name to handle spaces and special characters
    final encodedName = Uri.encodeComponent(employeeName);

    print('🔍 Fetching zone absence for: "$employeeName"');
    print('🔗 Encoded name: "$encodedName"');
    print(
      '🌐 Full URL: $_aiBaseUrl/api/employees/zone-absence?employee_name=$encodedName',
    );

    final response = await http.get(
      Uri.parse(
        '$_aiBaseUrl/api/employees/zone-absence?employee_name=$encodedName',
      ),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Get Analytics Zone Map
  Future<Map<String, dynamic>> getAnalyticsZoneMap({String? token}) async {
    print('🔍 Fetching analytics zone map data');
    print('🌐 Full URL: $_aiBaseUrl/api/analytics/zone-map');

    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/analytics/zone-map'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Handle HTTP response and parse JSON
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        return {
          'success': true,
          'data': response.body,
          'statusCode': response.statusCode,
        };
      }
    } else {
      try {
        final errorBody = json.decode(response.body);
        final errorMessage =
            errorBody['error']?['message'] ??
            errorBody['message'] ??
            'AI Monitoring API request failed';
        throw Exception('AI Monitoring API Error: $errorMessage');
      } catch (e) {
        if (e.toString().contains('AI Monitoring API Error:')) {
          rethrow;
        }
        final errorMessage =
            'HTTP ${response.statusCode}: ${response.reasonPhrase}';
        throw Exception('AI Monitoring API Error: $errorMessage');
      }
    }
  }

  // ============================================================================
  // DASHBOARD PDF EXPORT
  // ============================================================================

  /// Export dashboard data as PDF
  /// GET /api/dashboard/export-pdf
  Future<Map<String, dynamic>> exportDashboardPdf({String? token}) async {
    final response = await http.get(
      Uri.parse('$_aiBaseUrl/api/dashboard/export-pdf'),
      headers: _getAuthHeaders(token),
    );

    return _handleResponse(response);
  }

  /// Export Analytics Report as PDF
  /// POST /api/reports/analytics/export
  Future<Map<String, dynamic>> exportAnalyticsReportPdf({
    String? token,
    bool includeAiInsights = false,
    bool includeSnapshots = true,
  }) async {
    final requestBody = {
      'include_ai_insights': includeAiInsights,
      'include_snapshots': includeSnapshots,
    };

    final response = await http.post(
      Uri.parse('$_aiBaseUrl/api/reports/analytics/export'),
      headers: _getAuthHeaders(token),
      body: json.encode(requestBody),
    );

    return _handleResponse(response);
  }

  /// Export Employee Report as PDF
  /// GET /api/reports/incidents/export-pdf with employee filter
  Future<Map<String, dynamic>> exportEmployeeReportPdf({
    String? token,
    required String employeeName,
    bool includeAiInsights = false,
    bool includeSnapshots = true,
  }) async {
    final queryParams = <String, String>{'employee': employeeName};

    if (includeAiInsights) {
      queryParams['include_charts_graphs'] = 'true';
    }
    if (includeSnapshots) {
      queryParams['include_images'] = 'true';
    }

    final uri = Uri.parse(
      '$_aiBaseUrl/api/reports/incidents/export-pdf',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _getAuthHeaders(token));
    return _handleResponse(response);
  }

  /// Download PDF file from the provided download URL
  /// This method handles the actual file download
  Future<List<int>> downloadPdfFile(String downloadUrl, {String? token}) async {
    // Construct full URL if it's a relative path
    final String fullUrl = downloadUrl.startsWith('http')
        ? downloadUrl
        : '$_aiBaseUrl$downloadUrl';

    final response = await http.get(
      Uri.parse(fullUrl),
      headers: _getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download PDF: ${response.statusCode}');
    }
  }
}
