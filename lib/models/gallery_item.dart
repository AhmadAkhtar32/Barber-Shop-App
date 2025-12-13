class GalleryItem {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? fallbackImageUrl; // Added fallback image URL

  GalleryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.fallbackImageUrl, // Optional fallback image URL
  });

  // Convert to JSON (if you need serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'fallbackImageUrl': fallbackImageUrl,
    };
  }

  // Create from JSON (if you need deserialization)
  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      fallbackImageUrl: json['fallbackImageUrl'],
    );
  }

  // Create a copy with updated values
  GalleryItem copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? fallbackImageUrl,
  }) {
    return GalleryItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      fallbackImageUrl: fallbackImageUrl ?? this.fallbackImageUrl,
    );
  }
}