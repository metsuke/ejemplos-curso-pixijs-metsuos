import { Application, Assets, Sprite } from "pixi.js";

// Función para obtener la ruta base del script actual (usada solo en producción)
function getScriptBaseUrl() {
  const script =
    document.currentScript ||
    // Fallback para navegadores más antiguos
    (function () {
      const scripts = document.getElementsByTagName("script");
      return scripts[scripts.length - 1];
    })();

  // Type guard para asegurar que script es HTMLScriptElement
  if (!(script instanceof HTMLScriptElement)) {
    throw new Error("Current script is not an HTMLScriptElement");
  }

  const scriptUrl = new URL(script.src);
  // Extrae la ruta base (sin el nombre del archivo)
  return scriptUrl.pathname.substring(
    0,
    scriptUrl.pathname.lastIndexOf("/") + 1,
  );
}

(async () => {
  // Determinar la ruta base según el entorno
  const isDevelopment = import.meta.env.MODE === "development";
  const baseUrl = isDevelopment ? "/" : getScriptBaseUrl();

  // Create a new application
  const app = new Application();
  const appcontainer = document.querySelector(".pixi-app") as HTMLElement;

  // Initialize the application
  await app.init({ background: "#1099bb", resizeTo: appcontainer });

  // Append the application canvas to the document body
  document.getElementById("pixi-container")!.appendChild(app.canvas);

  // Load the bunny texture using the appropriate base URL
  const texture = await Assets.load(`${baseUrl}assets/bunny.png`);

  // Create a bunny Sprite
  const bunny = new Sprite(texture);

  // Center the sprite's anchor point
  bunny.anchor.set(0.5);

  // Move the sprite to the center of the screen
  bunny.position.set(app.screen.width / 2, app.screen.height / 2);

  // Add the bunny to the stage
  app.stage.addChild(bunny);

  // Listen for animate update
  app.ticker.add((time) => {
    // Just for fun, let's rotate mr rabbit a little.
    // * Delta is 1 if running at 100% performance *
    // * Creates frame-independent transformation *
    bunny.rotation += 0.1 * time.deltaTime;
  });
})();
