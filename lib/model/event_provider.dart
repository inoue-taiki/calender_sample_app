import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calender_app/view/event_add_screen.dart';

//予定データの管理に使用するProviderを定義
//eventsProviderという名前でStateNotifierProviderを作成
final eventsProvider = StateNotifierProvider((ref) => EventsNotifier());

//EventsNotifierというStateNotifierを定義
//EventsNotifierは予定リストを管理するもの
class EventsNotifier extends StateNotifier<List<String>> {
  EventsNotifier() : super([]);

  //イベントの追加
  void addEvent(String event) {
    state = [...state, event];
  }
  //イベントを保存
  void saveEvent(String event) {
    addEvent(event);
  }
}