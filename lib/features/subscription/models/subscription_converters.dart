import 'package:json_annotation/json_annotation.dart';

import 'access_type.dart';
import 'billing_period.dart';
import 'billing_type.dart';
import 'booking_status.dart';
import 'booking_type.dart';
import 'pass_bundle_status.dart';
import 'plan_category.dart';
import 'seat_type.dart';
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

class PlanCategoryConverter extends JsonConverter<PlanCategory, String> {
  const PlanCategoryConverter();

  @override
  PlanCategory fromJson(String json) {
    return PlanCategoryX.fromJson(json);
  }

  @override
  String toJson(PlanCategory object) {
    return object.toJson();
  }
}

class BillingTypeConverter extends JsonConverter<BillingType, String> {
  const BillingTypeConverter();

  @override
  BillingType fromJson(String json) {
    return BillingTypeX.fromJson(json);
  }

  @override
  String toJson(BillingType object) {
    return object.toJson();
  }
}

class BillingPeriodConverter extends JsonConverter<BillingPeriod?, String?> {
  const BillingPeriodConverter();

  @override
  BillingPeriod? fromJson(String? json) {
    return json != null ? BillingPeriodX.fromJson(json) : null;
  }

  @override
  String? toJson(BillingPeriod? object) {
    return object?.toJson();
  }
}

class AccessTypeConverter extends JsonConverter<AccessType, String> {
  const AccessTypeConverter();

  @override
  AccessType fromJson(String json) {
    return AccessTypeX.fromJson(json);
  }

  @override
  String toJson(AccessType object) {
    return object.toJson();
  }
}

class SeatTypeConverter extends JsonConverter<SeatType?, String?> {
  const SeatTypeConverter();

  @override
  SeatType? fromJson(String? json) {
    return json != null ? SeatTypeX.fromJson(json) : null;
  }

  @override
  String? toJson(SeatType? object) {
    return object?.toJson();
  }
}

class PassBundleStatusConverter
    extends JsonConverter<PassBundleStatus, String> {
  const PassBundleStatusConverter();

  @override
  PassBundleStatus fromJson(String json) {
    return PassBundleStatusX.fromJson(json);
  }

  @override
  String toJson(PassBundleStatus object) {
    return object.toJson();
  }
}

class BookingTypeConverter extends JsonConverter<BookingType, String> {
  const BookingTypeConverter();

  @override
  BookingType fromJson(String json) {
    return BookingTypeX.fromJson(json);
  }

  @override
  String toJson(BookingType object) {
    return object.toJson();
  }
}

class BookingStatusConverter extends JsonConverter<BookingStatus, String> {
  const BookingStatusConverter();

  @override
  BookingStatus fromJson(String json) {
    return BookingStatusX.fromJson(json);
  }

  @override
  String toJson(BookingStatus object) {
    return object.toJson();
  }
}
