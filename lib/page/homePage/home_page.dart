import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/homePage/bloc/orders_count_cubit.dart';
import 'package:restaukitchen_app/page/homePage/bloc/table_count_cubit.dart';
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
              color: LightTheme.secondaryColor,
              textColor: Colors.grey[800]!,
              onTap: () {
                // Handle QR code generation
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              context,
              title: 'Gestisci menu',
              icon: Icons.restaurant_menu,
              color: LightTheme.primaryColor,
              textColor: Colors.white,
              onTap: () {
                // Handle menu management
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              context,
              title: 'Impostazioni',
              icon: Icons.settings,
              color: Colors.green,
              textColor: Colors.white,
              onTap: () {
                // Handle settings
              },
            ),
            const SizedBox(height: 24),
            // Tavoli Card
            _buildTavoliCard(context),
            const SizedBox(height: 16),
            // Ordine Card
            _buildOrdineCard(context),
            const SizedBox(height: 16),
            // Staff Card
            _buildStaffCard(context),
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: LightTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.table_restaurant,
                    color: LightTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Tavoli',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Tables Count (Free and Occupied)
            const TablesCountWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdineCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: LightTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: LightTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Ordine',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Order Count
            const OrderCountWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Title
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: LightTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people,
                    color: LightTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Staff',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Staff Button
            Material(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  // Handle staff management
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      'Staff',
                      style: TextStyle(
                        color: Colors.purple[700],
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
    return BlocBuilder<TableCountCubit, TableCountState>(
      builder: (context, state) {
        final freeCount = state.tableCount?.freeTable ?? 0;
        final occupiedCount = state.tableCount?.occupiedTable ?? 0;
        final isLoading = state.status == TableCountStatus.loading;

        return Column(
          children: [
            // Free Tables
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Liberi:',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Text(
                      '$freeCount',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Occupied Tables
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Occupati:',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isLoading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Text(
                      '$occupiedCount',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
    return BlocBuilder<OrdersCountCubit, OrdersCountState>(
      builder: (context, state) {
        final ordersCount = state.ordersCount ?? 0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aperti:',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              if (state.status == OrdersCountStatus.loading)
                const CircularProgressIndicator()
              else
                Text(
                  '$ordersCount',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
