package kdz198.mygooglephoto.repository;

import java.util.UUID;
import kdz198.mygooglephoto.model.Media;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

/** Spring Data JPA repository for {@link Media} entities. */
@Repository
public interface MediaRepository extends JpaRepository<Media, UUID> {
  // Additional query methods can be defined here if needed, e.g., findByIsFavoriteTrue()
}
