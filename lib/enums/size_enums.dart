enum SizeEnum {
  small,

  normal,

  large,
}

extension ButtonPaddingSize on SizeEnum {
  double get paddingLeft {
    switch (this) {
      case SizeEnum.small:
        return 8;
      case SizeEnum.normal:
        return 16;
      case SizeEnum.large:
        return 25;
    }
  }

  double get paddingTop {
    switch (this) {
      case SizeEnum.small:
        return 2;
      case SizeEnum.normal:
        return 14;
      case SizeEnum.large:
        return 16;
    }
  }
}
