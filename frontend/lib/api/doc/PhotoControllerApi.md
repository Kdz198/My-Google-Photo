# openapi.api.PhotoControllerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://api-photo.kdz.asia*

Method | HTTP request | Description
------------- | ------------- | -------------
[**deleteFile**](PhotoControllerApi.md#deletefile) | **DELETE** /api/photos/{id} | Xóa file khỏi disk và database
[**getDetail**](PhotoControllerApi.md#getdetail) | **GET** /api/photos/{id} | Xem chi tiết + EXIF metadata của 1 file
[**listFiles**](PhotoControllerApi.md#listfiles) | **GET** /api/photos | Lấy danh sách media dạng slice, sort theo uploadTime giảm dần
[**previewByShareToken**](PhotoControllerApi.md#previewbysharetoken) | **GET** /api/photos/preview/{shareToken} | Preview file qua shortlink
[**uploadMultiple**](PhotoControllerApi.md#uploadmultiple) | **POST** /api/photos/upload | Upload nhiều file ảnh/video


# **deleteFile**
> deleteFile(id)

Xóa file khỏi disk và database

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = PhotoControllerApi();
final id = 789; // int | 

try {
    api_instance.deleteFile(id);
} catch (e) {
    print('Exception when calling PhotoControllerApi->deleteFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDetail**
> Media getDetail(id)

Xem chi tiết + EXIF metadata của 1 file

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = PhotoControllerApi();
final id = 789; // int | 

try {
    final result = api_instance.getDetail(id);
    print(result);
} catch (e) {
    print('Exception when calling PhotoControllerApi->getDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Media**](Media.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFiles**
> SliceMedia listFiles(page, size)

Lấy danh sách media dạng slice, sort theo uploadTime giảm dần

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = PhotoControllerApi();
final page = 56; // int | 
final size = 56; // int | 

try {
    final result = api_instance.listFiles(page, size);
    print(result);
} catch (e) {
    print('Exception when calling PhotoControllerApi->listFiles: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional] [default to 0]
 **size** | **int**|  | [optional] [default to 20]

### Return type

[**SliceMedia**](SliceMedia.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **previewByShareToken**
> MultipartFile previewByShareToken(shareToken)

Preview file qua shortlink

Dùng shareToken (UUID) để stream file về trình duyệt. Có thể chia sẻ link này cho người khác xem trực tiếp.

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = PhotoControllerApi();
final shareToken = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.previewByShareToken(shareToken);
    print(result);
} catch (e) {
    print('Exception when calling PhotoControllerApi->previewByShareToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **shareToken** | **String**|  | 

### Return type

[**MultipartFile**](MultipartFile.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadMultiple**
> List<Media> uploadMultiple(files)

Upload nhiều file ảnh/video

### Example
```dart
import 'package:openapi/api.dart';

final api_instance = PhotoControllerApi();
final files = [/path/to/file.txt]; // List<MultipartFile> | Danh sách file cần upload

try {
    final result = api_instance.uploadMultiple(files);
    print(result);
} catch (e) {
    print('Exception when calling PhotoControllerApi->uploadMultiple: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **files** | [**List<MultipartFile>**](MultipartFile.md)| Danh sách file cần upload | 

### Return type

[**List<Media>**](Media.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

