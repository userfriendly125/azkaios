import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/model/transition_model.dart';

import '../repository/transactions_repo.dart';

TransitionRepo transitionRepo = TransitionRepo();
final transitionProvider = FutureProvider.autoDispose<List<SalesTransitionModel>>((ref) => transitionRepo.getAllTransition());

PurchaseTransitionRepo purchaseTransitionRepo = PurchaseTransitionRepo();
final purchaseTransitionProvider = FutureProvider.autoDispose<List<dynamic>>((ref) => purchaseTransitionRepo.getAllTransition());

QuotationRepo quotationRepo = QuotationRepo();
final quotationProvider = FutureProvider.autoDispose<List<SalesTransitionModel>>((ref) => quotationRepo.getAllQuotation());

QuotationHistoryRepo quotationHistoryRepo = QuotationHistoryRepo();
final quotationHistoryProvider = FutureProvider.autoDispose<List<SalesTransitionModel>>((ref) => quotationHistoryRepo.getAllQuotationHistory());
