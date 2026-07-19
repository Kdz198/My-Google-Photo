package kdz198.mygooglephoto.exception;

/** Thrown when a requested media record cannot be found. */
public class MediaNotFoundException extends RuntimeException {

  public MediaNotFoundException(Long id) {
    super("Media not found with id: " + id);
  }

  public MediaNotFoundException(String message) {
    super(message);
  }
}
