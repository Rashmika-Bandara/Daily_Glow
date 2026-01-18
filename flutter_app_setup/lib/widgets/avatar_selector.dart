import 'package:flutter/material.dart';

class AvatarSelector extends StatelessWidget {
  final String selectedAvatar;
  final Function(String) onAvatarSelected;

  const AvatarSelector({
    super.key,
    required this.selectedAvatar,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildAvatarOption(context, 'kid_boy', '👦', 'Kid Boy'),
        _buildAvatarOption(context, 'kid_girl', '👧', 'Kid Girl'),
        _buildAvatarOption(context, 'boy', '🧑', 'Boy'),
        _buildAvatarOption(context, 'girl', '👩', 'Girl'),
        _buildAvatarOption(context, 'elder_man', '👴', 'Elder Man'),
        _buildAvatarOption(context, 'elder_woman', '👵', 'Elder Woman'),
      ],
    );
  }

  Widget _buildAvatarOption(
    BuildContext context,
    String value,
    String emoji,
    String label,
  ) {
    final isSelected = selectedAvatar == value;

    return GestureDetector(
      onTap: () => onAvatarSelected(value),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: isSelected ? 3 : 2,
              ),
              color: isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Colors.grey.shade100,
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to get avatar emoji
String getAvatarEmoji(String avatar) {
  switch (avatar) {
    case 'kid_boy':
      return '👦';
    case 'kid_girl':
      return '👧';
    case 'boy':
      return '🧑';
    case 'girl':
      return '👩';
    case 'elder_man':
      return '👴';
    case 'elder_woman':
      return '👵';
    default:
      return '👤';
  }
}

// Helper widget to display avatar
class AvatarDisplay extends StatelessWidget {
  final String avatar;
  final double size;
  final bool showBorder;

  const AvatarDisplay({
    super.key,
    required this.avatar,
    this.size = 60,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      child: Center(
        child: Text(
          getAvatarEmoji(avatar),
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}
