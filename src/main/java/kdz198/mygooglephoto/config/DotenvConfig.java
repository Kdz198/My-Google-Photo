package kdz198.mygooglephoto.config;

import io.github.cdimascio.dotenv.Dotenv;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Configuration;

/**
 * Loads environment variables from a .env file at the project root.
 * The variables are then exposed as system properties so Spring can resolve
 * placeholders like ${SPRING_DATASOURCE_URL} defined in {@code application.properties}.
 */
@Configuration
public class DotenvConfig {
    private final Dotenv dotenv = Dotenv.configure()
            .directory(".") // project root
            .ignoreIfMissing()
            .load();

    @PostConstruct
    public void init() {
        dotenv.entries().forEach(e -> System.setProperty(e.getKey(), e.getValue()));
    }
}
