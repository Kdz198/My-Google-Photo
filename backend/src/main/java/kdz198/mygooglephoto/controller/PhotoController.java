package kdz198.mygooglephoto.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.List;
import java.util.UUID;
import kdz198.mygooglephoto.model.Media;
import kdz198.mygooglephoto.service.MediaPreview;
import kdz198.mygooglephoto.service.PhotoStorageService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/photos")
@RequiredArgsConstructor
public class PhotoController {

  private final PhotoStorageService photoStorageService;

  // ---------------------------------------------------------------------------
  // POST /api/photos/upload — upload nhiều file
  // ---------------------------------------------------------------------------
  @Operation(summary = "Upload nhiều file ảnh/video")
  @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  public ResponseEntity<List<Media>> uploadMultiple(
      @Parameter(
              description = "Danh sách file cần upload",
              required = true,
              array = @ArraySchema(schema = @Schema(type = "string", format = "binary")))
          @RequestParam("files")
          MultipartFile[] files) {
    return ResponseEntity.ok(photoStorageService.storeFiles(files));
  }

  // ---------------------------------------------------------------------------
  // GET /api/photos?page=0&size=20 — danh sách dạng slice
  // ---------------------------------------------------------------------------
  @Operation(summary = "Lấy danh sách media dạng slice, sort theo uploadTime giảm dần")
  @GetMapping
  public ResponseEntity<Slice<Media>> listFiles(
      @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "20") int size) {
    PageRequest pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "uploadTime"));
    return ResponseEntity.ok(photoStorageService.listFiles(pageable));
  }

  // ---------------------------------------------------------------------------
  // GET /api/photos/{id} — chi tiết + metadata của 1 file
  // ---------------------------------------------------------------------------
  @Operation(summary = "Xem chi tiết + EXIF metadata của 1 file")
  @GetMapping("/{id}")
  public ResponseEntity<Media> getDetail(@PathVariable Long id) {
    return ResponseEntity.ok(photoStorageService.getDetail(id));
  }

  // ---------------------------------------------------------------------------
  // DELETE /api/photos/{id} — xóa file khỏi disk và DB
  // ---------------------------------------------------------------------------
  @Operation(summary = "Xóa file khỏi disk và database")
  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deleteFile(@PathVariable Long id) {
    photoStorageService.deleteFile(id);
    return ResponseEntity.noContent().build();
  }

  // ---------------------------------------------------------------------------
  // GET /api/photos/preview/{shareToken} — shortlink preview / chia sẻ
  // ---------------------------------------------------------------------------
  @Operation(
      summary = "Preview file qua shortlink",
      description =
          "Dùng shareToken (UUID) để stream file về trình duyệt. "
              + "Có thể chia sẻ link này cho người khác xem trực tiếp.")
  @GetMapping("/preview/{shareToken}")
  public ResponseEntity<Resource> previewByShareToken(@PathVariable UUID shareToken) {
    MediaPreview preview = photoStorageService.getPreview(shareToken);
    return ResponseEntity.ok()
        .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + preview.filename() + "\"")
        .contentType(MediaType.parseMediaType(preview.contentType()))
        .contentLength(preview.data().length)
        .body(new ByteArrayResource(preview.data()));
  }
}
