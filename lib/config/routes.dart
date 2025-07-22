import '../models/items.dart';
import '../models/mySection.dart';
import '../ui/address/address.dart';
import '../ui/admin/manage_items/add_new_section.dart';
import '../ui/admin/admin_panel.dart';
import '../ui/admin/driver_requests.dart';
import '../ui/admin/manage_items/laundry_admin.dart';
import '../ui/admin/notifs_center.dart';
import '../ui/admin/orders.dart';
import '../ui/admin/product_orders.dart';
import '../ui/admin/reports.dart';
import '../ui/admin/users.dart';
import '../ui/home/home_screen.dart';
import '../ui/home/widgets/cart.dart';
import '../ui/home/widgets/my_account.dart';
import '../ui/home/widgets/our_products.dart';
import '../ui/laundry/laundry.dart';
import '../ui/login/login_screen.dart';
import '../ui/my_notifications/my_notifications.dart';
import '../ui/otp/views/otpScreen.dart';
import '../ui/prod_cart/prod_cart.dart';
import '../ui/product_details/product_detail.dart';
import '../ui/product_orders/product_orders.dart';
import '../ui/register/register_screen.dart';
import '../ui/request_driver/my_requests.dart';
import '../ui/request_driver/request_driver.dart';
import '../ui/splash/splash.dart';
import '../ui/sub_history/sub_history.dart';

import '../ui/admin/banners.dart';
import '../ui/admin/products_admin.dart';
import '../ui/order/order.dart';
import '../ui/privacy/privacy_policy.dart';
import '../ui/termsAndCondtitions/terms_and_conditions.dart';

class AppRoutes {
  static const splash = "/splash";
  static const login = "/login";
  static const verify = "/verify";
  static const register = "/register";
  static const manage = "/manage";
  static const forgetPwd = "/forgetPwd";
  static const adminOrders = "/adminOrders";
  static const home = "/homeScreen";
  static const addSection = "/addSection";
  static const otp = "/otp";
  static const request = "/request";
  static const laundry = "/laundry";
  static const address = "/address";
  static const order = "/order";
  static const payment = "/payment";
  static const admin = "/admin";
  static const banners = "/banners";
  static const users = "/users";
  static const reports = "/reports";
  static const details = "/details";
  static const laundryAdmin = "/laundryAdmin";
  static const subHistory = "/subHistory";
  static const myRequests = "/myRequests";
  static const adminRequests = "/adminRequests";
  static const notifsCenter = "/notifsCenter";
  static const myNotifs = "/myNotifs";
  static const ourProducts = "/ourProducts";
  static const cart = "/cart";
  static const prodOrdersAdmin = "/prodOrdersAdmin";
  static const acc = "/acc";
  static const privacy = "/privacy";
  static const terms = "/terms";
  static const productsOrders = "/productsOrders";
  static const productsAdmin = "/productsAdmin";
  static const productsCart = "/productsCart";

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return routingBuilder(
          const SplashScreen(),
        );
      case AppRoutes.login:
        return routingBuilder(
          const LoginScreen(),
        );
      case AppRoutes.productsAdmin:
        return routingBuilder(
          const ProductsAdmin(),
        );
      case AppRoutes.acc:
        return routingBuilder(
          const MyAccountScreen(),
        );
      case AppRoutes.register:
        return routingBuilder(
          const RegisterScreen(),
        );
      case AppRoutes.productsOrders:
        return routingBuilder(
          const ProductsOrders(),
        );
      case AppRoutes.cart:
        return routingBuilder(
          const CartScreen(),
        );
      case AppRoutes.ourProducts:
        return routingBuilder(
          const OurProducts(),
        );
      case AppRoutes.notifsCenter:
        return routingBuilder(
          const NotificationsCenter(),
        );
      case AppRoutes.myNotifs:
        return routingBuilder(
          const MyNotifications(),
        );
      case AppRoutes.addSection:
        return routingBuilder(
          AddSection(),
        );
      case AppRoutes.laundryAdmin:
        final data = settings.arguments as MySection;
        return routingBuilder(
          AdminLaundryScreen(
            section: data,
          ),
        );
      case AppRoutes.banners:
        return routingBuilder(
          const Banners(),
        );
      case AppRoutes.myRequests:
        return routingBuilder(
          const MyRequests(),
        );
      case AppRoutes.adminRequests:
        return routingBuilder(
          const DriverRequests(),
        );
      case AppRoutes.subHistory:
        return routingBuilder(
          const SubHistory(),
        );
      case AppRoutes.reports:
        return routingBuilder(
          const AllReports(),
        );
      case AppRoutes.order:
        final cartItems = settings.arguments as List<SubItem>;
        return routingBuilder(
          Order(cartItems: cartItems),
        );
      case AppRoutes.home:
        return routingBuilder(
          const HomeScreen(),
        );
      case AppRoutes.users:
        return routingBuilder(
          const AllUsers(),
        );
      case AppRoutes.adminOrders:
        return routingBuilder(
          const AllOrders(),
        );
      case AppRoutes.prodOrdersAdmin:
        return routingBuilder(
          const ProductsOrdersAdmin(),
        );
      case AppRoutes.details:
      final data = settings.arguments as Map<String,dynamic>;
        return routingBuilder(
           ProductDetails(product: data["product"],from: data["from"],),
        );
      case AppRoutes.request:
        return routingBuilder(
          const RequestDriverScreen(),
        );
         case AppRoutes.productsCart:
        return routingBuilder(
          const ProdCartScreen(),
        );
      case AppRoutes.admin:
        return routingBuilder(
          const AdminPanel(),
        );
      case AppRoutes.privacy:
        return routingBuilder(
          const PrivacyPolicy(),
        );
      case AppRoutes.terms:
        return routingBuilder(
          const TermsAndConditions(),
        );
      case AppRoutes.address:
        final navigateTo = settings.arguments as NavigationFromSettingsTo;
        return routingBuilder(
          AddressSettings(
            navigateTo: navigateTo,
          ),
        );

      case AppRoutes.laundry:
        final section = settings.arguments as MySection;
        return routingBuilder(
          LaundryScreen(
            section: section,
          ),
        );
      case AppRoutes.otp:
        final data = settings.arguments as Map<String, dynamic>;

        return routingBuilder(
          OtpScreen(
            username: data["username"],
          //  email:data["email"],
            navigateTo: data["navigateTo"],
            phoneNumber: data["phoneNumber"],
          ),
        );
    }
    return null;
  }
}

PageRoute routingBuilder(Widget screen) {
  return CupertinoPageRoute(
    builder: (context) => screen,
  );
}
