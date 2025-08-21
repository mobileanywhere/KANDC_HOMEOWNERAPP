import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
// Replace with your model import (CountryListResponse etc.)

/// Common popup styling
PopupProps<T> getCommonPopupProps<T>(bool isDarkMode, String hint) {
  return PopupProps.bottomSheet(
    showSearchBox: true,
    itemBuilder: (context, item, isSelected) {
      return ListTile(
        title: Text(
          (item as dynamic).name ?? '',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        tileColor: isSelected ? Colors.blue : null,
      );
    },
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDarkMode ? Colors.white : null),
        border: OutlineInputBorder(),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : null),
    ),
  );
}

/// Common dropdown field styling
DropDownDecoratorProps getCommonDropdownDecoratorProps(
    String labelText, bool isDarkMode) {
  return DropDownDecoratorProps(
    dropdownSearchDecoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: isDarkMode ? Colors.white : null),
      border: OutlineInputBorder(),
    ),
  );
}

/// Common dropdownBuilder (selected text appearance)

DropdownSearchBuilder<T> getCommonDropdownBuilder<T>(
    bool isDarkMode,
    String defaultText,
    String Function(T?) labelExtractor,
    ) {
  return (BuildContext context, T? selectedItem) {
    final label = labelExtractor(selectedItem);
    return Text(
      label.isNotEmpty ? label : defaultText,
      style: TextStyle(
        color: isDarkMode ? Colors.white : null,
        fontSize: 14,
      ),
    );
  };
}
