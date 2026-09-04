import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

enum SubscriptionPlan { free, plus, family, school }
enum SubscriptionStatus { active, expired, cancelled }

extension SubscriptionPlanExtension on SubscriptionPlan {
  int get defaultLimit {
    switch (this) {
      case SubscriptionPlan.free:
        return 3;
      case SubscriptionPlan.plus:
        return 50;
      case SubscriptionPlan.family:
        return 100;
      case SubscriptionPlan.school:
        return 500;
    }
  }
}

@JsonSerializable()
class Subscription {
  final String id;
  final String userId;
  final SubscriptionPlan plan;
  final int generationLimit;
  final int generationsUsed;
  final DateTime periodStart;
  final DateTime periodEnd;
  final SubscriptionStatus status;

  const Subscription({
    required this.id,
    required this.userId,
    required this.plan,
    required this.generationLimit,
    required this.generationsUsed,
    required this.periodStart,
    required this.periodEnd,
    required this.status,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);
}
