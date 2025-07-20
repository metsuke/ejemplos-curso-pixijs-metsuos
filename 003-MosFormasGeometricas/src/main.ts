import { Application, Graphics } from "pixi.js";

(async () => {
  // Create a new application
  const app = new Application();
  const appcontainer = document.querySelector(".pixi-app") as HTMLElement;

  // Initialize the application
  await app.init({ background: "#000000", resizeTo: appcontainer });

  // Append the application canvas to the document body
  document.getElementById("pixi-container")!.appendChild(app.canvas);

  // CODIGO PRINCIPAL
  const graphics = new Graphics();

  // Rectángulo
  graphics.beginFill(0xff0000);
  graphics.drawRect(50, 50, 100, 80);
  graphics.endFill();

  // Círculo
  graphics.beginFill(0x00ff00);
  graphics.drawCircle(200, 200, 50);
  graphics.endFill();

  // Línea
  graphics.lineStyle(4, 0x0000ff);
  graphics.moveTo(50, 350);
  graphics.lineTo(150, 450);

  // Polígono
  graphics.beginFill(0xffff00);
  graphics.drawPolygon([250, 300, 300, 400, 200, 400]);
  graphics.endFill();

  app.stage.addChild(graphics);
})();
