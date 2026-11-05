part of '../main.dart';

class IOSButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final bool isLarge;
  
  const IOSButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
    this.isLarge = false,
  });
  
  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    
    if (isDestructive) {
      backgroundColor = AppTheme.destructiveColor;
      textColor = Colors.white;
    } else if (isPrimary) {
      backgroundColor = AppTheme.primaryColor;
      textColor = Colors.white;
    } else {
      backgroundColor = AppTheme.cardColor;
      textColor = AppTheme.primaryColor;
    }
    
    return Container(
      width: isLarge ? double.infinity : null,
      height: isLarge ? 56 : 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: !isPrimary && !isDestructive 
            ? Border.all(color: AppTheme.primaryColor, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class IOSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  
  const IOSCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: AppTheme.spacing),
      padding: padding ?? const EdgeInsets.all(AppTheme.spacing),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class IOSTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool autofocus;
  
  const IOSTextField({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.autofocus = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        style: AppTheme.bodyTextStyle,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.captionTextStyle,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppTheme.spacing),
        ),
      ),
    );
  }
}
