import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jeeb_admin/core/presentation/theme/colors_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/styles_manager.dart';
import 'package:jeeb_admin/core/presentation/theme/font_manager.dart';
import 'package:jeeb_admin/core/presentation/widgets/text_widget.dart';
import 'package:jeeb_admin/core/presentation/localization/app_translation.dart';
import 'package:jeeb_admin/core/presentation/theme/values_manager.dart';
import 'package:jeeb_admin/core/presentation/routes/routes.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/bloc/list_product_bloc.dart';
import 'package:jeeb_admin/features/product/list_product/presentation/widgets/product_list_item.dart';
import 'package:jeeb_admin/features/product/list_product/domain/entities/product_entity.dart';

class ListProductPage extends StatelessWidget {
  const ListProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        backgroundColor: ColorManager.background,
        title: CustomText(
          text: AppTranslation.products,
          textStyle: getBoldStyle(
            fontSize: AppFontSize.s24,
            color: ColorManager.titlesColor,
          ),
        ),
      ),
      body: BlocBuilder<ListProductBloc, ListProductState>(
        builder: (context, state) {
          if (state is ListProductLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorManager.primary,
              ),
            );
          }

          if (state is ListProductError) {    final mockProducts = [
              ProductEntity(
                id: '1',
                name: 'Burger Deluxe',
                description: 'Delicious burger with special sauce and fresh vegetables',
                price: 25.99,
                categoryId: '1',
                categoryName: 'Fast Food',
                quantity: 50,
                images: ['https://via.placeholder.com/300'],
                rating: 4.5,
              ),
              ProductEntity(
                id: '2',
                name: 'Pizza Margherita',
                description: 'Classic Italian pizza with fresh mozzarella and basil',
                price: 35.50,
                categoryId: '1',
                categoryName: 'Fast Food',
                quantity: 30,
                images: ['https://via.placeholder.com/300'],
                rating: 4.8,
              ),
            ];

            // Always use mock data for now (for testing)
            return ListView.builder(
              padding: EdgeInsets.all(AppPadding.p16),
              itemCount: mockProducts.length,
              itemBuilder: (context, index) {
                final product = mockProducts[index];
                return ProductListItem(product: product);
              },
            );
          
          
            // return Center(
            //   child: CustomText(
            //     text: state.message,
            //     textStyle: getRegularStyle(
            //       fontSize: AppFontSize.s16,
            //       color: ColorManager.error,
            //     ),
            //   ),
            // );
          }

          if (state is ListProductLoaded) {
            // Use mock data for testing - 2 products
            final mockProducts = [
              ProductEntity(
                id: '1',
                name: 'Burger Deluxe',
                description: 'Delicious burger with special sauce and fresh vegetables',
                price: 25.99,
                categoryId: '1',
                categoryName: 'Fast Food',
                quantity: 50,
                images: ['https://via.placeholder.com/300'],
                rating: 4.5,
              ),
              ProductEntity(
                id: '2',
                name: 'Pizza Margherita',
                description: 'Classic Italian pizza with fresh mozzarella and basil',
                price: 35.50,
                categoryId: '1',
                categoryName: 'Fast Food',
                quantity: 30,
                images: ['https://via.placeholder.com/300'],
                rating: 4.8,
              ),
            ];

            // Always use mock data for now (for testing)
            return ListView.builder(
              padding: EdgeInsets.all(AppPadding.p16),
              itemCount: mockProducts.length,
              itemBuilder: (context, index) {
                final product = mockProducts[index];
                return ProductListItem(product: product);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primary,
        onPressed: () {
          Navigator.pushNamed(context, Routes.addProduct);
        },
        child: Icon(Icons.add, color: ColorManager.surface),
      ),
    );
  }
}

