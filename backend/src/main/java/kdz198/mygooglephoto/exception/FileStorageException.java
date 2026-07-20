package kdz198.mygooglephoto.exception;

/** Thrown when a file I/O operation fails during storage or deletion. */
public class FileStorageException extends RuntimeException {

  public FileStorageException(String message, Throwable cause) {
    super(message, cause);
  }
}
