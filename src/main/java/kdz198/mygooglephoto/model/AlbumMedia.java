package kdz198.mygooglephoto.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Join entity representing the many‑to‑many relationship between {@link Album} and {@link Media}.
 * Uses a composite primary key defined in {@link AlbumMediaId}.
 */
@Entity
@Table(name = "album_medias")

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
public class AlbumMedia {

    @Column(name = "album_id", columnDefinition = "UUID", updatable = false, nullable = false)
    private UUID albumId;

    @Column(name = "media_id", updatable = false, nullable = false)
    private Long mediaId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "album_id", insertable = false, updatable = false)
    private Album album;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "media_id", insertable = false, updatable = false)
    private Media media;

    @Column(name = "added_at", nullable = false)
    private LocalDateTime addedAt = LocalDateTime.now();
}
