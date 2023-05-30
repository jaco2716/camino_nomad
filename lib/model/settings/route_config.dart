class RouteConfig {
  final int id;
  final String name;
  final double distance;
  final double eleMin;
  final double eleMax;
  final double eleGain;
  final double eleLoss;

  const RouteConfig(
    this.id,
    this.name, {
    required this.distance,
    required this.eleMin,
    required this.eleMax,
    required this.eleGain,
    required this.eleLoss,
  });
}
