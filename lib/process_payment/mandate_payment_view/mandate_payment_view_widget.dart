import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';
import 'mandate_payment_view_model.dart';
export 'mandate_payment_view_model.dart';

class MandatePaymentViewWidget extends StatefulWidget {
  const MandatePaymentViewWidget({
    super.key,
    required this.amount,
    required this.idPartenaire,
  });

  final double? amount;
  final String? idPartenaire;

  @override
  State<MandatePaymentViewWidget> createState() =>
      _MandatePaymentViewWidgetState();
}

class _MandatePaymentViewWidgetState extends State<MandatePaymentViewWidget> {
  late MandatePaymentViewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MandatePaymentViewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.keyboard_arrow_left_sharp,
              color: FlutterFlowTheme.of(context).primary,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed('homePage');
            },
          ),
          title: Text(
            'Page Title',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Lato',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: FlutterFlowWebView(
                  content:
                      'https://partenaire.jam-solidaire.com/mandateBilling?idPartenaire=${widget.idPartenaire}&amount=${widget.amount.toString()}&idUser=${currentUserReference?.id}',
                  bypass: false,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  verticalScroll: false,
                  horizontalScroll: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
