part of 'stats_bloc.dart';

@immutable
abstract class StatsEvent {
  const StatsEvent();
}
class StatsSubscriptionRequested  extends StatsEvent {
  const StatsSubscriptionRequested();
}

