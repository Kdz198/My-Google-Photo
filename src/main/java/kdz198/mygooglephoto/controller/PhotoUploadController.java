package kdz198.mygooglephoto.controller;

import java.io.IOException;
import java.util.List;
import kdz198.mygooglephoto.model.Media;
import kdz198.mygooglephoto.service.PhotoStorageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/photos")
@RequiredArgsConstructor
public class PhotoUploadController {

  private final PhotoStorageService photoStorageService;

  @PostMapping(value = "/upload", consumes = "multipart/form-data")
  public ResponseEntity<?> uploadMultiple(@RequestParam("files") MultipartFile[] files) {
    try {
      List<Media> savedMedia = photoStorageService.storeFiles(files);
      return ResponseEntity.ok(savedMedia);
    } catch (IOException e) {
      return ResponseEntity.status(500).body("Failed to store files: " + e.getMessage());
    }
  }
}
