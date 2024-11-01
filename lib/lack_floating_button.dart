import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lack_off_debug_logs/lack_off.dart';

///
/// 悬浮按钮
///
class LackFloatingButton {
  static OverlayEntry? overlayEntry;
  static Offset position = Offset.zero; // 添加初始位置
  static bool openLogWindow = false;
  static show(BuildContext context) {
    final overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      maintainState: true,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        final height = size.height;
        final width = size.width;
        return Stack(
          children: [
            Visibility(
              visible: openLogWindow,
              child: Container(
                height: height,
                width: width,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  border: Border.fromBorderSide(
                    BorderSide(color: Colors.orangeAccent, width: 16),
                  ),
                ),
                child: StreamBuilder<List<Map>>(
                  stream: LackOff.logStream,
                  initialData: LackOff.getLogs(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('暂无日志'));
                    }
                    final logs = snapshot.data!;
                    return ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final map = logs[index];

                        return Card(
                          color: map['type'] == '1'
                              ? Colors.orange.withOpacity(0.5)
                              : (map['type'] == '2'
                                  ? Colors.red.withOpacity(0.5)
                                  : Colors.lightBlueAccent.withOpacity(0.5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 2,
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          '${map['date']}\n${map['message']}\n${map['stack']}'));
                                },
                                icon: const Icon(Icons.copy),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              SelectableText(
                                map['date'],
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              SelectableText(
                                map['message'],
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              SelectableText(map['stack']),
                              const SizedBox(
                                height: 2,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: position.dy + 20,
              right: position.dx + 20,
              child: GestureDetector(
                onPanUpdate: (details) {
                  // 更新位置
                  final dx = position.dx - details.delta.dx;
                  final dy = position.dy - details.delta.dy;
                  debugPrint('dx:$dx,dy:$dy   width:$width,height:$height');
                  if (dx > 0 &&
                      dy > 0 &&
                      dx < (width - 70) &&
                      dy < (height - 100)) {
                    position = Offset(dx, dy);
                    refresh(); // 重新构建OverlayEntry
                  }
                },
                child: Card(
                  color: Colors.white60,
                  child: InkWell(
                    onTap: () {
                      openLogWindow = !openLogWindow;
                      refresh();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(
                        Icons.bug_report_outlined,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlayState.insert(overlayEntry!);
  }

  static remove() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
    }
  }

  static refresh() {
    overlayEntry?.markNeedsBuild();
  }
}
