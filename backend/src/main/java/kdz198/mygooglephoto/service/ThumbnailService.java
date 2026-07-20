package kdz198.mygooglephoto.service;

import java.nio.file.Path;

/** Service interface để generate thumbnail từ ảnh/video đã upload. */
public interface ThumbnailService {

  /**
   * Generate thumbnail cho file tại {@code sourcePath} và lưu vào thư mục thumbnail.
   *
   * <p>Với ảnh: resize về max 400×400 giữ tỉ lệ, lưu dạng JPEG.<br>
   * Với video hoặc format không hỗ trợ: trả về {@code null}.
   *
   * @param sourcePath đường dẫn tuyệt đối của file gốc
   * @param mediaType "IMAGE" hoặc "VIDEO"
   * @return path của thumbnail đã lưu, hoặc {@code null} nếu không generate được
   */
  Path generate(Path sourcePath, String mediaType);
}
