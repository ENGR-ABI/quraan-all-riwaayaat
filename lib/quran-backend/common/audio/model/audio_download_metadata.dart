class AudioDownloadMetadata {
  final int qariId;

  AudioDownloadMetadata(this.qariId);

  factory AudioDownloadMetadata.fromJson(Map<String, dynamic> json) {
    return AudioDownloadMetadata(json['qariId'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'qariId': qariId,
    };
  }
}
