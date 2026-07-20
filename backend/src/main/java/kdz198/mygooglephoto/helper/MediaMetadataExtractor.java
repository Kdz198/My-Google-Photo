package kdz198.mygooglephoto.helper;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.lang.GeoLocation;
import com.drew.metadata.Metadata;
import com.drew.metadata.exif.ExifIFD0Directory;
import com.drew.metadata.exif.ExifSubIFDDirectory;
import com.drew.metadata.exif.GpsDirectory;
import com.drew.metadata.jpeg.JpegDirectory;
import com.drew.metadata.png.PngDirectory;
import java.io.IOException;
import java.io.InputStream;
import kdz198.mygooglephoto.model.MediaMetadata;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

/**
 * Helper component that reads EXIF / image metadata from an uploaded {@link MultipartFile} and maps
 * it to a {@link MediaMetadata} record.
 *
 * <p>Uses the <a href="https://drewnoakes.com/code/exif/">metadata-extractor</a> library. Fields
 * that cannot be determined are left {@code null}.
 */
@Slf4j
@Component
public class MediaMetadataExtractor {

  /**
   * Extracts available metadata from the given multipart file.
   *
   * @param file the uploaded file
   * @return populated {@link MediaMetadata}; never {@code null}
   */
  public MediaMetadata extract(MultipartFile file) {
    MediaMetadata.MediaMetadataBuilder builder =
        MediaMetadata.builder().mime_type(file.getContentType());

    try (InputStream is = file.getInputStream()) {
      Metadata metadata = ImageMetadataReader.readMetadata(is);

      builder.width(extractWidth(metadata));
      builder.height(extractHeight(metadata));
      builder.device(extractDevice(metadata));
      builder.camera(extractCamera(metadata));
      builder.location(extractLocation(metadata));

    } catch (ImageProcessingException | IOException e) {
      // Non-fatal — metadata simply won't be available for this file
      log.warn(
          "Could not extract metadata from file '{}': {}",
          file.getOriginalFilename(),
          e.getMessage());
    }

    return builder.build();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  private Integer extractWidth(Metadata metadata) {
    JpegDirectory jpegDir = metadata.getFirstDirectoryOfType(JpegDirectory.class);
    if (jpegDir != null && jpegDir.containsTag(JpegDirectory.TAG_IMAGE_WIDTH)) {
      return jpegDir.getInteger(JpegDirectory.TAG_IMAGE_WIDTH);
    }
    PngDirectory pngDir = metadata.getFirstDirectoryOfType(PngDirectory.class);
    if (pngDir != null && pngDir.containsTag(PngDirectory.TAG_IMAGE_WIDTH)) {
      return pngDir.getInteger(PngDirectory.TAG_IMAGE_WIDTH);
    }
    ExifSubIFDDirectory exifDir = metadata.getFirstDirectoryOfType(ExifSubIFDDirectory.class);
    if (exifDir != null && exifDir.containsTag(ExifSubIFDDirectory.TAG_EXIF_IMAGE_WIDTH)) {
      return exifDir.getInteger(ExifSubIFDDirectory.TAG_EXIF_IMAGE_WIDTH);
    }
    return null;
  }

  private Integer extractHeight(Metadata metadata) {
    JpegDirectory jpegDir = metadata.getFirstDirectoryOfType(JpegDirectory.class);
    if (jpegDir != null && jpegDir.containsTag(JpegDirectory.TAG_IMAGE_HEIGHT)) {
      return jpegDir.getInteger(JpegDirectory.TAG_IMAGE_HEIGHT);
    }
    PngDirectory pngDir = metadata.getFirstDirectoryOfType(PngDirectory.class);
    if (pngDir != null && pngDir.containsTag(PngDirectory.TAG_IMAGE_HEIGHT)) {
      return pngDir.getInteger(PngDirectory.TAG_IMAGE_HEIGHT);
    }
    ExifSubIFDDirectory exifDir = metadata.getFirstDirectoryOfType(ExifSubIFDDirectory.class);
    if (exifDir != null && exifDir.containsTag(ExifSubIFDDirectory.TAG_EXIF_IMAGE_HEIGHT)) {
      return exifDir.getInteger(ExifSubIFDDirectory.TAG_EXIF_IMAGE_HEIGHT);
    }
    return null;
  }

  private MediaMetadata.Device extractDevice(Metadata metadata) {
    ExifIFD0Directory ifd0 = metadata.getFirstDirectoryOfType(ExifIFD0Directory.class);
    if (ifd0 == null) return null;

    String make =
        ifd0.containsTag(ExifIFD0Directory.TAG_MAKE)
            ? ifd0.getString(ExifIFD0Directory.TAG_MAKE)
            : null;
    String model =
        ifd0.containsTag(ExifIFD0Directory.TAG_MODEL)
            ? ifd0.getString(ExifIFD0Directory.TAG_MODEL)
            : null;

    if (make == null && model == null) return null;
    return MediaMetadata.Device.builder().make(make).model(model).build();
  }

  private MediaMetadata.Camera extractCamera(Metadata metadata) {
    ExifSubIFDDirectory exifDir = metadata.getFirstDirectoryOfType(ExifSubIFDDirectory.class);
    if (exifDir == null) return null;

    String aperture =
        exifDir.containsTag(ExifSubIFDDirectory.TAG_FNUMBER)
            ? exifDir.getString(ExifSubIFDDirectory.TAG_FNUMBER)
            : null;
    Integer iso =
        exifDir.containsTag(ExifSubIFDDirectory.TAG_ISO_EQUIVALENT)
            ? exifDir.getInteger(ExifSubIFDDirectory.TAG_ISO_EQUIVALENT)
            : null;
    String shutterSpeed =
        exifDir.containsTag(ExifSubIFDDirectory.TAG_EXPOSURE_TIME)
            ? exifDir.getString(ExifSubIFDDirectory.TAG_EXPOSURE_TIME)
            : null;

    if (aperture == null && iso == null && shutterSpeed == null) return null;
    return MediaMetadata.Camera.builder()
        .aperture(aperture)
        .iso(iso)
        .shutter_speed(shutterSpeed)
        .build();
  }

  private MediaMetadata.Location extractLocation(Metadata metadata) {
    GpsDirectory gpsDir = metadata.getFirstDirectoryOfType(GpsDirectory.class);
    if (gpsDir == null) return null;

    GeoLocation geoLocation = gpsDir.getGeoLocation();
    if (geoLocation == null || geoLocation.isZero()) return null;

    return MediaMetadata.Location.builder()
        .latitude(geoLocation.getLatitude())
        .longitude(geoLocation.getLongitude())
        .build();
  }
}
