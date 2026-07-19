package kdz198.mygooglephoto.repository;

import kdz198.mygooglephoto.model.Album;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.UUID;

/**
 * Repository for {@link Album} entities.
 */
@Repository
public interface AlbumRepository extends JpaRepository<Album, UUID> {
    // Additional query methods can be added here if needed
}
