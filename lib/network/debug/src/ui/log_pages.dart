import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/debug_manager.dart';
import '../core/log_models.dart';

class ComNetworkLogListPage extends StatelessWidget {
  final tabs = const ['All', 'Success', 'Error'];
  const ComNetworkLogListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Debug'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => ComDebugManager.instance.clearLogs(),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<ComNetworkDebug>>(
        valueListenable: ComDebugManager.instance.logsNotifier,
        builder: (context, logs, _) {
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  isScrollable: false,
                  tabAlignment: TabAlignment.center,
                  tabs: [
                    Tab(text: 'All'),
                    Tab(text: 'Success'),
                    Tab(text: 'Error'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildList(context, logs),
                      _buildList(
                          context, logs.where((e) => !e.isError).toList()),
                      _buildList(
                          context, logs.where((e) => e.isError).toList()),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<ComNetworkDebug> logs) {
    return ListView.separated(
      itemCount: logs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final it = logs[i];
        final color = it.isError
            ? Colors.red
            : (it.statusCode >= 200 && it.statusCode < 300
                ? Colors.green
                : Colors.orange);
        final duration = it.durationMs != null ? '${it.durationMs} ms' : '';

        Color durationColor = Colors.green;
        if (it.durationMs != null) {
          if (it.durationMs! >= 3000) {
            durationColor = Colors.red;
          } else if (it.durationMs! >= 1000) {
            durationColor = Colors.orange;
          }
        }

        String displayUrl = it.url;
        try {
          final uri = Uri.parse(it.url);
          displayUrl = uri.path;
          if (uri.query.isNotEmpty) {
            displayUrl += '?${uri.query}';
          }
        } catch (_) {}

        return ListTile(
          title: Row(
            children: [
              Text(it.method, style: TextStyle(color: color)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayUrl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(duration, style: TextStyle(color: durationColor)),
              Text(
                _formatTime(it.timestamp),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ComNetworkLogDetailPage(log: it)),
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}

class ComNetworkLogDetailPage extends StatelessWidget {
  const ComNetworkLogDetailPage({super.key, required this.log});
  final ComNetworkDebug log;

  @override
  Widget build(BuildContext context) {
    const encoder = JsonEncoder.withIndent('  ');
    return Scaffold(
      appBar: AppBar(
        title: Text('${log.method} Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              _copyLog(context, encoder);
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (log.statusCode >= 200 && log.statusCode < 300)
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      log.statusCode.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${log.durationMs ?? 0} ms',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(log.timestamp),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const TabBar(
              isScrollable: false,
              tabAlignment: TabAlignment.center,
              tabs: [Tab(text: 'Request'), Tab(text: 'Response')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      Text(log.url),
                      const SizedBox(height: 8),
                      if ((log.request?.headers ?? {}).isNotEmpty)
                        _buildHeaders(log.request!.headers),
                      const SizedBox(height: 8),
                      _buildBody(encoder, log.request?.body),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      if ((log.response?.headers ?? {}).isNotEmpty)
                        _buildHeaders(log.response!.headers),
                      const SizedBox(height: 8),
                      _buildBody(encoder, log.response?.body),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyLog(BuildContext context, JsonEncoder encoder) {
    final sb = StringBuffer();
    final statusIcon =
        (log.statusCode >= 200 && log.statusCode < 300) ? '✅' : '❌';
    sb.writeln(
        '$statusIcon [HTTP] ${_formatTime(log.timestamp)} Request sent [Duration] ${log.durationMs ?? 0}ms');
    sb.writeln('Request: ${log.statusCode} ${log.method} ${log.url}');

    if (log.request?.headers.isNotEmpty == true) {
      sb.writeln('Headers: ${jsonEncode(log.request?.headers)}');
    }

    try {
      final uri = Uri.parse(log.url);
      if (uri.queryParameters.isNotEmpty) {
        sb.writeln('Query: ${jsonEncode(uri.queryParameters)}');
      }
    } catch (_) {}

    if (log.request?.body != null) {
      sb.writeln('Body: ${_formatBody(encoder, log.request?.body)}');
    }

    if (log.response != null) {
      sb.writeln('Response: ${_formatBody(encoder, log.response?.body)}');
    }

    if (log.error != null) {
      sb.writeln('Error: ${log.error?.errorMessage}');
      if (log.error?.stackTrace != null) {
        sb.writeln('Stack Trace: ${log.error?.stackTrace}');
      }
    }

    Clipboard.setData(ClipboardData(text: sb.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Log copied to clipboard')),
    );
  }
}

Widget _buildHeaders(Map<String, dynamic> headers) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: headers.keys.map((k) => SelectableText(k)).toList(),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: headers.values.map((v) => SelectableText('$v')).toList(),
        ),
      ],
    ),
  );
}

Widget _buildBody(JsonEncoder encoder, dynamic body) {
  String text;
  if (body == null) {
    text = '';
  } else if (body is String) {
    text = body;
  } else if (body is List || body is Map) {
    text = encoder.convert(body);
  } else {
    text = body.toString();
  }
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SelectableText(
      text,
      style: const TextStyle(
        fontFamily: 'monospace',
        fontFamilyFallback: ['sans-serif'],
      ),
    ),
  );
}

String _formatBody(JsonEncoder encoder, dynamic body) {
  if (body == null) return 'null';
  if (body is String) return body;
  try {
    return encoder.convert(body);
  } catch (_) {
    return body.toString();
  }
}

String _formatTime(DateTime time) {
  return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
}
