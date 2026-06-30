import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/features/merchant/merchant_details/presentation/bloc/merchant_details_bloc.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/widgets/edit_merchant_bloc_layer.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/widgets/edit_merchant_scaffold.dart';
import 'package:jeeb_admin/features/merchant/update_merchant/presentation/widgets/merchant_form_page_body.dart';

class EditMerchantPage extends StatefulWidget {
  final bool fromEdit;
  final String? merchantId;

  const EditMerchantPage({
    super.key,
    this.fromEdit = true,
    this.merchantId,
  });

  @override
  State<EditMerchantPage> createState() => _EditMerchantPageState();
}

class _EditMerchantPageState extends State<EditMerchantPage> {
  bool get _isEditMode => widget.fromEdit;

  @override
  void initState() {
    super.initState();
    if (_isEditMode && widget.merchantId != null) {
      context.read<MerchantDetailsBloc>().add(
            GetMerchantDetailsEvent(id: widget.merchantId!),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return EditMerchantBlocLayer(
      fromEdit: _isEditMode,
      builder: (context, isLoading) => EditMerchantScaffold(
        isLoading: isLoading,
        fromEdit: _isEditMode,
        merchantId: widget.merchantId,
        formBuilder: _isEditMode
            ? (loaded) => MerchantFormPageBody(
                  isEditMode: true,
                  merchantId: widget.merchantId,
                  merchantDetails: loaded,
                )
            : null,
        formContent: _isEditMode
            ? null
            : MerchantFormPageBody(
                isEditMode: false,
                merchantId: widget.merchantId,
              ),
      ),
    );
  }
}
