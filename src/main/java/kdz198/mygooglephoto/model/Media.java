package kdz198.mygooglephoto.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "medias")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Media {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "id", updatable = false, nullable = false)
  private Long id;

  private String originalFilename;

  private String storagePath;

  private String thumbnailPath;

  private String mediaType; // IMAGE or VIDEO

  private Long sizeBytes;

  private LocalDateTime creationTime;

  @CreationTimestamp
  private LocalDateTime uploadTime;

  @JdbcTypeCode(SqlTypes.JSON)
  @Column(columnDefinition = "jsonb")
  private MediaMetadata metadata;

  private Boolean isFavorite = false;
}
