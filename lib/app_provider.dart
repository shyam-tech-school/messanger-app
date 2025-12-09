import 'package:mail_messanger/features/auth/presentation/provider/otp_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppProvider {
  static List<SingleChildWidget> provider = [
    ChangeNotifierProvider(create: (_) => OtpTimerProvider()),
  ];
}
