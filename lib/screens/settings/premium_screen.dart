import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/purchase_service.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  StoreProduct? _product;
  bool _loadingProduct = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProduct());
  }

  Future<void> _loadProduct() async {
    final service = context.read<PurchaseService>();
    final product = await service.loadProduct();
    if (!mounted) return;
    setState(() {
      _product = product;
      _loadingProduct = false;
    });
  }

  Future<void> _buy(AppLocalizations l10n) async {
    setState(() => _busy = true);
    final outcome = await context.read<PurchaseService>().buyPremium();
    if (!mounted) return;
    setState(() => _busy = false);
    final message = switch (outcome) {
      PurchaseOutcome.success => null,
      PurchaseOutcome.canceled => l10n.premiumPurchaseCanceled,
      PurchaseOutcome.pending => l10n.premiumPurchaseCanceled,
      PurchaseOutcome.error => l10n.premiumPurchaseError,
    };
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _restore(AppLocalizations l10n) async {
    setState(() => _busy = true);
    await context.read<PurchaseService>().restorePurchases();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.premiumRestoreDone)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final purchaseService = context.watch<PurchaseService>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), tooltip: l10n.commonBack, onPressed: () => context.pop()),
        title: Text(l10n.premiumTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(Icons.workspace_premium, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 12),
          Text(l10n.premiumHeadline, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(l10n.premiumDescription, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          _FeatureRow(icon: Icons.palette_outlined, text: l10n.premiumFeatureColors),
          _FeatureRow(icon: Icons.badge_outlined, text: l10n.premiumFeatureCover),
          _FeatureRow(icon: Icons.favorite_outline, text: l10n.premiumFeatureSupport),
          const SizedBox(height: 8),
          Center(
            child: Wrap(
              spacing: 10,
              children: [
                for (var i = AppAccentColors.freeCount; i < AppAccentColors.values.length; i++)
                  CircleAvatar(radius: 18, backgroundColor: AppAccentColors.of(i)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (purchaseService.isPremium)
            Center(
              child: Text(
                l10n.premiumAlreadyOwned,
                style: theme.textTheme.titleMedium?.copyWith(color: successColor),
                textAlign: TextAlign.center,
              ),
            )
          else if (!purchaseService.storeAvailable)
            Center(
              child: Text(
                l10n.premiumStoreUnavailable,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _busy ? null : () => _buy(l10n),
                child: _busy
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_loadingProduct ? l10n.premiumBuyButton : '${l10n.premiumBuyButton} · ${_product?.price ?? l10n.premiumPriceUnknown}'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _busy ? null : () => _restore(l10n),
                child: Text(l10n.premiumRestoreButton),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
