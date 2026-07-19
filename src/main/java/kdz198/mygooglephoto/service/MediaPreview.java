package kdz198.mygooglephoto.service;

/** Dữ liệu cần thiết để stream preview một file về trình duyệt. */
public record MediaPreview(byte[] data, String contentType, String filename) {}
