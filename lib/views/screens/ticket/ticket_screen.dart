import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mine_lab/core/helper/date_converter.dart';
import 'package:mine_lab/core/helper/string_format_helper.dart';
import 'package:mine_lab/core/route/route.dart';
import 'package:mine_lab/core/utils/dimensions.dart';
import 'package:mine_lab/core/utils/my_color.dart';
import 'package:mine_lab/core/utils/styles.dart';
import 'package:mine_lab/data/controller/support/support_controller.dart';
import 'package:mine_lab/data/repo/support/support_repo.dart';
import 'package:mine_lab/data/services/api_service.dart';
import 'package:mine_lab/l10n/app_localizations.dart';
import 'package:mine_lab/views/components/appbar/custom_appbar.dart';
import 'package:mine_lab/views/components/column_widget/card_column.dart';
import 'package:mine_lab/views/components/custom_loader.dart';
import 'package:mine_lab/views/components/floating_action_button/fab.dart';
import 'package:mine_lab/views/components/no_data.dart';
import 'package:mine_lab/views/components/shimmer/match_card_shimmer.dart';

class AllTicketScreen extends StatefulWidget {
  const AllTicketScreen({super.key});

  @override
  State<AllTicketScreen> createState() => _AllTicketScreenState();
}

class _AllTicketScreenState extends State<AllTicketScreen> {
  ScrollController scrollController = ScrollController();

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (Get.find<SupportController>().hasNext()) {
        Get.find<SupportController>().getSupportTicket(context);
      }
    }
  }

  @override
  void initState() {
    Get.put(ApiClient(sharedPreferences: Get.find()));
    Get.put(SupportRepo(apiClient: Get.find()));
    final controller = Get.put(SupportController(repo: Get.find()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData(context);
      scrollController.addListener(scrollListener);
    });
  }

  @override
  Widget build(BuildContext context) {
    final MyStrings = context != null ? AppLocalizations.of(context)! : null;

    return GetBuilder<SupportController>(builder: (controller) {
      return Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
            bgColor: MyColor.primaryColor, title: MyStrings!.supportTicket),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.loadData(context);
          },
          color: MyColor.primaryColor,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics()),
                  padding: Dimensions.defaultPaddingHV,
                  child: controller.isLoading
                      ? ListView.builder(
                          itemCount: 10,
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return const MatchCardShimmer();
                          },
                        )
                      : controller.ticketList.isEmpty
                          ? Center(
                              child: NoDataWidget(
                                text: MyStrings.noTicketFound.toCapitalized(),
                              ),
                            )
                          : ListView.separated(
                              controller: scrollController,
                              itemCount: controller.ticketList.length + 1,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: Dimensions.space10),
                              itemBuilder: (context, index) {
                                if (controller.ticketList.length == index) {
                                  return controller.hasNext()
                                      ? const CustomLoader(isPagination: true)
                                      : const SizedBox();
                                }
                                return GestureDetector(
                                  onTap: () {
                                    String id =
                                        controller.ticketList[index].ticket ??
                                            '-1';
                                    String subject =
                                        controller.ticketList[index].subject ??
                                            '';
                                    Get.toNamed(RouteHelper.ticketDetailsScreen,
                                        arguments: [id, subject]);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimensions.space10,
                                        vertical: Dimensions.space25),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.mediumRadius),
                                        border: Border.all(
                                            color: MyColor.cardBorderColor,
                                            width: 1)),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                        end:
                                                            Dimensions.space10),
                                                child: Column(
                                                  children: [
                                                    CardColumn(
                                                      header:
                                                          "[${MyStrings.ticket.tr}#${controller.ticketList[index].ticket}] ${controller.ticketList[index].subject}",
                                                      body:
                                                          "${controller.ticketList[index].lastReply}",
                                                      space: 5,
                                                      headerTextDecoration:
                                                          interRegularDefault
                                                              .copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge
                                                            ?.color,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      bodyTextDecoration:
                                                          interRegularDefault
                                                              .copyWith(
                                                        color: MyColor
                                                            .ticketDetails,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimensions.space10,
                                                      vertical:
                                                          Dimensions.space5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: controller
                                                    .getStatusColor(controller
                                                            .ticketList[index]
                                                            .status ??
                                                        "0")
                                                    .withValues(alpha: 0.2),
                                                border: Border.all(
                                                  color:
                                                      controller.getStatusColor(
                                                    controller.ticketList[index]
                                                            .status ??
                                                        "0",
                                                  ),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                controller.getStatusText(
                                                    controller.ticketList[index]
                                                            .status ??
                                                        '0',
                                                    context),
                                                style: interRegularDefault
                                                    .copyWith(
                                                  color: controller
                                                      .getStatusColor(controller
                                                              .ticketList[index]
                                                              .status ??
                                                          "0"),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                            height: Dimensions.space15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimensions.space10,
                                                      vertical:
                                                          Dimensions.space5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: controller
                                                    .getStatusColor(
                                                        controller
                                                                .ticketList[
                                                                    index]
                                                                .priority ??
                                                            "0",
                                                        isPriority: true)
                                                    .withValues(alpha: 0.2),
                                                border: Border.all(
                                                    color: controller
                                                        .getStatusColor(
                                                            controller
                                                                    .ticketList[
                                                                        index]
                                                                    .priority ??
                                                                "0",
                                                            isPriority: true),
                                                    width: 1),
                                              ),
                                              child: Text(
                                                controller.getStatus(
                                                    controller.ticketList[index]
                                                            .priority ??
                                                        '1',
                                                    context,
                                                    isPriority: true),
                                                style: interRegularDefault
                                                    .copyWith(
                                                  color:
                                                      controller.getStatusColor(
                                                          controller
                                                                  .ticketList[
                                                                      index]
                                                                  .priority ??
                                                              "0",
                                                          isPriority: true),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              DateConverter
                                                  .getFormatedSubtractTime(
                                                      controller
                                                              .ticketList[index]
                                                              .createdAt ??
                                                          ''),
                                              style:
                                                  interRegularDefault.copyWith(
                                                      fontSize: 10,
                                                      color: MyColor
                                                          .ticketDateColor),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FAB(
          callback: () {
            Get.toNamed(RouteHelper.newTicketScreen)?.then((value) =>
                {Get.find<SupportController>().getSupportTicket(context)});
          },
        ),
      );
    });
  }
}
