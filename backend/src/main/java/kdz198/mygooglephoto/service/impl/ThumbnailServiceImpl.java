package kdz198.mygooglephoto.service.impl;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import kdz198.mygooglephoto.service.ThumbnailService;
import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class ThumbnailServiceImpl implements ThumbnailService {

  /** Kích thước tối đa của thumbnail (giữ tỉ lệ). */
  private static final int THUMB_SIZE = 400;

  /** Thư mục con lưu thumbnail bên trong STORAGE_DIR. */
  private static final String THUMB_DIR_NAME = "thumbnails";

  @Override
  public Path generate(Path sourcePath, String mediaType) {
    if (!"IMAGE".equalsIgnoreCase(mediaType)) {
      // Video thumbnail cần FFmpeg — bỏ qua ở đây
      return null;
    }

    try {
      Path thumbDir = sourcePath.getParent().resolve(THUMB_DIR_NAME);
      Files.createDirectories(thumbDir);

      // Tên thumbnail: <tên gốc không đuôi>_thumb.jpg
      String originalName = sourcePath.getFileName().toString();
      String baseName =
          originalName.contains(".")
              ? originalName.substring(0, originalName.lastIndexOf('.'))
              : originalName;
      Path thumbPath = thumbDir.resolve(baseName + "_thumb.jpg");

      Thumbnails.of(sourcePath.toFile())
          .size(THUMB_SIZE, THUMB_SIZE)
          .keepAspectRatio(true)
          .outputFormat("jpg")
          .toFile(thumbPath.toFile());

      log.info("Generated thumbnail: {}", thumbPath);
      return thumbPath;

    } catch (IOException e) {
      log.warn(
          "Could not generate thumbnail for '{}': {}", sourcePath.getFileName(), e.getMessage());
      return null;
    }
  }
}
