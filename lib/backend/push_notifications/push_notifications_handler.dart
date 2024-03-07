import 'dart:async';

import 'serialization_util.dart';
import '../backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


final _handledMessageIds = <String?>{};

class PushNotificationsHandler extends StatefulWidget {
  const PushNotificationsHandler({super.key, required this.child});

  final Widget child;

  @override
  _PushNotificationsHandlerState createState() =>
      _PushNotificationsHandlerState();
}

class _PushNotificationsHandlerState extends State<PushNotificationsHandler> {
  bool _loading = false;

  Future handleOpenedPushNotification() async {
    if (isWeb) {
      return;
    }

    final notification = await FirebaseMessaging.instance.getInitialMessage();
    if (notification != null) {
      await _handlePushNotification(notification);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handlePushNotification);
  }

  Future _handlePushNotification(RemoteMessage message) async {
    if (_handledMessageIds.contains(message.messageId)) {
      return;
    }
    _handledMessageIds.add(message.messageId);

    if (mounted) {
      setState(() => _loading = true);
    }
    try {
      final initialPageName = message.data['initialPageName'] as String;
      final initialParameterData = getInitialParameterData(message.data);
      final parametersBuilder = parametersBuilderMap[initialPageName];
      if (parametersBuilder != null) {
        final parameterData = await parametersBuilder(initialParameterData);
        context.pushNamed(
          initialPageName,
          pathParameters: parameterData.pathParameters,
          extra: parameterData.extra,
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    handleOpenedPushNotification();
  }

  @override
  Widget build(BuildContext context) => _loading
      ? isWeb
          ? Container()
          : Container(
              color: FlutterFlowTheme.of(context).primary,
              child: Center(
                child: Image.asset(
                  'assets/images/logo-jam-splash.png',
                  width: 90.0,
                  height: 90.0,
                  fit: BoxFit.contain,
                ),
              ),
            )
      : widget.child;
}

class ParameterData {
  const ParameterData(
      {this.requiredParams = const {}, this.allParams = const {}});
  final Map<String, String?> requiredParams;
  final Map<String, dynamic> allParams;

  Map<String, String> get pathParameters => Map.fromEntries(
        requiredParams.entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
  Map<String, dynamic> get extra => Map.fromEntries(
        allParams.entries.where((e) => e.value != null),
      );

  static Future<ParameterData> Function(Map<String, dynamic>) none() =>
      (data) async => const ParameterData();
}

final parametersBuilderMap =
    <String, Future<ParameterData> Function(Map<String, dynamic>)>{
  'homePage': ParameterData.none(),
  'start': ParameterData.none(),
  'signUp': ParameterData.none(),
  'signUp_1': ParameterData.none(),
  'signUp_2': ParameterData.none(),
  'passwordForget': ParameterData.none(),
  'association_1': (data) async => ParameterData(
        allParams: {
          'associationDetails': await getDocumentParameter<AssociationsRecord>(
              data, 'associationDetails', AssociationsRecord.fromSnapshot),
        },
      ),
  'donationGood_3': (data) async => ParameterData(
        allParams: {
          'associationDetails': await getDocumentParameter<AssociationsRecord>(
              data, 'associationDetails', AssociationsRecord.fromSnapshot),
        },
      ),
  'advantagePossibilities': ParameterData.none(),
  'myAccount': ParameterData.none(),
  'signIn': ParameterData.none(),
  'associationPayment_2': (data) async => ParameterData(
        allParams: {
          'associationPayment': await getDocumentParameter<AssociationsRecord>(
              data, 'associationPayment', AssociationsRecord.fromSnapshot),
        },
      ),
  'CGUU': ParameterData.none(),
  'myInformation': ParameterData.none(),
  'politiqueConf': ParameterData.none(),
  'InstantPaymentView': (data) async => ParameterData(
        allParams: {
          'amount': getParameter<String>(data, 'amount'),
          'idPartenaire': getParameter<String>(data, 'idPartenaire'),
        },
      ),
  'advantageBuild': ParameterData.none(),
  'MandatePaymentView': (data) async => ParameterData(
        allParams: {
          'amount': getParameter<double>(data, 'amount'),
          'idPartenaire': getParameter<String>(data, 'idPartenaire'),
        },
      ),
  'signUp_5': ParameterData.none(),
  'signUp_3': ParameterData.none(),
  'signUp_4': ParameterData.none(),
  'advantagePage': (data) async => ParameterData(
        allParams: {
          'advantageDetails': await getDocumentParameter<AdvantageRecord>(
              data, 'advantageDetails', AdvantageRecord.fromSnapshot),
        },
      ),
  'Test': ParameterData.none(),
};

Map<String, dynamic> getInitialParameterData(Map<String, dynamic> data) {
  try {
    final parameterDataStr = data['parameterData'];
    if (parameterDataStr == null ||
        parameterDataStr is! String ||
        parameterDataStr.isEmpty) {
      return {};
    }
    return jsonDecode(parameterDataStr) as Map<String, dynamic>;
  } catch (e) {
    print('Error parsing parameter data: $e');
    return {};
  }
}
