import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final List<String> countryOptions;
  final void Function(String) onSelected;
  final void Function(String) onSearch;
  final TextEditingController? controller;

  const CustomSearchBar({
    super.key,
    required this.countryOptions,
    required this.onSelected,
    required this.onSearch,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        // Return the filtered options based on the input text
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        
        // Filter the options locally for the Autocomplete widget
        return countryOptions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: onSelected,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        final effectiveController = controller ?? textEditingController;

        return TextField(
          controller: effectiveController,
          focusNode: focusNode,
          onChanged: onSearch, // This will call the external filter
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: 'Search countries',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          textInputAction: TextInputAction.search,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        if (options.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}