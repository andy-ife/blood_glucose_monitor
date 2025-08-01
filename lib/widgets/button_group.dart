import 'package:blood_glucose_monitor/theme/styles.dart';
import 'package:flutter/material.dart';

class BGMButtonGroup extends StatefulWidget {
  const BGMButtonGroup({
    required this.values,
    required this.onSelectionChange,
    this.floating = false,
    this.scrollable = true,
    this.enableMultiSelection = true,
    this.initialSelection,
    super.key,
  });

  final List<String> values;
  final Function(Set<String>) onSelectionChange;
  final bool floating;
  final bool scrollable;
  final bool enableMultiSelection;
  final Set<String>? initialSelection;

  @override
  State<BGMButtonGroup> createState() => _BGMButtonGroupState();
}

class _BGMButtonGroupState extends State<BGMButtonGroup> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection ?? {};
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.scrollable) {
      return SizedBox(
        height: 40.0,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: widget.values.length,
          itemBuilder: (context, i) {
            final String curr = widget.values[i];
            if (_selected.contains(curr)) {
              return TextButton(
                onPressed: () {
                  setState(() {
                    _selected.remove(curr);
                    print(_selected);
                    if (_selected.isEmpty) {
                      _selected.add(
                        widget.initialSelection?.first ?? widget.values.first,
                      );
                    }
                  });

                  widget.onSelectionChange(_selected);
                },
                style: !widget.floating
                    ? AppButtonStylesLight.filled.copyWith(
                        textStyle: WidgetStateProperty.all(
                          theme.textTheme.titleMedium!.copyWith(
                            inherit: true,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : AppButtonStylesLight.floating.copyWith(
                        backgroundColor: WidgetStateProperty.all(
                          theme.colorScheme.primary,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                child: Row(
                  children: [
                    Text(curr),
                    SizedBox(width: 12.0),
                    Icon(Icons.close),
                  ],
                ),
              );
            }
            return TextButton(
              onPressed: () {
                if (widget.enableMultiSelection) {
                  setState(() {
                    _selected.add(curr);
                  });
                  widget.onSelectionChange(_selected);
                } else {
                  setState(() {
                    _selected.clear();
                    _selected.add(curr);
                  });
                  widget.onSelectionChange(_selected);
                }
              },
              style: !widget.floating
                  ? AppButtonStylesLight.text
                  : AppButtonStylesLight.floating,
              child: Text(curr),
            );
          },
          separatorBuilder: (context, i) => SizedBox(width: 24.0),
          scrollDirection: Axis.horizontal,
        ),
      );
    } else {
      return Wrap(
        spacing: 16.0,
        children: List.generate(widget.values.length, (i) {
          final String curr = widget.values[i];
          if (_selected.contains(curr)) {
            return TextButton(
              onPressed: () {
                setState(() {
                  _selected.remove(curr);
                });

                widget.onSelectionChange(_selected);
              },
              style: theme.textButtonTheme.style,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(curr),
                  SizedBox(width: 12.0),
                  Icon(Icons.close),
                ],
              ),
            );
          }
          return TextButton(
            onPressed: () {
              if (widget.enableMultiSelection) {
                setState(() {
                  _selected.add(curr);
                });
              } else {
                setState(() {
                  _selected.clear();
                  _selected.add(curr);
                });
              }
              widget.onSelectionChange(_selected);
            },
            child: Text(curr),
          );
        }),
      );
    }
  }
}
