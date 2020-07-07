import 'package:flutterapptest/scroll_behavior.dart';
import 'package:flutterapptest/widgets.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutterapptest/atm_bloc.dart';
import 'package:flutterapptest/atm_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
          create: (BuildContext context) => AtmBloc(), child: AtmHome()),
    );
  }
}


class AtmHome extends StatelessWidget {
  const AtmHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Image.asset('assets/appbar_logo.png', height: 26, width: 26),
              SizedBox(width: 4),
              Text(
                'ATM',
                style: TextStyle(
                  fontFamily: 'Trebuchet',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        flexibleSpace: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff3A26B3), Color(0xff6C18A4)])),
        ),
      ),
      body: BlocBuilder(
        bloc: BlocProvider.of<AtmBloc>(context),
        builder: (context, AtmState state) {
          final moneyController = MoneyMaskedTextController(
              decimalSeparator: '.', thousandSeparator: ' ', precision: 2);
          return LayoutBuilder(builder: (context, constraints) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                        minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Wave(
                              WaveClipper(0.7, [0.2, 1], [0.44, 0.9], [0.83, 0.75], [1, 1]),
                              opacity: 0.2,
                            ),
                            Wave(
                                WaveClipper(0.97, [0.1, 1], [0.3, 0.85], [0.7, 0.55], [1, 0.8]),
                                opacity: 0.4),
                            Wave(
                                WaveClipper(0.74, [0.28, 0.72], [0.51, 0.93], [0.73, 1.11], [1, 0.8]),
                                opacity: 0.7),
                            Wave(
                                WaveClipper(0.8, [0.3, 0.7], [0.5, 0.86], [0.77, 1.09], [1.1, 0.92]),
                                opacity: 0.7),
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 28),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: IntrinsicWidth(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          'Введите сумму',
                                          style: TextStyle(
                                            fontFamily: 'SFPro',
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        TextFormField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(9)
                                          ],
                                          controller: moneyController,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: false, decimal: false),
                                          style: TextStyle(
                                            fontFamily: 'SFPro',
                                            fontSize: 30,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                          decoration: InputDecoration(
                                              suffix: Text(
                                                ' руб',
                                                style: TextStyle(
                                                  fontFamily: 'SFPro',
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                fontFamily: 'Trebuchet',
                                                fontSize: 30,
                                                color: Colors.white,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 12),
                                          child: Opacity(
                                              opacity: 0.3,
                                              child: Divider(color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ButtonTheme(
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              color: Color(0xffE61EAD),
                              textColor: Colors.black,
                              padding: EdgeInsets.all(8.0),
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                BlocProvider.of<AtmBloc>(context)
                                    .onWithdraw(moneyController.numberValue);
                              },
                              child: Text(
                                'Выдать сумму',
                                style: TextStyle(
                                  fontFamily: 'SFPro',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            minWidth: 200,
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: Divider(color: Color(0xf3827B4), thickness: 10),
                        ),
                        state.currentOutput != null &&
                                state.currentOutput.keys.isNotEmpty
                            ? AtmOutputBlock(
                                limits: state.currentOutput,
                                title: 'Банкомат выдал следующие купюры')
                            : Padding(
                                padding: const EdgeInsets.only(top: 45, bottom: 45),
                                child: Text(
                                    state.currentOutput == null
                                        ? 'Банкомат не может выдать запрашиваемую сумму'
                                        : 'Введите сумму',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'SFPro',
                                      fontSize: 18,
                                      color: Color(0xFFE61EAD),
                                    )),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 13),
                          child: Divider(color: Color(0xf3827B4), thickness: 10),
                        ),
                        AtmOutputBlock(
                            limits: state.limits, title: 'Баланс банкомата'),
                        Padding(
                          padding: const EdgeInsets.only(top: 13),
                          child: Divider(color: Color(0xf3827B4), thickness: 10),
                        ),
                        Stack(
                          children: <Widget>[
                            Wave(
                                WaveClipper(0.3, [0.2, 0.85], [0.44, 0.65], [0.87, 0.18], [1, 0.25], rotate: true),
                                height: 105,
                                opacity: 0.2),
                            Wave(
                                WaveClipper(0.05, [0.15, 0.6], [0.44, 0.4], [0.69, 0.18], [1, 0.7], rotate: true),
                                height: 105,
                                opacity: 0.4),
                            Wave(
                                WaveClipper(0.37, [0.18, 0.2], [0.44, 0.37], [0.7, 0.57], [1, 0.538], rotate: true),
                                height: 105,
                                opacity: 0.7),
                            Wave(
                                WaveClipper(0.25, [0.18, 0.2], [0.48, 0.54], [0.69, 0.72], [1, 0.448], rotate: true),
                                height: 105,
                                opacity: 0.7),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class AtmOutputBlock extends StatelessWidget {
  const AtmOutputBlock({
    Key key,
    @required this.limits,
    @required this.title,
  }) : super(key: key);

  final Map<int, int> limits;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 19, top: 18),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'SFPro',
                fontSize: 13,
                color: Color(0xFFA3A2AC),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 29, top: 13),
            child: Wrap(
              children: <Widget>[
                OutBlock(
                    limits: limits,
                    startIndex: 0,
                    endIndex: (limits.keys.length / 2 == 0)
                        ? 0
                        : (limits.keys.length / 2).round()),
                OutBlock(
                    limits: limits,
                    startIndex: (limits.keys.length / 2 == 0)
                        ? 0
                        : (limits.keys.length / 2).round(),
                    endIndex: limits.keys.length)
              ],
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              spacing: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class OutBlock extends StatelessWidget {
  const OutBlock({
    Key key,
    @required this.limits,
    @required this.startIndex,
    @required this.endIndex,
  }) : super(key: key);

  final Map<int, int> limits;
  final int startIndex;
  final int endIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            limits.keys.toList().sublist(startIndex, endIndex).map((nominal) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Text("${limits[nominal]} X $nominal рублей",
                style: TextStyle(
                  fontFamily: 'SFPro',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3827B4),
                )),
          );
        }).toList());
  }
}
