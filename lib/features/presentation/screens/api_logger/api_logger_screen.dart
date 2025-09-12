import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/services.dart';

class ApiLoggerScreen extends StatefulWidget {
  const ApiLoggerScreen({super.key});

  @override
  State<ApiLoggerScreen> createState() => _ApiLoggerScreenState();
}

class _ApiLoggerScreenState extends State<ApiLoggerScreen> {
  final box = GetStorage();
  List<dynamic> logs = [];

  @override
  void initState() {
    super.initState();
    loadLogs();
  }

  void loadLogs() {
    setState(() {
      logs = box.read<List>('api_logs') ?? [];
    });
  }

  void clearLogs() {
    box.write('api_logs', []);
    loadLogs();
  }

  IconData _getIcon(String title) {
    if (title.contains('REQUEST')) return Icons.send;
    if (title.contains('RESPONSE')) return Icons.check_circle;
    if (title.contains('ERROR')) return Icons.error;
    return Icons.info;
  }

  Color _getColor(String title) {
    if (title.contains('REQUEST')) return Colors.blue.shade600;
    if (title.contains('RESPONSE')) return Colors.green.shade600;
    if (title.contains('ERROR')) return Colors.red.shade600;
    return Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Logs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadLogs,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: logs.isEmpty
          ? const Center(child: Text('No API logs found.'))
          : ListView.separated(
              itemCount: logs.length,
              separatorBuilder: (_, __) => Divider(height: 0),
              itemBuilder: (context, index) {
                final log = logs[index];
                final title = log['title'] ?? '';
                final time = log['time'] ?? '';
                final data = log['data'] ?? '';

                return ExpansionTile(
                  leading: Icon(_getIcon(title), color: _getColor(title)),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: _getColor(title),
                    ),
                  ),
                  subtitle: Text(time),
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            data,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: data));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Copied to clipboard')),
                                );
                              },
                              icon: const Icon(Icons.copy, size: 18),
                              label: const Text('Copy'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: clearLogs,
        icon: const Icon(Icons.delete_forever),
        label: const Text('Clear Logs'),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }
}
