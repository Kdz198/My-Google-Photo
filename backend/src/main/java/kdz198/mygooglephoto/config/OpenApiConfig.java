package kdz198.mygooglephoto.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Cấu hình OpenAPI / Swagger UI.
 *
 * <p>Khai báo server list theo env để Swagger không bị lỗi Mixed Content khi deploy sau
 * reverse-proxy HTTPS.
 */
@Configuration
public class OpenApiConfig {

  @Value("${app.openapi.prod-url:}")
  private String prodUrl;

  @Value("${app.openapi.dev-url:http://localhost:8080}")
  private String devUrl;

  @Bean
  public OpenAPI customOpenAPI() {
    List<Server> servers = new ArrayList<>();

    // Production server (HTTPS) — chỉ thêm nếu có cấu hình
    if (prodUrl != null && !prodUrl.isBlank()) {
      servers.add(new Server().url(prodUrl).description("Production"));
    }

    // Local dev
    servers.add(new Server().url(devUrl).description("Local Development"));

    return new OpenAPI()
        .info(
            new Info()
                .title("My Google Photo API")
                .version("1.0.0")
                .description("API upload, quản lý và chia sẻ ảnh/video"))
        .servers(servers);
  }
}
