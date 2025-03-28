import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationBanner extends StatefulWidget {
  final List<String> notifications;
  final VoidCallback onClose;
  final double topOffset;
  final double rightOffset;

  const NotificationBanner({
    super.key,
    required this.notifications,
    required this.onClose,
    this.topOffset = 70,
    this.rightOffset = 20,
  });

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          //color: Colors.grey[850],
          color: const Color.fromARGB(255, 8, 6, 12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(height: 20),
            _buildNotificationList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Text(
            'Уведомления',
            style: GoogleFonts.balsamiqSans(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 8),
          child: IconButton(
            icon: const Icon(
              Icons.close,
              size: 20,
            ),
            onPressed: widget.onClose,
          ),
        )
      ],
    );
  }

  Widget _buildNotificationList() {
    return widget.notifications.isEmpty
        ? const Text('Нет новых уведомлений')
        : Column(
            children: widget.notifications
                .map((notification) => _NotificationItem(
                      text: notification,
                      onTap: () => _handleNotificationTap(notification),
                    ))
                .toList(),
          );
  }

  void _handleNotificationTap(String notification) {
    // Обработка нажатия на уведомление
    log('Нажато уведомление: $notification');
  }
}

class _NotificationItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Icon(
                Icons.notifications_none,
                size: 18,
                color: Colors.lightGreenAccent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.balsamiqSans(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
