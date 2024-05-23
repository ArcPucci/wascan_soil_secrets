import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wascan_soil_secrets/blocs/game_bloc/game_bloc.dart';
import 'package:wascan_soil_secrets/utils/text_style_helper.dart';
import 'package:wascan_soil_secrets/utils/theme_helper.dart';
import 'package:wascan_soil_secrets/widgets/custom_button.dart';

class JackpotScreen extends StatefulWidget {
  const JackpotScreen({Key? key}) : super(key: key);

  @override
  State<JackpotScreen> createState() => _JackpotScreenState();
}

class _JackpotScreenState extends State<JackpotScreen> {
  late Timer _timer;
  late GameBloc _gameBloc;

  static const int xLength = 100;
  final List<double> _numberList = [];

  ui.Image? _uiImage;
  bool jackpotDone = false;

  int index = 0;
  double dy = 0;
  int count = 0;
  bool toUp = true;
  double score = 0;
  final double axisLength = 344.h;
  double axisLengthLimit = 0;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _gameBloc = BlocProvider.of(context);
    int coefficient = Random().nextInt(50);
    axisLengthLimit = (axisLength / 100) * 5.9;

    _timer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        if (index >= xLength) {
          _onTap();
          _timer.cancel();
        }

        index++;

        final y = axisLength +
            cos(index / (pi * 3)) * (coefficient + dy) -
            (coefficient + dy);

        _numberList.add(y);
        score = (((axisLength - y) / axisLength) * 10);

        count++;

        if (toUp) {
          dy++;
        } else {
          dy--;
        }

        if (count >= 10) {
          toUp = Random().nextBool();
          count = 0;
        }

        if (y >= axisLength) {
          toUp = true;
        } else if (y <= axisLengthLimit) {
          toUp = false;
        }
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 5,
          sigmaX: 5,
        ),
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            return Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  jackpotDone ? _buildResultBody() : _buildGraphBody(),
                  CustomButton(
                    onTap: _onTap,
                    text: jackpotDone ? "CONTINUE" : "STOP",
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGraphBody() {
    return Column(
      children: [
        SizedBox(height: 120.h),
        SizedBox(
          width: 327.w,
          height: 368.h,
          child: CustomPaint(
            size: Size(327.w, 368.h),
            painter: JackpotPainter(
              numberList: _numberList,
              image: _uiImage,
              score: score,
            ),
          ),
        ),
        SizedBox(height: 157.h),
      ],
    );
  }

  Widget _buildResultBody() {
    return Column(
      children: [
        SizedBox(height: 160.h),
        Stack(
          children: [
            SizedBox(
              width: 220.w,
              height: 220.h,
              child: Image.asset(
                "assets/png/big_beetle.png",
                fit: BoxFit.contain,
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
              child: SizedBox(
                width: 220.w,
                height: 220.h,
                child: Image.asset(
                  "assets/png/big_beetle.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "YOU GOT",
                  style: TextStyleHelper.helper8,
                ),
                Text(
                  "X${double.parse(score.toStringAsFixed(1)).abs()}",
                  style: TextStyleHelper.helper10,
                ),
                Text(
                  "TO YOUR BALANCE",
                  style: TextStyleHelper.helper7,
                ),
              ],
            ),
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "YOU GOT",
                    style: TextStyleHelper.helper8,
                  ),
                  Text(
                    "X${double.parse(score.toStringAsFixed(1)).abs()}",
                    style: TextStyleHelper.helper10,
                  ),
                  Text(
                    "TO YOUR BALANCE",
                    style: TextStyleHelper.helper7,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 121.h),
      ],
    );
  }

  void _onTap() {
    if (!jackpotDone) {
      _gameBloc.add(ContinueGameEvent(
          jackpotCoefficient: double.parse(score.toStringAsFixed(1))));
      jackpotDone = true;
      _timer.cancel();
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

  void _loadImage() async {
    ByteData bd = await rootBundle.load("assets/png/icons/beetle.png");

    final Uint8List bytes = Uint8List.view(bd.buffer);

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);

    final ui.Image image = (await codec.getNextFrame()).image;

    _uiImage = image;
  }
}

class JackpotPainter extends CustomPainter {
  final List<double> numberList;
  final double score;
  final ui.Image? image;

  JackpotPainter({
    this.image,
    required this.numberList,
    required this.score,
  });

  late Size size;
  late Canvas canvas;
  static const int xLength = 100;
  double stepX = 280.w / xLength;
  static double max = 344.h;

  @override
  void paint(Canvas canvas, Size size) {
    _init(canvas, size);
    _drawAxisLines();
    _drawCircles();
    _drawSine();

    _drawCoefficientText('X${score.toStringAsFixed(1)}');
    _drawImage();
  }

  void _init(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.size = size;
  }

  void _drawAxisLines() {
    var paintChart = Paint()
      ..color = const Color(0xFFEB863D).withOpacity(0.3)
      ..strokeWidth = 2.w;
    canvas.drawLine(Offset(13.w, 0), Offset(13.w, 353.h), paintChart);
    canvas.drawLine(Offset(12.w, 354.h), Offset(327.w, 354.h), paintChart);
  }

  void _drawCircles() {
    var paintCircle = Paint()..color = const Color(0xFFEB863D).withOpacity(0.3);
    for (int i = 1; i < 23; i += 2) {
      canvas.drawCircle(Offset(4.w, i * 16.h), 4.sp, paintCircle);
    }
    for (int i = 0; i < 10; i++) {
      canvas.drawCircle(Offset(i * 32.w + 28.w, 364.h), 4.sp, paintCircle);
    }
  }

  void _drawSine() {
    if (numberList.isEmpty) return;

    if (max > numberList.last) {
      max = numberList.last;
    }

    final colors = [
      const Color(0xFFEB863D),
      const Color(0xFFEB863D).withOpacity(0.0),
    ];
    final colorStops = [0.0, 1.0];
    final gradient = ui.Gradient.linear(
      Offset(0.0, max),
      Offset(0.0, 344.h),
      colors,
      colorStops,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFFEB863D)
      ..strokeWidth = 2.sp;

    final path = Path();
    double x = 28.w;
    double y = 344.h;

    path.moveTo(x, y);

    for (int i = 0; i < numberList.length; i++) {
      path.lineTo(x, numberList[i].toDouble());
      x += stepX;
    }

    Path path2 = Path.from(path);
    path2
      ..lineTo(x, y)
      ..lineTo(x, y);
    path2.close();

    Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient;

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint2);
  }

  void _drawCoefficientText(String text) {
    TextSpan span = TextSpan(
      style: TextStyleHelper.helper8.copyWith(
        color: ThemeHelper.orange,
      ),
      text: text,
    );

    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    textPainter.paint(canvas, Offset(size.width - 80, 0));
  }

  void _drawImage() {
    if (image == null) return;

    final imagePaint = Paint()..isAntiAlias = false;

    double x = 28.w;

    x += numberList.length * stepX;

    canvas.drawImage(
      image!,
      Offset(x - 15, numberList.last - 40),
      imagePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
