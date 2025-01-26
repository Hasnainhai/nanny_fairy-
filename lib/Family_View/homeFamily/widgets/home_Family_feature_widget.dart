import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../res/components/colors.dart';
import '../../../res/components/widgets/vertical_spacing.dart';

class HomeFeatureContainerFamily extends StatefulWidget {
  const HomeFeatureContainerFamily({
    super.key,
    required this.img,
    required this.title,
    required this.bgColor,
    required this.txColor,
    required this.ontap,
  });

  final String img;
  final String title;
  final Color bgColor;
  final Color txColor;
  final VoidCallback ontap;

  @override
  _HomeFeatureContainerFamilyState createState() =>
      _HomeFeatureContainerFamilyState();
}

class _HomeFeatureContainerFamilyState
    extends State<HomeFeatureContainerFamily> {
  late final ScrollController _scrollController;
  bool _shouldScroll = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow();
    });
  }

  void _checkTextOverflow() {
    // Measure the width of the text to see if it overflows
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.title,
        style: GoogleFonts.getFont(
          "Poppins",
          textStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: widget.txColor),
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    // If text width is greater than the container width, enable scrolling
    if (textPainter.width > 100) {
      setState(() {
        _shouldScroll = true;
      });
      _startScrolling();
    }
  }

  void _startScrolling() {
    // Start the scroll from left to right and loop
    Future.delayed(const Duration(seconds: 1), () {
      if (_scrollController.hasClients) {
        _scrollToEnd();
      }
    });
  }

  void _scrollToEnd() {
    _scrollController
        .animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 6),
      curve: Curves.linear,
    )
        .then((_) {
      // Reset to the start position
      _scrollController.jumpTo(0.0);
      _startScrolling(); // Start scrolling again from left to right
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: widget.bgColor,
          border: Border.all(
            strokeAlign: BorderSide.strokeAlignCenter,
            color: AppColor.lavenderColor.withOpacity(0.10),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.lavenderColor.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(1, 2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 47,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.img),
                  ),
                ),
              ),
              const VerticalSpeacing(10),
              SizedBox(
                height: 15,
                width: 108,
                child: _shouldScroll
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _scrollController,
                        child: Row(
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.getFont(
                                "Poppins",
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: widget.txColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      )
                    : Center(
                        child: Text(
                          widget.title,
                          style: GoogleFonts.getFont(
                            "Poppins",
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: widget.txColor,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
