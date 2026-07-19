package kdz198.mygooglephoto.service;

import java.io.IOException;
import java.util.List;
import kdz198.mygooglephoto.model.Media;
import org.springframework.web.multipart.MultipartFile;

/** Service interface for storing uploaded photo files. */
public interface PhotoStorageService {

  /**
   * Stores the given array of multipart files on the local filesystem and persists their metadata
   * to the database.
   *
   * @param files the uploaded files
   * @return list of saved {@link Media} records
   * @throws IOException if an I/O error occurs during storage
   */
  List<Media> storeFiles(MultipartFile[] files) throws IOException;
}
