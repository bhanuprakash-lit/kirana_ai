import 'package:flutter_contacts/flutter_contacts.dart';

class ContactService {
  static Future<Contact?> pickContact() async {
    final status = await FlutterContacts.permissions.request(
      PermissionType.readWrite,
    );
    if (status == PermissionStatus.granted) {
      try {
        final contactId = await FlutterContacts.native.showPicker();
        if (contactId != null) {
          // Fetch full contact details with properties required for the app
          return await FlutterContacts.get(
            contactId,
            properties: {
              ContactProperty.name,
              ContactProperty.phone,
              ContactProperty.email,
            },
          );
        }
      } catch (_) {
        // Fallback or log error
      }
    }
    return null;
  }

  static Future<List<Contact>> getAllContacts() async {
    final status = await FlutterContacts.permissions.request(
      PermissionType.readWrite,
    );
    if (status == PermissionStatus.granted) {
      // Use getAll with properties as shown in the example
      return await FlutterContacts.getAll(
        properties: {
          ContactProperty.name,
          ContactProperty.phone,
        },
      );
    }
    return [];
  }

  static String formatPhone(String phone) {
    // Basic cleanup: remove spaces, dashes, +91 etc.
    var p = phone.replaceAll(RegExp(r'\s+'), '').replaceAll('-', '').replaceAll('(', '').replaceAll(')', '');
    if (p.startsWith('+91')) p = p.substring(3);
    if (p.length > 10) p = p.substring(p.length - 10);
    return p;
  }
}
