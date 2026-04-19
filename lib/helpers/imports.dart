// Dart
export 'dart:io';
export 'dart:convert';
export 'dart:async';
export 'dart:typed_data';
export 'dart:math';

// Flutter
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';

// Packages
export 'package:go_router/go_router.dart';
export 'package:equatable/equatable.dart';
export 'package:logger/logger.dart';
export 'package:bloc/bloc.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:dio/dio.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';
export 'package:dropdown_button2/dropdown_button2.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:image_picker/image_picker.dart';
export 'package:calendar_timeline/calendar_timeline.dart';
export 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
export 'package:package_info_plus/package_info_plus.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:fl_chart/fl_chart.dart';
export 'package:url_launcher/url_launcher.dart';

// Routes
export '../routes/app_router.dart';
export '../routes/routes.dart';

// Constants
export '../constants/device_sizes.dart';
export '../constants/images.dart';

// UI - Pages
export '../screens/responsive_layout.dart';
export '../screens/pages/login_page.dart';
export '../screens/pages/splash_page.dart';
export '../screens/pages/home_page.dart';
export '../screens/pages/dashboard_page.dart';
export '../screens/pages/settings_page.dart';
export '../screens/pages/calendar_page.dart';
export '../screens/pages/metrics_page.dart';
export '../screens/pages/signup_page.dart';
export '../screens/pages/profile_page.dart';
export '../screens/pages/health_page.dart';
export '../screens/shared/auth/auth_shell.dart';

// Mobile
export '../screens/mobile/login/login.dart';
export '../screens/mobile/splash/splash.dart';
export '../screens/mobile/dashboard/dashboard.dart';
export '../screens/mobile/calendar/calendar.dart';
export '../screens/mobile/settings/settings.dart';
export '../screens/mobile/metrics/metrics.dart';
export '../screens/mobile/home/home.dart';
export '../screens/mobile/calendar/widgets/calendar_appbar.dart';
export '../screens/mobile/signup/signup.dart';
export '../screens/mobile/settings/profile/profile.dart';
export '../screens/mobile/settings/profile/admin/profile_customer_search.dart';
export '../screens/mobile/settings/health/health.dart';
export '../screens/mobile/settings/health/admin/health_customer_search.dart';
export '../screens/mobile/metrics/admin/admin.dart';
export '../screens/mobile/metrics/admin/get_customer.dart';
export '../screens/mobile/metrics/admin/start_session.dart';
export '../screens/mobile/metrics/admin/widgets/team_batch_session_page.dart';

// Desktop
export '../screens/desktop/login/login.dart';
export '../screens/desktop/splash/splash.dart';
export '../screens/desktop/dashboard/dashboard.dart';
export '../screens/desktop/calendar/calendar.dart';
export '../screens/desktop/settings/settings.dart';
export '../screens/desktop/metrics/metrics.dart';
export '../screens/desktop/home/home.dart';
export '../screens/desktop/signup/signup.dart';
export '../screens/desktop/settings/profile/profile.dart';
export '../screens/desktop/settings/health/health.dart';

// Utils
export '../utils/dio_interceptor.dart';
export '../utils/token_storage.dart';
export '../utils/buttons/iot_button.dart';
export '../utils/buttons/outline_button.dart';
export '../utils/dropdown/dropdown.dart';
export '../utils/textfields/textfield.dart';
export '../utils/progress_indicator/progress_indicator.dart';

// Styles
export '../styles/app_theme.dart';

// Service
export '../service/auth.dart';
export '../service/user.dart';
export '../service/ergometrics.dart';
export '../service/medical.dart';
export '../service/session.dart';

// Reporitory
export '../repository/auth.dart';
export '../repository/user.dart';
export '../repository/ergometrics.dart';
export '../repository/medical.dart';
export '../repository/session.dart';

// Models
export '../models/api_error.dart';
export '../models/api_response.dart';
export '../models/exceptions.dart';
export '../models/login_response.dart';
export '../models/users.dart';
export '../models/ergometrics/agility.dart';
export '../models/ergometrics/dynamometrics.dart';
export '../models/ergometrics/endurance.dart';
export '../models/ergometrics/ergometrics_details.dart';
export '../models/ergometrics/goniometrics.dart';
export '../models/ergometrics/jumping.dart';
export '../models/ergometrics/session.dart';
export '../models/ergometrics/somatometrics.dart';
export '../models/ergometrics/squat.dart';
export '../models/ergometrics/assignment.dart';
export '../models/ergometrics/wrapper_model.dart';
export '../models/medical_history.dart';
export '../models/ergometrics/beep_test_table.dart';
export '../models/teams.dart';
export '../models/team_members.dart';

// Helpers
export './auth_extensions.dart';

// Widgets Mobile
export '../screens/mobile/settings/profile/widgets/profile_header.dart';
export '../screens/mobile/settings/profile/widgets/section_card.dart';
export '../screens/mobile/settings/profile/widgets/profile_field.dart';
export '../screens/mobile/settings/profile/widgets/info_row.dart';
export '../screens/mobile/metrics/admin/widgets/entry_metrics.dart';
export '../screens/mobile/metrics/widgets.dart/ergometrics_charts_view.dart';
export '../screens/mobile/metrics/widgets.dart/chart_section.dart';
export '../screens/mobile/metrics/widgets.dart/chart_card.dart';
export '../screens/mobile/metrics/widgets.dart/chart_helpers.dart';
export '../screens/mobile/metrics/widgets.dart/somatometrics_charts.dart';
export '../screens/mobile/metrics/widgets.dart/dynamometrics_charts.dart';
export '../screens/mobile/metrics/widgets.dart/endurance_charts.dart';
export '../screens/mobile/metrics/widgets.dart/goniometrics_charts.dart';
export '../screens/mobile/metrics/widgets.dart/jumping_charts.dart';
export '../screens/mobile/metrics/widgets.dart/overhead_squat_charts.dart';
export '../screens/mobile/metrics/widgets.dart/agility_charts.dart';
