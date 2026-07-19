package kdz198.mygooglephoto.model;

import java.io.Serializable;
import java.util.UUID;

/** Composite primary key for AlbumMedia join table. */
public class AlbumMediaId implements Serializable {
  private static final long serialVersionUID = 1L;

  private UUID albumId;
  private Long mediaId;

  // Default constructor required by JPA
  public AlbumMediaId() {}

  public AlbumMediaId(UUID albumId, Long mediaId) {
    this.albumId = albumId;
    this.mediaId = mediaId;
  }

  // Getters & Setters
  public UUID getAlbumId() {
    return albumId;
  }

  public void setAlbumId(UUID albumId) {
    this.albumId = albumId;
  }

  public Long getMediaId() {
    return mediaId;
  }

  public void setMediaId(Long mediaId) {
    this.mediaId = mediaId;
  }

  // equals & hashCode (required for composite key)
  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof AlbumMediaId)) return false;
    AlbumMediaId that = (AlbumMediaId) o;
    return albumId.equals(that.albumId) && mediaId.equals(that.mediaId);
  }

  @Override
  public int hashCode() {
    return 31 * albumId.hashCode() + mediaId.hashCode();
  }
}
