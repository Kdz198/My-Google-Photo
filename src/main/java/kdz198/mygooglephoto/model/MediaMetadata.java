package kdz198.mygooglephoto.model;

import lombok.*;

/**
 * POJO đại diện cho metadata EXIF và các thông tin liên quan, được lưu dưới dạng JSONB.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MediaMetadata {
    /**
     * Độ rộng ảnh (pixel).
     */
    private Integer width;
    /**
     * Độ cao ảnh (pixel).
     */
    private Integer height;
    /**
     * Kiểu MIME của file, ví dụ "image/jpeg" hoặc "video/mp4".
     */
    private String mime_type;
    /**
     * Thông tin thiết bị chụp ảnh (hãng, mẫu).
     */
    private Device device;
    /**
     * Thông tin cấu hình máy ảnh (độ mở khẩu, ISO, tốc độ màn trập).
     */
    private Camera camera;
    /**
     * Vị trí GPS nơi chụp ảnh.
     */
    private Location location;

    /**
     * Thông tin thiết bị (hãng, mẫu).
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Device {
        private String make;   // Hãng, ví dụ "Apple"
        private String model;  // Mẫu, ví dụ "iPhone 15 Pro"
    }

    /**
     * Thông số máy ảnh.
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Camera {
        private String aperture;      // Ống kính (f/1.8)
        private Integer iso;          // ISO
        private String shutter_speed; // Tốc độ màn trập (1/120)
    }

    /**
     * Thông tin vị trí GPS.
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class Location {
        private Double latitude;  // Vĩ độ
        private Double longitude; // Kinh độ
    }
}
