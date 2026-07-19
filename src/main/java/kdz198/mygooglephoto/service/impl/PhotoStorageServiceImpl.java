package kdz198.mygooglephoto.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import kdz198.mygooglephoto.model.Media;
import kdz198.mygooglephoto.repository.MediaRepository;
import kdz198.mygooglephoto.service.PhotoStorageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class PhotoStorageServiceImpl implements PhotoStorageService {

  private static final Path STORAGE_DIR = Paths.get("/data/photo_homelab");

  private final MediaRepository mediaRepository;

  @Override
  public List<Media> storeFiles(MultipartFile[] files) throws IOException {
    // Ensure storage directory exists
    Files.createDirectories(STORAGE_DIR);

    List<Media> savedMediaList = new ArrayList<>();

    for (MultipartFile file : files) {
      if (file.isEmpty()) {
        continue;
      }

      String originalFilename = file.getOriginalFilename();
      Path destination = STORAGE_DIR.resolve(originalFilename);

      // Transfer file to destination (overwrites if exists)
      file.transferTo(destination);

      // Determine media type from content type
      String contentType = file.getContentType();
      String mediaType =
          (contentType != null && contentType.startsWith("video")) ? "VIDEO" : "IMAGE";

      // Build and save Media entity
      Media media =
          Media.builder()
              .originalFilename(originalFilename)
              .storagePath(destination.toString())
              .mediaType(mediaType)
              .sizeBytes(file.getSize())
              .isFavorite(false)
              .build();

      savedMediaList.add(mediaRepository.save(media));
    }

    return savedMediaList;
  }
}
