import 'package:json_annotation/json_annotation.dart';

import 'subscription_interval.dart';
import 'subscription_status.dart';

class SubscriptionStatusConverter
    extends JsonConverter<SubscriptionStatus, String> {
  const SubscriptionStatusConverter();

  @override
  SubscriptionStatus fromJson(String json) {
    return SubscriptionStatusX.fromJson(json);
  }

  @override
  String toJson(SubscriptionStatus object) {
    return object.toJson();
  }
}

class SubscriptionIntervalConverter
    extends JsonConverter<SubscriptionInterval, String> {
  const SubscriptionIntervalConverter();

  @override
  SubscriptionInterval fromJson(String json) {
    return SubscriptionIntervalX.fromJson(json);
  }

  @override
  String toJson(SubscriptionInterval object) {
    return object.toJson();
  }
}

