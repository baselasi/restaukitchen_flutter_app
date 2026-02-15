import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';

class OrdersListRepo {
  final ApiService _apiService;

  http.Client? _sseClient;
  StreamController<List<Order>>? _ordersController;

  OrdersListRepo({required ApiService apiService}) : _apiService = apiService;

  /// Opens an SSE connection and returns a broadcast stream of order lists.
  ///
  /// Each SSE event is expected to carry a JSON array of orders in its
  /// `data:` field. The stream will keep emitting updates until [close] is
  /// called or the server closes the connection.
  Stream<List<Order>> getOrdersStream() {
    _ordersController = StreamController<List<Order>>.broadcast(
      onCancel: close,
    );

    _connect();

    return _ordersController!.stream;
  }

  Future<void> _connect() async {
    try {
      final (:stream, :client) = await _apiService.connectToSSE(
        '/api/order',
      );
      _sseClient = client;

      String buffer = '';

      await for (final chunk in stream) {
        // Guard against emitting after close.
        if (_ordersController == null || _ordersController!.isClosed) break;

        print('[SSE] Raw chunk: $chunk');
        buffer += chunk;

        // SSE events are delimited by a blank line (\n\n).
        while (buffer.contains('\n\n')) {
          final eventEnd = buffer.indexOf('\n\n');
          final rawEvent = buffer.substring(0, eventEnd);
          buffer = buffer.substring(eventEnd + 2);

          final data = _parseEventData(rawEvent);
          if (data == null || data.isEmpty) continue;

          print('[SSE] Parsed event data: $data');

          try {
            final decoded = jsonDecode(data);

            if (decoded is List) {
              final orders = decoded
                  .map(
                    (json) => Order.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
              print('[SSE] Emitting ${orders.length} orders');
              _ordersController?.add(orders);
            }
          } on FormatException catch (e) {
            print('[SSE] JSON parse error: $e');
          }
        }
      }
    } catch (e) {
      _ordersController?.addError(e);
    }
  }

  /// Extracts the concatenated `data:` field values from a single SSE event
  /// block. Multiple `data:` lines within the same event are joined with
  /// newlines, following the SSE specification.
  String? _parseEventData(String rawEvent) {
    final lines = rawEvent.split('\n');
    final dataLines = <String>[];

    for (final line in lines) {
      if (line.startsWith('data:')) {
        dataLines.add(line.substring(5).trim());
      }
    }

    return dataLines.isEmpty ? null : dataLines.join('\n');
  }

  /// Closes the SSE connection and releases resources.
  void close() {
    _sseClient?.close();
    _sseClient = null;

    if (_ordersController != null && !_ordersController!.isClosed) {
      _ordersController!.close();
    }
    _ordersController = null;
  }
}
