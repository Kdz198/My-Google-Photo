package kdz198.mygooglephoto.service;

import java.util.List;
import java.util.UUID;
import kdz198.mygooglephoto.model.Media;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.web.multipart.MultipartFile;

/** Service interface for managing uploaded photo/video files and their metadata. */
public interface PhotoStorageService {

  /**
   * Stores the given multipart files on disk and persists their metadata to the database.
   *
   * @param files the uploaded files
   * @return list of saved {@link Media} records
   */
  List<Media> storeFiles(MultipartFile[] files);

  /**
   * Returns a slice (cursor-based page) of media records ordered by upload time descending.
   *
   * @param pageable pagination info (page, size)
   * @return slice of {@link Media}
   */
  Slice<Media> listFiles(Pageable pageable);

  /**
   * Returns the full detail (including metadata) for a single media record.
   *
   * @param id the media id
   * @return the {@link Media} entity
   */
  Media getDetail(Long id);

  /**
   * Deletes a media record and its associated file on disk.
   *
   * @param id the media id
   */
  void deleteFile(Long id);

  /**
   * Looks up a media record by its share token (used by preview/shortlink endpoint).
   *
   * @param shareToken the share UUID token
   * @return the {@link Media} entity
   */
  Media getByShareToken(UUID shareToken);

  /**
   * Reads the file bytes and resolves content-type for the given share token. Encapsulates all disk
   * I/O so the controller stays thin.
   *
   * @param shareToken the share UUID token
   * @return {@link MediaPreview} containing raw bytes, content-type and filename
   */
  MediaPreview getPreview(UUID shareToken);
}
