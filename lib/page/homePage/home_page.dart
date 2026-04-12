import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/homePage/bloc/orders_count_cubit.dart';
import 'package:restaukitchen_app/page/homePage/bloc/table_count_cubit.dart';
import 'package:restaukitchen_app/page/homePage/components/table_qr_code_dialog.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Action Buttons
            _buildActionButton(
              context,
              title: 'Genera codice QR',
              icon: Icons.qr_code,
              color: LightTheme.primaryColor,
              textColor: Colors.white,
              onTap: () {
                // Handle QR code generation
                TableQrCodeDialog.show(context);
              },
            ),
            const SizedBox(height: 24),
            // Tavoli Card
            _buildTavoliCard(context),
            const SizedBox(height: 16),
            // Ordine Card
            Row(children: [
              
              ],
            ),
            _buildOrdineCard(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 28),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTavoliCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: const TablesCountWidget(),
      ),
    );
  }

  Widget _buildOrdineCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: const OrderCountWidget(),
      ),
    );
  }
}

// Tables Count Widget (Free and Occupied)
class TablesCountWidget extends StatefulWidget {
  const TablesCountWidget({super.key});

  @override
  State<TablesCountWidget> createState() => _TablesCountWidgetState();
}

class _TablesCountWidgetState extends State<TablesCountWidget> {
  @override
  void initState() {
    super.initState();
    context.read<TableCountCubit>().getTableCount();
  }

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFF212121);
    const subtitleColor = Color(0xFF757575);
    const freeGreen = Color(0xFF4CAF50);

    return BlocBuilder<TableCountCubit, TableCountState>(
      builder: (context, state) {
        final freeCount = state.tableCount?.freeTable ?? 0;
        final occupiedCount = state.tableCount?.occupiedTable ?? 0;
        final totalTables =
            state.tableCount?.totalTables ?? (freeCount + occupiedCount);
        final isLoading = state.status == TableCountStatus.loading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Disponibilità tavoli',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                Text(
                  isLoading ? '…' : '$totalTables tavoli totali',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 128,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _TableAvailabilityStatCard(
                      indicatorColor: freeGreen,
                      label: 'LIBERI',
                      count: freeCount,
                      numberColor: titleColor,
                      isLoading: isLoading,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TableAvailabilityStatCard(
                      indicatorColor: Colors.red,
                      label: 'OCCUPATI',
                      count: occupiedCount,
                      numberColor: Colors.red,
                      isLoading: isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TableAvailabilityStatCard extends StatelessWidget {
  const _TableAvailabilityStatCard({
    required this.indicatorColor,
    required this.label,
    required this.count,
    required this.numberColor,
    required this.isLoading,
  });

  final Color indicatorColor;
  final String label;
  final int count;
  final Color numberColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
      color: Color(0xFF757575),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(label, style: labelStyle),
            ],
          ),
          Expanded(
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: indicatorColor,
                      ),
                    )
                  : Text(
                      count.toString().padLeft(1, '0'),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: numberColor,
                        height: 1,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Order Count Widget
class OrderCountWidget extends StatefulWidget {
  const OrderCountWidget({super.key});

  @override
  State<OrderCountWidget> createState() => _OrderCountWidgetState();
}

class _OrderCountWidgetState extends State<OrderCountWidget> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCountCubit>().getOrdersCount();
  }

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFF212121);
    const subtitleColor = Color(0xFF757575);

    return BlocBuilder<OrdersCountCubit, OrdersCountState>(
      builder: (context, state) {
        final ordersCount = state.ordersCount ?? 0;
        final isLoading = state.status == OrdersCountStatus.loading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Ordini',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                Text(
                  isLoading ? '…' : '$ordersCount ordini aperti',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 128,
              child: _TableAvailabilityStatCard(
                indicatorColor: Colors.red,
                label: 'APERTI',
                count: ordersCount,
                numberColor: Colors.red,
                isLoading: isLoading,
              ),
            ),
          ],
        );
      },
    );
  }
}
