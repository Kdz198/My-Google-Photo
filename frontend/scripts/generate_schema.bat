@echo off
echo 🚀 Downloading OpenAPI Schema from Backend and Generating Dart Code...

npx @openapitools/openapi-generator-cli generate -i https://api-photo.kdz.asia/v3/api-docs -g dart -o lib/api

echo ✅ Schema generated successfully!
