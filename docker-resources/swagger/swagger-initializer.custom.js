// docker-resources/swagger/swagger-initializer.js

window.onload = function () {
  window.ui = SwaggerUIBundle({
    url: "../swagger.json",
    dom_id: "#swagger-ui",
    deepLinking: true,
    presets: [SwaggerUIBundle.presets.apis, SwaggerUIStandalonePreset],
    layout: "StandaloneLayout",
  });
};
