import 'package:get/get.dart';

import '../../pages/front/front_binding.dart';
import '../../pages/front/front_view.dart';
import '../modules/FiatPaymentDetails/bindings/fiat_payment_details_binding.dart';
import '../modules/FiatPaymentDetails/views/fiat_payment_details_view.dart';
import '../modules/binding_bank_card/bindings/binding_bank_card_binding.dart';
import '../modules/binding_bank_card/views/binding_bank_card_view.dart';
import '../modules/binding_pix/bindings/binding_pix_binding.dart';
import '../modules/binding_pix/views/binding_pix_view.dart';
import '../modules/binding_virtual_address/bindings/binding_virtual_address_binding.dart';
import '../modules/binding_virtual_address/views/binding_virtual_address_view.dart';
import '../modules/commission_conversion/bindings/commission_conversion_binding.dart';
import '../modules/commission_conversion/views/commission_conversion_view.dart';
import '../modules/commission_deposit_withdrawal/bindings/commission_deposit_withdrawal_binding.dart';
import '../modules/commission_deposit_withdrawal/views/commission_deposit_withdrawal_view.dart';
import '../modules/commission_wallet/bindings/commission_wallet_binding.dart';
import '../modules/commission_wallet/views/commission_wallet_view.dart';
import '../modules/csHome/bindings/cs_home_binding.dart';
import '../modules/csHome/views/cs_home_view.dart';
import '../modules/redPacket/bindings/red_packet_binding.dart';
import '../modules/redPacket/views/red_packet_view.dart';
import '../modules/restricted/bindings/restricted_binding.dart';
import '../modules/restricted/views/restricted_view.dart';
import '../modules/rotary/bindings/rotary_binding.dart';
import '../modules/rotary/views/rotary_view.dart';
import '../modules/start/bindings/start_binding.dart';
import '../modules/start/views/start_view.dart';
import '../modules/statistical_data/bindings/statistical_data_binding.dart';
import '../modules/statistical_data/views/statistical_data_view.dart';
import '../modules/vault/bindings/vault_binding.dart';
import '../modules/vault/views/vault_view.dart';
import '../modules/vaultDescriptions/bindings/vault_descriptions_binding.dart';
import '../modules/vaultDescriptions/views/vault_descriptions_view.dart';
import '../modules/virtual_payment_details/bindings/virtual_payment_details_binding.dart';
import '../modules/virtual_payment_details/views/virtual_payment_details_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.START,
      page: () => const StartView(),
      binding: StartBinding(),
    ),
    GetPage(
      name: _Paths.FRONT,
      page: () => FrontPage(),
      binding: FrontBinding(),
    ),
    GetPage(
      name: _Paths.WALLET,
      page: () => WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.BINDING_BANK_CARD,
      page: () => const BindingBankCardView(),
      binding: BindingBankCardBinding(),
    ),
    GetPage(
      name: _Paths.BINDING_PIX,
      page: () => const BindingPixView(),
      binding: BindingPixBinding(),
    ),
    GetPage(
      name: _Paths.BINDING_VIRTUAL_ADDRESS,
      page: () => const BindingVirtualAddressView(),
      binding: BindingVirtualAddressBinding(),
    ),
    GetPage(
      name: _Paths.VAULT,
      page: () => const VaultView(),
      binding: VaultBinding(),
    ),
    GetPage(
      name: _Paths.FIAT_PAYMENT_DETAILS,
      page: () => const FiatPaymentDetailsView(),
      binding: FiatPaymentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.VIRTUAL_PAYMENT_DETAILS,
      page: () => const VirtualPaymentDetailsView(),
      binding: VirtualPaymentDetailsBinding(),
    ),
    GetPage(
      name: _Paths.COMMISSION_WALLET,
      page: () => const CommissionWalletView(),
      binding: CommissionWalletBinding(),
    ),
    GetPage(
      name: _Paths.COMMISSION_CONVERSION,
      page: () => CommissionConversionView(),
      binding: CommissionConversionBinding(),
    ),
    GetPage(
      name: _Paths.COMMISSION_DEPOSIT_WITHDRAWAL,
      page: () => const CommissionDepositWithdrawalView(),
      binding: CommissionDepositWithdrawalBinding(),
    ),
    GetPage(
      name: _Paths.STATISTICAL_DATA,
      page: () => const StatisticalDataView(),
      binding: StatisticalDataBinding(),
    ),
    GetPage(
      name: _Paths.RESTRICTED,
      page: () => const RestrictedView(),
      binding: RestrictedBinding(),
    ),
    GetPage(
      name: _Paths.VAULT_DESCRIPTIONS,
      page: () => VaultDescriptionsView(),
      binding: VaultDescriptionsBinding(),
    ),
    GetPage(
      name: _Paths.ROTARY,
      page: () => const RotaryView(),
      binding: RotaryBinding(),
    ),
    GetPage(
      name: _Paths.CS_HOME,
      page: () =>  CsHomeView(),
      binding: CsHomeBinding(),
    ),
    GetPage(
      name: _Paths.RED_PACKET,
      page: () => const RedPacketView(),
      binding: RedPacketBinding(),
    ),
  ];
}
