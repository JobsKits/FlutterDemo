import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/account/register/register_widget.dart';
import 'package:flutter_bet/pages/account/register/view.dart';
import 'package:flutter_bet/pages/find/logic.dart';
import 'package:flutter_bet/pages/find/widget/casino_changguan_flip_list.dart';
import 'package:flutter_bet/pages/find/widget/casino_tabbar.dart';
import 'package:flutter_bet/pages/find/yulecheng_details/widgets/big_lucky_wins.dart';
import 'package:flutter_bet/pages/front/widget/front_casino_competition_view.dart';
import 'package:flutter_bet/pages/front/widget/front_competition_view.dart';
import 'package:flutter_bet/pages/front/widget/front_sport_competition_view.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/button/custom_small_mian_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/custom_top_appbar_logo_title_view.dart';
import 'package:flutter_bet/widget/input/custom_text_field.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../widget/casino_page_flip_list.dart';
import 'index.dart';

final GlobalKey globalKey = GlobalKey();

class YulechengGongPingXingPage extends BaseView<YulechengGongPingXingController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
        titleSpacing: 12.0,
        showLeading: false,
        onBackTap: () {
          RouteUtil.popToFirst(Routes.mainPage);
          return;
        },
        titleView: CustomTopAppBarLogoTitleView(
          title: "",
          logoTap: () {
            RouteUtil.popToFirst(Routes.mainPage);
            return;
          },
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    controller.context = context;
    return GetBuilder<YulechengGongPingXingController>(
        id: "yulecheng_gongpingxing",
        builder: (context1) {
          return SingleChildScrollView(
            child: <Widget>[
              const SizedBox(height: AppValues.defaultMargin),
              buildTopView(context),
              const SizedBox(height: AppValues.defaultMargin),
              buildSwitch(),
              buildeDetails(context)
                  .paddingHorizontal(AppValues.defaultPadding)
                  .paddingTop(AppValues.defaultPadding),
              SizedBox(
                height: AppValues.barBottomHeight,
              ),
            ].toColumn(),
          );
        });
  }

  Widget buildTopView(context) {
    return <Widget>[
      SvgPicture.asset("assets/svg/vip_header_icon.svg").tightSize(AppValues.iconSize_18),
      const SizedBox(width: AppValues.defaultPadding),
      CustomText("可证明的公平性",
          style: ThemeService()
              .theme
              .textTheme
              .titleMedium
              ?.copyWith(fontSize: AppValues.fontBodyLargeSize, fontWeight: FontWeight.w600)),
      const Spacer(),
      const CustomIcon(
              asset: 'assets/images/normal/ic_normal_close.png', size: AppValues.iconSize_18)
          .marginOnly(left: AppValues.defaultMargin)
          .center()
          .onTap(() {
        // controller.globalController
        //     .showOverlayView(isShowTopBarView: true, isShowBottomBarView: true);
        RouteUtil.popView();
      })
    ]
        .toRow()
        .height(25.2)
        .paddingBottom(AppValues.defaultPadding)
        .paddingHorizontal(AppValues.defaultPadding);
  }

  // 晋级奖金/返水/日份绿.... Tab
  Widget buildSwitch() {
    return DefaultTabController(
            length: controller.tabsNoIcons.length,
            child: CustomTabBarWithIcon(
                tabController: controller.tabController,
                tabs: controller.tabsNoIcons,
                backgroundColor: ThemeService().theme.colorScheme.tertiary,
                labelStyle: ThemeService()
                    .theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                unselectedLabelStyle: ThemeService()
                    .theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
                height: 54,
                radius: 27,
                isShowScrollBar: true))
        .backgroundColor(ThemeService().theme.colorScheme.surface)
        .clipRRect(
            topLeft: 30,
            topRight: controller.tabIndex == 3 || controller.tabIndex == 4 ? 30 : 30,
            bottomLeft: 30,
            bottomRight: controller.tabIndex == 3 || controller.tabIndex == 4 ? 30 : 30)
        .paddingHorizontal(AppValues.defaultPadding);
  }

  //  内容
  Widget buildeDetails(context) {
    switch (controller.tabIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("Solving the Trust Issue with Online Gambling"),
            const SizedBox(height: AppValues.defaultPadding),
            Html(
                style: {
                  "div": Style(
                      padding: HtmlPaddings.zero,
                      color: Color(0xffb1bad3),
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.w600),
                },
                data:
                    "<div><p>The underlying concept of <a href=\"https://en.wikipedia.org/wiki/Provable_fairness\">provable fairness</a> is that players have the ability to prove and verify that their results are fair and unmanipulated. This is achieved through the use of a <a class=\"text-tg-text-white text-[14px]\" href=\"https://en.wikipedia.org/wiki/Commitment_scheme\" target=\"_blank\">commitment scheme <svg data-v-8268db5d=\"\" class=\"app-svg-icon has-transition text-[12px]\" aria-hidden=\"true\"><use data-v-8268db5d=\"\" xlink:href=\"#icon-uni-jump-page\"></use></svg></a> , along with cryptographic hashing. </div><div class=\"text-tg-secondary-light mt-16 text-[16px] leading-[1.5] xl:text-[18px]\"> The commitment scheme is used to ensure that the player has an influence on all results generated. Cryptographic hashing is used to ensure that the casino also remains honest to this commitment scheme. Both concepts combined creates a trust-less environment when gambling online. </p><p> This is simplified in the following representation: </p></div>"),
            getDetailsWidgetWithBackColor(
                "fair result = operators input (hashed) + customers input ",
                color: Colors.white),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("3rd Party Verification "),
            getDetailsWidget(
                "All Meibo Originals played on Meibo can be verified both here and via 3rd party websites who have also open sourced the verification procedure. You can find them via a google search, or simply check out some of these that have been put together by our community: "),
            const SizedBox(height: AppValues.defaultPadding),
            Html(
                data:
                    "<div><ul><li><a href=\"https://provablyfair.me\" >https:// provablyfair.me</a></li></ul></div>"),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("Crypto Gambling Foundation "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "Meibo is a verified operator on the Crypto Gambling Foundation network. This foundation aims to uphold the highest standard of provably fair gambling and we are proud to be a part of their network. You can find further information and insights about provable fairness and the power it has in this industry, check out the Crypto Gambling Foundation via their website: "),
            Html(
                data:
                    "<div><a href=\"https://provablyfair.me\" >https:// provablyfair.me</a></div>"),
            const SizedBox(height: AppValues.defaultPadding),
            Image.asset(
              "assets/images/yulecheng/gongpingxing_verified.webp",
              width: 120,
              height: 59.63,
            ),
            const SizedBox(height: AppValues.defaultPadding),
          ],
        )
            .paddingHorizontal(AppValues.defaultPadding)
            .backgroundColor(AppThemes.oddBackColor)
            .clipRRect(all: 4);

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("Random Number Generation "),
            Html(
              style: {
                "div": Style(
                    padding: HtmlPaddings.zero,
                    color: Color(0xffb1bad3),
                    fontSize: FontSize.large,
                    fontWeight: FontWeight.w600),
              },
              data:
                  "<div><p>For each verifiable bet, a client seed, a server seed, a nonce and a cursor are used as the input parameters for the <a href=\"https://en.wikipedia.org/wiki/Random_number_generation\">random number generation </a>function. This function utilises the cryptographic hash function </p><p><a  href=\"https://en.wikipedia.org/wiki/HMAC\">HMAC_SHA256 </a>to generate bytes which are then used as the foundation for how we generate provably fair random outcomes on our platform. </p></div>",
            ),
            getDetailsWidgetWithBackColor(
                """ // Random number generation based on following inputs: serverSeed, clientSeed, nonce and cursor
function byteGenerator({ serverSeed, clientSeed, nonce, cursor }) {
  // Setup curser variables
  let currentRound = Math.floor(cursor / 32);
  let currentRoundCursor = cursor;
  currentRoundCursor -= currentRound * 32;

  // Generate outputs until cursor requirement fullfilled
  while (true) {
    // HMAC function used to output provided inputs into bytes
    const hmac = createHmac('sha256', serverSeed);
    hmac.update(`\${clientSeed}:\${nonce}:\${currentRound}`);
    const buffer = hmac.digest();

    // Update curser for next iteration of loop
    while (currentRoundCursor &lt; 32) {
      yield Number(buffer[currentRoundCursor]);
      currentRoundCursor += 1;
    }
    currentRoundCursor = 0;
    currentRound += 1;
  }
} """,
                color: Colors.white),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget(" Server Seed "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " The server seed is generated by our system as a random 64-character hex string. You are then provided with an encrypted hash of that generated server seed before you place any bets. The reason we provide you with the encrypted form of the server seed is to ensure that the un-hashed server seed cannot be changed by the casino operator, and that the player cannot calculate the results beforehand. "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " To reveal the server seed from its hashed version, the seed must be rotated by the player, which triggers the replacement with a newly generated one. "),
            getDetailsWidget(
                " From this point you are able to verify that the hashed server seed matches that of the un-hashed server seed. This process can be verified via our un-hashed server seed function found in the menu above. "),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget(" Client Seed "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " The client seed belongs to the player and is used to ensure they have influence on the randomness of the outcomes generated. Without this component of the algorithm, the server seed alone would have complete leverage over the outcome of each bet. "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " All players are free to edit and change their client seed regularly to create a new chain of random upcoming outcomes. This ensures the player has absolute control over the generation of the result, similar to cutting the deck at a brick and mortar casino. "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " During registration, a client seed is created for you by your browser, to ensure your initial experience with the site goes uninterrupted. Whilst this randomly generated client seed is considered suitable, we highly recommend that you choose your own, so that your influence is included in the randomness. "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(" You can do this via the fairness modal. "),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget(" Nonce "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " The nonce is simply a number that increments as every new bet is made. Due to the nature of the SHA256 cryptographic function, this creates a completely new result each time, without having to generate a new client seed and server seed. "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " The implementation of nonce, ensures we remain committed to your client seed and server seed pair, whilst generating new results for each bet placed. "),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget(" Cursor (Incremental Number) "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " We use 4 bytes of data to generate a single game result, and because SHA256 is limited to 32 bytes, we utilise this implementation of a cursor to give us the ability to create more game events without having to modify our provable fair algorithm. "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " The cursor is only iterated over when the game being played requires the generation of more than 8 (32 bytes / 4 bytes) possible outcomes. For example: when we need to use more than 8 cards in a game of blackjack. "),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                " The cursor starts as 0 and gets increased by 1 every time the 32 bytes are returned by the HMAC_SHA256 function. If we don’t require more than 8 random numbers to be generated for the game events, then the curser does not increment as there is no need to generate any additional possible game outcomes. "),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget(" Games with More Than 1 Incremental Number: "),
            const SizedBox(height: AppValues.defaultPadding),
            Html(
                style: {
                  "div": Style(
                      padding: HtmlPaddings.zero,
                      color: Color(0xffb1bad3),
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.w600),
                },
                data:
                    "<div><ul><li> Plinko (2 increments per game to cover possible 16 decisions) </li></ul></div>"),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget(
                " Games with More Than 1 Incremental Number (Represented as Default Value 0): "),
            Html(style: {
              "div": Style(
                  padding: HtmlPaddings.zero,
                  color: Color(0xffb1bad3),
                  fontSize: FontSize.large,
                  fontWeight: FontWeight.w600),
            }, data: "<div><ul><li>  Dice  </li><li>   Limbo   </li></ul></div>"),
            const SizedBox(height: AppValues.defaultPadding),
          ],
        )
            .paddingHorizontal(AppValues.defaultPadding)
            .backgroundColor(AppThemes.oddBackColor)
            .clipRRect(all: 4);

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("Bytes to Floats"),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "The output of the Random Number Generator (byteGenerator) function is a hexadecimal 32-byte hash. As explained under the cursor implementation, we use 4 bytes of data to generate a single game result. Each set of 4 bytes are used to generate floats between 0 and 1 (4 bytes are used instead of one to ensure a higher level of precision when generating the float.) It is with these generated floats that we derive the formal output of the provable fair algorithm before it is translated into game events."),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidgetWithBackColor(
                """// Convert the hash output from the rng byteGenerator to floats
function generateFloats ({ serverSeed, clientSeed, nonce, cursor, count }) {
  // Random number generator function
  const rng = byteGenerator({ serverSeed, clientSeed, nonce, cursor });
  // Declare bytes as empty array
  const bytes = [];

  // Populate bytes array with sets of 4 from RNG output
  while (bytes.length < count * 4) {
    bytes.push(rng.next().value);
  }

  // Return bytes as floats using lodash reduce function
  return _.chunk(bytes, 4).map(bytesChunk =>
    bytesChunk.reduce((result, value, i) => {
      const divider = 256 ** (i + 1);
      const partialResult = value / divider;
      return result + partialResult;
    }, 0)
  );
};""",
                color: Colors.white),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("Floats to Game Events"),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "Where the process of generating random outputs is universal for all our games, it's at this point in the game outcome generation where a unique procedure is implemented to determine the translation from floats to game events."),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "The randomly float generated is multiplied by the possible remaining outcomes of the particular game being played. For example: In a game that uses a 52 card deck, this would simply be done by multiplying the float by 52. The result of this equation is then translated into a corresponding game event. For games where multiple game events are required, this process continues through each corresponding 4 bytes in the result chain that was generated using the described byteGenerator function."),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("Shuffle of Game Events"),
            Html(
                style: {
                  "div": Style(
                      padding: HtmlPaddings.zero,
                      color: Color(0xffb1bad3),
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.w600),
                },
                data:
                    "<div><p>For games such as Keno, Mines and Video Poker, where outcomes cannot be duplicated, we then utilise the <a href=\"https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle\">Fisher-Yates shuffle algorithm</a>. This procedure influences the conversion process from floats to game events because each time a game event is translated, the amount of possible remaining game event possibilities has been reduced for any remaining steps in the result chain.</p></div>"),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "As an example, in video poker, there is at first 52 cards available in the complete deck, and therefore the first game event is translated by multiplying the float by 52. Once this card has been dealt, there is only 51 remaining cards in the deck, and therefore the second card translation is done by multiplying the second float generated by 51. This continues in the same fashion until all the game events required have been generated."),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "With regards to Mines and Keno, this is simply a matter of implementing the same process as explained with video poker but changing that to tiles or locations on the board or grid, ensuring that each game event generated, hasn’t already been done so beforehand in the chain of results."),
            const SizedBox(height: AppValues.defaultPadding),
          ],
        )
            .paddingHorizontal(AppValues.defaultPadding)
            .backgroundColor(AppThemes.oddBackColor)
            .clipRRect(all: 4);
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "Game events are translation of the randomly generated floats into a relatable outcome that is game specific. This includes anything from the outcome of a dice roll to the order of the cards in a deck, or even the location of every bomb in a game of mines."),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "Below is a detailed explanation as to how we translate floats into events for each particular different game on our platform."),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("Dice Roll"),
            getDetailsWidget(
                "In our version of dice, we cover a possible roll spread of 00.00 to 100.00, which has a range of 10,001 possible outcomes. The game event translation is done by multiplying the float by number of possible outcomes and then dividing by 100 so that the resulting number fits the constraints of our stated dice range."),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidgetWithBackColor("""// Game event translation
const roll = (float * 10001) / 100;""", color: Colors.white),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("Limbo"),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "When it comes to Limbo, we use a two-step process. Firstly, we take the float and multiply it by both the maximum possible multiplier and the house edge. Then, in order to generate a game event that has probability distribution  , we divide the maximum possible multiplier by the result of the first step to create the game event in the form of a crash point."),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidgetWithBackColor("""// Game event translation with houseEdge of 0.99 (1%)
const floatPoint = 1e8 / (float * 1e8) * houseEdge;

// Crash point rounded down to required denominator
const crashPoint = Math.floor(floatPoint * 100) / 100;

// Consolidate all crash points below 1
const result = Math.max(crashPoint, 1);""", color: Colors.white),
            const SizedBox(height: AppValues.defaultPadding),
            getTitleWidget("Plinko"),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidget(
                "For any game of Plinko, the generated outcome is based on the path of the falling ball. The game event determines the direction of the falling ball for each level in the falling process. Players can choose between 8 and 16 pins of play, which determines the number of game events required to generate a complete path from top to bottom. Since there are only two possible directions (left or right) the translation is done by multiplying each float by 2, which maps to the following index:"),
            const SizedBox(height: AppValues.defaultPadding),
            getDetailsWidgetWithBackColor("""// Index of 0 to 1 : left to right
const DIRECTIONS = [ left, right ];

// Game event translation
const direction = CARDS[Math.floor(float * 2)];""", color: Colors.white),
            const SizedBox(height: AppValues.defaultPadding),
          ],
        )
            .paddingHorizontal(AppValues.defaultPadding)
            .backgroundColor(AppThemes.oddBackColor)
            .clipRRect(all: 4);

      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppValues.defaultPadding),
            CustomText(
              "服务器种子（散列化）",
              style: ThemeService()
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w600),
            ),
            Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff344452), // 边框颜色
                        width: 2.0, // 边框宽度
                        style: BorderStyle.solid, // 边框样式，可以是solid、dotted、dashed等
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child:
                        CustomTextField().tight(height: 40).paddingLeft(AppValues.defaultPadding)),
                CustomButton(
                  alignment: Alignment(0, 0),
                  title: "取消散列",
                  backgroundColor: ThemeService().colorScheme.primaryContainer,
                  textColor: Colors.black,
                  fontWeight: FontWeight.w600,
                ).tight(width: 100, height: 44).clipRRect(topRight: 5, bottomRight: 5).alignRight()
              ],
            ).paddingVertical(AppValues.defaultPadding),
            CustomText(
              "服务器种子",
              style: ThemeService()
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w600),
            ),
            Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff344452), // 边框颜色
                        width: 2.0, // 边框宽度
                        style: BorderStyle.solid, // 边框样式，可以是solid、dotted、dashed等
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: CustomTextField(text: "N/A")
                        .tight(height: 40)
                        .paddingLeft(AppValues.defaultPadding)),
                CustomButton(
                  alignment: Alignment(0, 0),
                  // title: "取消散列",
                  child: Image.asset("assets/images/common/ic_common_copy_gray.webp",
                      width: 22, height: 22),
                  textColor: Colors.black,
                  fontWeight: FontWeight.w600,
                ).tight(width: 30, height: 44).clipRRect(topRight: 5, bottomRight: 5).alignRight()
              ],
            ).paddingVertical(AppValues.defaultPadding)
          ],
        )
            .paddingHorizontal(AppValues.defaultPadding)
            .backgroundColor(AppThemes.oddBackColor)
            .clipRRect(all: 4);
        ;
      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppValues.defaultPadding),
            CustomText(
              "游戏",
              style: ThemeService()
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w600),
            ),
            Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff344452), // 边框颜色
                        width: 2.0, // 边框宽度
                        style: BorderStyle.solid, // 边框样式，可以是solid、dotted、dashed等
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: CustomTextField(
                      text: 'Plinko',
                    ).tight(height: 40).paddingLeft(AppValues.defaultPadding)),
                CustomButton(
                  alignment: Alignment(0, 0),
                  // title: "取消散列",
                  child: Image.asset("assets/images/bet_slip/ic_casino_down.webp",
                      width: 22, height: 22),
                  textColor: Colors.black,
                  fontWeight: FontWeight.w600,
                ).tight(width: 30, height: 44).clipRRect(topRight: 5, bottomRight: 5).alignRight()
              ],
            ).paddingVertical(AppValues.defaultPadding),
            CustomText(
              "客户端种子",
              style: ThemeService()
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w600),
            ),
            Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff344452), // 边框颜色
                        width: 2.0, // 边框宽度
                        style: BorderStyle.solid, // 边框样式，可以是solid、dotted、dashed等
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: CustomTextField(text: "")
                        .tight(height: 40)
                        .paddingLeft(AppValues.defaultPadding))
                .paddingVertical(AppValues.defaultPadding),
            CustomText(
              "服务器种子",
              style: ThemeService()
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w600),
            ),
            Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff344452), // 边框颜色
                        width: 2.0, // 边框宽度
                        style: BorderStyle.solid, // 边框样式，可以是solid、dotted、dashed等
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: CustomTextField(text: "")
                        .tight(height: 40)
                        .paddingLeft(AppValues.defaultPadding))
                .paddingVertical(AppValues.defaultPadding),
            CustomText(
              "现时标志",
              style: ThemeService()
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w600),
            ),
            Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff344452), // 边框颜色
                        width: 2.0, // 边框宽度
                        style: BorderStyle.solid, // 边框样式，可以是solid、dotted、dashed等
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: CustomTextField(
                      text: '0',
                    ).tight(height: 40).paddingLeft(AppValues.defaultPadding)),
                [
                  CustomButton(
                    alignment: Alignment(0, 0),
                    // title: "取消散列",
                    child: Image.asset("assets/images/bet_slip/ic_casino_down_up.webp",
                        width: 22, height: 22),
                    textColor: Colors.black,
                    fontWeight: FontWeight.w600,
                  ).tight(width: 44, height: 44).clipRRect(topRight: 5, bottomRight: 5),
                  CustomButton(
                    alignment: Alignment(0, 0),
                    // title: "取消散列",
                    child: Image.asset("assets/images/bet_slip/ic_casino_down.webp",
                        width: 22, height: 22),
                    textColor: Colors.black,
                    fontWeight: FontWeight.w600,
                  ).tight(width: 44, height: 44).clipRRect(topRight: 5, bottomRight: 5),
                ].toRow(mainAxisAlignment: MainAxisAlignment.end).width(100).alignRight()
              ],
            ).paddingVertical(AppValues.defaultPadding),
            CustomText(
              "风险",
              style: ThemeService()
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w600),
            ),
            Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff344452), // 边框颜色
                        width: 2.0, // 边框宽度
                        style: BorderStyle.solid, // 边框样式，可以是solid、dotted、dashed等
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: CustomTextField(
                      text: '低等',
                    ).tight(height: 40).paddingLeft(AppValues.defaultPadding)),
                CustomButton(
                  alignment: Alignment(0, 0),
                  // title: "取消散列",
                  child: Image.asset("assets/images/bet_slip/ic_casino_down.webp",
                      width: 22, height: 22),
                  textColor: Colors.black,
                  fontWeight: FontWeight.w600,
                ).tight(width: 30, height: 44).clipRRect(topRight: 5, bottomRight: 5).alignRight()
              ],
            ).paddingVertical(AppValues.defaultPadding),
            CustomText(
              "排数",
              style: ThemeService()
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Color(0xffb1bad3), fontWeight: FontWeight.w600),
            ),
            Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff344452), // 边框颜色
                        width: 2.0, // 边框宽度
                        style: BorderStyle.solid, // 边框样式，可以是solid、dotted、dashed等
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: CustomTextField(
                      text: '16',
                    ).tight(height: 40).paddingLeft(AppValues.defaultPadding)),
                CustomButton(
                  alignment: Alignment(0, 0),
                  // title: "取消散列",
                  child: Image.asset("assets/images/bet_slip/ic_casino_down.webp",
                      width: 22, height: 22),
                  textColor: Colors.black,
                  fontWeight: FontWeight.w600,
                ).tight(width: 30, height: 44).clipRRect(topRight: 5, bottomRight: 5).alignRight()
              ],
            ).paddingVertical(AppValues.defaultPadding),
          ],
        )
            .paddingHorizontal(AppValues.defaultPadding)
            .backgroundColor(AppThemes.oddBackColor)
            .clipRRect(all: 4);

      default:
        return Column(
          children: [],
        );
    }
  }

  Widget getTitleWidget(text) {
    return Container(
      child: Text(
        text,
        style: ThemeService().textTheme.titleLarge,
      ),
    );
  }

  Widget getDetailsWidget(text) {
    return CustomText(
      text,
      textAlign: TextAlign.start,
      style: ThemeService().textTheme.titleMedium!.copyWith(
          fontSize: AppValues.fontTileSmallSize,
          fontWeight: FontWeight.w600,
          color: Color(0xffb1bad3)),
    );
  }

  Widget getDetailsWidgetWithBackColor(text, {Color color = const Color(0xffb1bad3)}) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff213743), borderRadius: BorderRadius.all(Radius.circular(5))),
      child: CustomText(
        text,
        textAlign: TextAlign.start,
        style: ThemeService()
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.w400, color: color ?? Color(0xffb1bad3)),
      ).paddingAll(AppValues.defaultPadding),
    );
  }
}
