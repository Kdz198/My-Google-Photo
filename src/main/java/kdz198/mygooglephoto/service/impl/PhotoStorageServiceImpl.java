package kdz198.mygooglephoto.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import kdz198.mygooglephoto.exception.FileStorageException;
import kdz198.mygooglephoto.exception.MediaNotFoundException;
import kdz198.mygooglephoto.helper.MediaMetadataExtractor;
import kdz198.mygooglephoto.model.Media;
import kdz198.mygooglephoto.model.MediaMetadata;
import kdz198.mygooglephoto.repository.MediaRepository;
import kdz198.mygooglephoto.service.PhotoStorageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@RequiredArgsConstructor
public class PhotoStorageServiceImpl implements PhotoStorageService {

  private static final Path STORAGE_DIR = Paths.get("/data/photo_homelab");

  private final MediaRepository mediaRepository;
  private final MediaMetadataExtractor metadataExtractor;

  @Override
  public List<Media> storeFiles(MultipartFile[] files) {
    try {
      Files.createDirectories(STORAGE_DIR);
    } catch (IOException e) {
      throw new FileStorageException("Cannot create storage directory: " + STORAGE_DIR, e);
    }

    List<Media> savedMediaList = new ArrayList<>();

    for (MultipartFile file : files) {
      if (file.isEmpty()) {
        continue;
      }

      String originalFilename = file.getOriginalFilename();
      Path destination = STORAGE_DIR.resolve(originalFilename);

      try {
        file.transferTo(destination);
      } catch (IOException e) {
        throw new FileStorageException("Failed to store file: " + originalFilename, e);
      }

      String contentType = file.getContentType();
      String mediaType =
          (contentType != null && contentType.startsWith("video")) ? "VIDEO" : "IMAGE";

      MediaMetadata metadata = metadataExtractor.extract(file);

      Media media =
          Media.builder()
              .originalFilename(originalFilename)
              .storagePath(destination.toString())
              .mediaType(mediaType)
              .sizeBytes(file.getSize())
              .isFavorite(false)
              .metadata(metadata)
              .build();

      savedMediaList.add(mediaRepository.save(media));
      log.info("Stored file '{}' -> {}", originalFilename, destination);
    }

    return savedMediaList;
  }

  @Override
  public Slice<Media> listFiles(Pageable pageable) {
    return mediaRepository.findAll(pageable);
  }

  @Override
  public Media getDetail(Long id) {
    return mediaRepository.findById(id).orElseThrow(() -> new MediaNotFoundException(id));
  }

  @Override
  public void deleteFile(Long id) {
    Media media = getDetail(id);

    Path filePath = Paths.get(media.getStoragePath());
    if (Files.exists(filePath)) {
      try {
        Files.delete(filePath);
        log.info("Deleted file from disk: {}", filePath);
      } catch (IOException e) {
        throw new FileStorageException("Failed to delete file from disk: " + filePath, e);
      }
    } else {
      log.warn("File not found on disk, removing DB record only: {}", filePath);
    }

    mediaRepository.delete(media);
    log.info("Deleted media record id={}", id);
  }

  @Override
  public Media getByShareToken(UUID shareToken) {
    return mediaRepository
        .findByShareToken(shareToken)
        .orElseThrow(
            () -> new MediaNotFoundException("Media not found for share token: " + shareToken));
  }
}
