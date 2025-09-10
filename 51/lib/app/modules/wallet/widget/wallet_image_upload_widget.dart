import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/upload_image_util.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_rich_title_widget.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';

import '../../../../utils/CommonRipple.dart';

class WalletImageUploadWidget extends StatefulWidget {
  final String title;
  final bool required;
  final String imageUrl;
  final ValueChanged<String>? onChanged;

  const WalletImageUploadWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    this.required = false,
    this.onChanged,
  });

  @override
  State<WalletImageUploadWidget> createState() =>
      _WalletImageUploadWidgetState();
}

class _WalletImageUploadWidgetState extends State<WalletImageUploadWidget> {
  bool _isLoading = false; // 新增状态变量
  // String networkImage = ''; // 图片链接
  // @override
  // void didUpdateWidget(WalletImageUploadWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   // 检查 defaultContent 是否变化
  //   if (oldWidget.imageUrl != widget.imageUrl) {
  //     setState(() {
  //       networkImage = widget.imageUrl;
  //     });
  //   }
  // }

  Future<void> _pickImage() async {
    AppManager.instance.tapVibrate();
    if (_isLoading) return; // 如果正在加载，则返回

    setState(() {
      _isLoading = true; // 开始加载
    });

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? selectedImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        UploadImageUtil.onFileChange(
          image: selectedImage,
          callback: (str) {
            print('Upload img url: ${str}');
            if (widget.onChanged != null) {
              widget.onChanged!(str);
            }
          },
        );
      }
    } catch (e) {
      print('Error occurred while picking image: $e');
    } finally {
      setState(() {
        _isLoading = false; // 完成后恢复状态
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      RechargeRichTitleWidget(
        str: widget.title,
        fontSize: 45.sp,
        required: widget.required,
      ),
      Container(
        margin: EdgeInsets.only(top: 27.h, bottom: 40.h),
        child: CommonRipple(
          onTap: _pickImage,
          child: Container(
            width: 248.w,
            height: 248.h,
            decoration: BoxDecoration(
              color: const Color(colorF4F4F4),
              border: Border.all(color: const Color(colorF4F4F4)),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: widget.imageUrl == ''
                ? Center(
                    child: SvgPicture.asset(
                    Assets.theme1.images.recharge.iconPlus,
                    width: 100.w,
                    height: 100.h,
                  ))
                : Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),
        ),
      )
    ]);
  }
}
