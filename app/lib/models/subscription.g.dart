// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      plan: $enumDecode(_$SubscriptionPlanEnumMap, json['plan']),
      generationLimit: (json['generationLimit'] as num).toInt(),
      generationsUsed: (json['generationsUsed'] as num).toInt(),
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'plan': _$SubscriptionPlanEnumMap[instance.plan]!,
      'generationLimit': instance.generationLimit,
      'generationsUsed': instance.generationsUsed,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
    };

const _$SubscriptionPlanEnumMap = {
  SubscriptionPlan.free: 'free',
  SubscriptionPlan.plus: 'plus',
  SubscriptionPlan.family: 'family',
  SubscriptionPlan.school: 'school',
};

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.expired: 'expired',
  SubscriptionStatus.cancelled: 'cancelled',
};
