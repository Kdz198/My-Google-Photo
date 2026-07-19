package kdz198.mygooglephoto.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entity representing a media file (image or video) stored in the system. Only essential fields
 * required for UI timeline, file management, and EXIF metadata are kept.
 */
@Entity
@Table(name = "medias")
public class Media {

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  @Column(name = "id", columnDefinition = "UUID", updatable = false, nullable = false)
  private UUID id;

  @Column(name = "original_filename", length = 255, nullable = false)
  private String originalFilename;

  @Column(name = "storage_path", length = 500, nullable = false)
  private String storagePath;

  @Column(name = "thumbnail_path", length = 500)
  private String thumbnailPath;

  @Column(name = "media_type", length = 20, nullable = false)
  private String mediaType; // IMAGE or VIDEO

  @Column(name = "size_bytes", nullable = false)
  private Long sizeBytes;

  @Column(name = "creation_time", nullable = false)
  private LocalDateTime creationTime;

  @Column(name = "upload_time", nullable = false)
  private LocalDateTime uploadTime = LocalDateTime.now();

  @Column(name = "metadata", columnDefinition = "jsonb")
  private String metadata; // stores full EXIF etc. as JSON string

  @Column(name = "is_favorite", nullable = false)
  private Boolean isFavorite = false;

  // ---------- Getters & Setters ----------
  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }

  public String getOriginalFilename() {
    return originalFilename;
  }

  public void setOriginalFilename(String originalFilename) {
    this.originalFilename = originalFilename;
  }

  public String getStoragePath() {
    return storagePath;
  }

  public void setStoragePath(String storagePath) {
    this.storagePath = storagePath;
  }

  public String getThumbnailPath() {
    return thumbnailPath;
  }

  public void setThumbnailPath(String thumbnailPath) {
    this.thumbnailPath = thumbnailPath;
  }

  public String getMediaType() {
    return mediaType;
  }

  public void setMediaType(String mediaType) {
    this.mediaType = mediaType;
  }

  public Long getSizeBytes() {
    return sizeBytes;
  }

  public void setSizeBytes(Long sizeBytes) {
    this.sizeBytes = sizeBytes;
  }

  public LocalDateTime getCreationTime() {
    return creationTime;
  }

  public void setCreationTime(LocalDateTime creationTime) {
    this.creationTime = creationTime;
  }

  public LocalDateTime getUploadTime() {
    return uploadTime;
  }

  public void setUploadTime(LocalDateTime uploadTime) {
    this.uploadTime = uploadTime;
  }

  public String getMetadata() {
    return metadata;
  }

  public void setMetadata(String metadata) {
    this.metadata = metadata;
  }

  public Boolean getIsFavorite() {
    return isFavorite;
  }

  public void setIsFavorite(Boolean isFavorite) {
    this.isFavorite = isFavorite;
  }
}
