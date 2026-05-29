import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:poupix/utils/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class SummaryNotificationService {
  SummaryNotificationService._();
  static final SummaryNotificationService instance =
      SummaryNotificationService._();

  static const _prefKey = 'notificacoesResumoAtivas';
  static const _channelId = 'poupix_resumo';
  static const _notificationId = 1;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (kIsWeb || _initialized) return;

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      'Resumo de despesas',
      description: 'Lembretes com o resumo mensal de despesas pendentes',
      importance: Importance.defaultImportance,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, enabled);

    if (!enabled) {
      await _plugin.cancel(id: _notificationId);
      return;
    }

    await init();
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> updateMonthlySummary({
    required DateTime mesReferencia,
    required double totalPendente,
    required int qtdPendentes,
    required int qtdTotal,
  }) async {
    if (kIsWeb) return;
    if (!await isEnabled()) return;

    await init();

    final mesLabel = DateFormat('MMMM yyyy', 'pt_BR').format(mesReferencia);
    final titulo =
        'Resumo Poupix — ${mesLabel[0].toUpperCase()}${mesLabel.substring(1)}';

    final corpo = qtdPendentes == 0
        ? 'Parabéns! Todas as $qtdTotal despesas do mês estão liquidadas.'
        : 'Você tem $qtdPendentes despesa${qtdPendentes == 1 ? '' : 's'} pendente${qtdPendentes == 1 ? '' : 's'} '
            'totalizando ${currencyFormat.format(totalPendente)}.';

    final agora = tz.TZDateTime.now(tz.local);
    var agendamento = tz.TZDateTime(
      tz.local,
      agora.year,
      agora.month,
      agora.day,
      8,
      30,
    );
    if (agendamento.isBefore(agora)) {
      agendamento = agendamento.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: _notificationId,
      title: titulo,
      body: corpo,
      scheduledDate: agendamento,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Resumo de despesas',
          channelDescription:
              'Lembretes com o resumo mensal de despesas pendentes',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
