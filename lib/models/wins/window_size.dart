class WindowSize {
  final double height;
  final double width;
  final bool maximized;

  WindowSize({
    required this.height,
    required this.width,
    required this.maximized,
  });

  factory WindowSize.fromJson(Map<String, dynamic> json) => WindowSize(
        height: json["height"],
        width: json["width"],
        maximized: json["maximized"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
        "maximized": maximized,
      };
}
