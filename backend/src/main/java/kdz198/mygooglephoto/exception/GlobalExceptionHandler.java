package kdz198.mygooglephoto.exception;

import java.time.LocalDateTime;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/** Centralized exception handler — controller không cần try-catch nào cả. */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(MediaNotFoundException.class)
  public ResponseEntity<Map<String, Object>> handleNotFound(MediaNotFoundException ex) {
    log.warn("Media not found: {}", ex.getMessage());
    return buildResponse(HttpStatus.NOT_FOUND, ex.getMessage());
  }

  @ExceptionHandler(FileStorageException.class)
  public ResponseEntity<Map<String, Object>> handleStorageError(FileStorageException ex) {
    log.error("File storage error", ex);
    return buildResponse(HttpStatus.INTERNAL_SERVER_ERROR, ex.getMessage());
  }

  @ExceptionHandler(Exception.class)
  public ResponseEntity<Map<String, Object>> handleGeneric(Exception ex) {
    log.error("Unhandled exception", ex);
    return buildResponse(HttpStatus.INTERNAL_SERVER_ERROR, "Unexpected error: " + ex.getMessage());
  }

  private ResponseEntity<Map<String, Object>> buildResponse(HttpStatus status, String message) {
    Map<String, Object> body =
        Map.of("timestamp", LocalDateTime.now(), "status", status.value(), "error", message);
    return ResponseEntity.status(status).body(body);
  }
}
