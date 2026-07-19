package kdz198.mygooglephoto.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import kdz198.mygooglephoto.model.Media;
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
  @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
  public ResponseEntity<?> uploadMultiple(@RequestParam("files") MultipartFile[] files) {
    try {
      List<Media> savedMedia = photoStorageService.storeFiles(files);
      return ResponseEntity.ok(savedMedia);
    } catch (IOException e) {
      return ResponseEntity.status(500).body("Failed to store files: " + e.getMessage());
    }
  }

  // ---------------------------------------------------------------------------
  // GET /api/photos?page=0&size=20 — danh sách dạng slice (cursor-based)
  // ---------------------------------------------------------------------------
  @GetMapping
  public ResponseEntity<Slice<Media>> listFiles(
      @RequestParam(defaultValue = "0") int page, @RequestParam(defaultValue = "20") int size) {
    PageRequest pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "uploadTime"));
    return ResponseEntity.ok(photoStorageService.listFiles(pageable));
  }

  // ---------------------------------------------------------------------------
  // GET /api/photos/{id} — chi tiết + metadata của 1 file
  // ---------------------------------------------------------------------------
  @GetMapping("/{id}")
  public ResponseEntity<?> getDetail(@PathVariable Long id) {
    try {
      return ResponseEntity.ok(photoStorageService.getDetail(id));
    } catch (jakarta.persistence.EntityNotFoundException e) {
      return ResponseEntity.status(404).body(e.getMessage());
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE /api/photos/{id} — xóa file khỏi disk và DB
  // ---------------------------------------------------------------------------
  @DeleteMapping("/{id}")
  public ResponseEntity<?> deleteFile(@PathVariable Long id) {
    try {
      photoStorageService.deleteFile(id);
      return ResponseEntity.noContent().build();
    } catch (jakarta.persistence.EntityNotFoundException e) {
      return ResponseEntity.status(404).body(e.getMessage());
    } catch (IOException e) {
      return ResponseEntity.status(500).body("Failed to delete file: " + e.getMessage());
    }
  }

  // ---------------------------------------------------------------------------
  // GET /api/photos/preview/{shareToken} — shortlink preview / chia sẻ
  // Stream nội dung file về trình duyệt với đúng content-type
  // ---------------------------------------------------------------------------
  @GetMapping("/preview/{shareToken}")
  public ResponseEntity<Resource> previewByShareToken(@PathVariable UUID shareToken) {
    try {
      Media media = photoStorageService.getByShareToken(shareToken);
      java.nio.file.Path filePath = Paths.get(media.getStoragePath());

      if (!Files.exists(filePath)) {
        return ResponseEntity.status(404).build();
      }

      byte[] data = Files.readAllBytes(filePath);
      ByteArrayResource resource = new ByteArrayResource(data);

      // Detect content-type: ưu tiên từ metadata, fallback theo extension
      String contentType =
          media.getMetadata() != null && media.getMetadata().getMime_type() != null
              ? media.getMetadata().getMime_type()
              : MediaType.APPLICATION_OCTET_STREAM_VALUE;

      return ResponseEntity.ok()
          .header(
              HttpHeaders.CONTENT_DISPOSITION,
              "inline; filename=\"" + media.getOriginalFilename() + "\"")
          .contentType(MediaType.parseMediaType(contentType))
          .contentLength(data.length)
          .body(resource);

    } catch (jakarta.persistence.EntityNotFoundException e) {
      return ResponseEntity.status(404).build();
    } catch (IOException e) {
      return ResponseEntity.status(500).build();
    }
  }
}
