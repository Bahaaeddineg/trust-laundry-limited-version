
import '../../logic/address/address_cubit.dart';
import '../../logic/theme/theme_cubit.dart';
import 'widgets/add_address_or_modify.dart';
import '../../constants/fonts.dart';
import 'widgets/add_address.dart';

enum NavigationFromSettingsTo { myaccount, order }

class AddressSettings extends StatefulWidget {
  final NavigationFromSettingsTo navigateTo;
  const AddressSettings({super.key, required this.navigateTo});

  @override
  State<AddressSettings> createState() => _AddressSettingsState();
}

class _AddressSettingsState extends State<AddressSettings> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddressCubit>(context).getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.kBlueLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        toolbarHeight: width / 10 < 56 ? 56 : width / 10, // Responsive height
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.kWhite,
            size: width / 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.navigateTo == NavigationFromSettingsTo.myaccount
              ? S.of(context).addressSet
              : S.of(context).chooseAddress,
          style: TextStyle(
            fontSize: width / 18,
            color: AppColors.kWhite,
            fontFamily: AppFonts.poppins,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width / 18,
          vertical: height / 40,
        ),
        child: Column(
          children: [
            BlocBuilder<AddressCubit, AddressState>(
              builder: (context, state) {
                if (state is AddressSuccess) {
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: height / 70);
                    },
                    itemCount: state.myAddresses.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          if (widget.navigateTo ==
                              NavigationFromSettingsTo.order) {
                            if (!state.myAddresses[index].isExact) {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return AddAdressOrModify(
                                    myAddress: state.myAddresses[index],
                                    addOrModify: AddOrModify.modify,
                                  );
                                },
                              );
                            }
                          }
                        },
                        onTap: () {
                          if (widget.navigateTo ==
                              NavigationFromSettingsTo.order) {
                            Navigator.pop(context, state.myAddresses[index]);
                          } else {
                            if (!state.myAddresses[index].isExact) {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return AddAdressOrModify(
                                    myAddress: state.myAddresses[index],
                                    addOrModify: AddOrModify.modify,
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.kBlueLight,
                              radius: width / 16,
                              child: CircleAvatar(
                                radius: width / 18,
                                backgroundColor: AppColors.kWhite,
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    fontSize: width / 18,
                                    color: AppColors.kBlueLight,
                                    fontFamily: AppFonts.poppins,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width / 30),
                            BlocBuilder<ThemeCubit, bool>(
                              builder: (context, isDark) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.myAddresses[index].addressTitle,
                                      style: TextStyle(
                                        fontSize: width / 24,
                                        fontFamily: AppFonts.poppins,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    state.myAddresses[index].apartmentNum !=
                                            null
                                        ? RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${S.of(context).street}: ",
                                                  style: TextStyle(
                                                    fontSize: width / 32,
                                                    color: isDark
                                                        ? AppColors.kWhite
                                                        : AppColors.kBlack,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                    fontWeight: FontWeight
                                                        .bold, // Bold for title
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "${state.myAddresses[index].street}",
                                                  style: TextStyle(
                                                    fontSize: width / 32,
                                                    color: isDark
                                                        ? AppColors.kWhite
                                                        : AppColors.kBlack,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                    fontWeight: FontWeight
                                                        .w400, // Regular weight for content
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                    state.myAddresses[index].apartmentNum !=
                                            null
                                        ? RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "${S.of(context).appartementNumber}: ",
                                                  style: TextStyle(
                                                    fontSize: width / 32,
                                                    color: isDark
                                                        ? AppColors.kWhite
                                                        : AppColors.kBlack,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                    fontWeight: FontWeight
                                                        .bold, // Bold for title
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: state
                                                      .myAddresses[index]
                                                      .apartmentNum,
                                                  style: TextStyle(
                                                    fontSize: width / 32,
                                                    color: isDark
                                                        ? AppColors.kWhite
                                                        : AppColors.kBlack,
                                                    fontFamily:
                                                        AppFonts.poppins,
                                                    fontWeight: FontWeight
                                                        .w400, // Regular weight for content
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                );
                              },
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                if (await confirm(
                                  context,
                                  content: Text(
                                    "${S.of(context).addressSure}: ",
                                    style: TextStyle(
                                      fontSize: width / 32,

                                      fontFamily: AppFonts.poppins,
                                      fontWeight:
                                          FontWeight.bold, // Bold for title
                                    ),
                                  ),
                                )) {
                                  context.read<AddressCubit>().deleteAddress(
                                    id: state.myAddresses[index].id,
                                  );
                                }
                              },
                              child: Icon(
                                Icons.delete,
                                color: AppColors.kRed,
                                size: width / 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            SizedBox(height: height / 40),
            SizedBox(
              width: width,
              height: height / 17,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return AddAdress(
                        // myAddress: null,
                        // addOrModify: AddOrModify.add,
                      );
                    },
                  );
                },
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: AppColors.kBlueLight),
                    ),
                  ),
                  backgroundColor: const WidgetStatePropertyAll(
                    AppColors.kWhite,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Ionicons.add,
                      color: AppColors.kBlueLight,
                      size: width / 18,
                    ),
                    Text(
                      S.of(context).addAddress,
                      style: TextStyle(
                        fontSize: width / 26,
                        color: AppColors.kBlueLight,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
