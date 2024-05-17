import 'package:flutter/material.dart';
import 'package:kidneyscan/constants/colors/app_colors.dart';
import 'package:kidneyscan/controllers/internet_controller.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  // @override
  // void initState() {
  //   Provider.of<InternetController>(context, listen: false).startStreaming();
  //   super.initState();
  // }

  bool isDelay = true;

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        'https://www.sciencedirect.com/science/article/pii/S0085253815526495'));
  @override
  Widget build(BuildContext context) {
    return Consumer<InternetController>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: AppColors().white,
          body: viewModel.isConnected
              ?  WebViewWidget(
                      controller: controller,
                    )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_outlined,
                        size: 6.h,
                      ),
                      SizedBox(height: 2.h),
                      const Text("Please check your internet connection")
                    ],
                  ),
                ),
        );
      },
    );
  }
  
  setIndicator() {
     setState(() {
       isDelay=false;
     });
  }
}
