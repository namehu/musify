///
enum ServeTypeEnum {
  navidrome('navidrome'),

  jellyfin('jellyfin'),

  subsnoic('subsnoic');

  const ServeTypeEnum(this.label);

  final String label;
}
