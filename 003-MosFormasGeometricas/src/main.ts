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

  // Círculo en movimiento (azul celeste)
  const movingCircle = new Graphics();
  let isCyan = true; // Track color state (true for cyan, false for green)

  // Draw initial circle
  movingCircle.beginFill(0x00ffff);
  movingCircle.drawCircle(0, 0, 50);
  movingCircle.endFill();

  // Posición inicial
  movingCircle.x = 100;
  movingCircle.y = 350;

  // Habilitar interactividad
  movingCircle.interactive = true;
  movingCircle.buttonMode = true; // Cursor de botón

  // Toggle color on click
  movingCircle.on("pointerdown", () => {
    movingCircle.clear();
    isCyan = !isCyan; // Toggle color state
    movingCircle.beginFill(isCyan ? 0x00ffff : 0x00ff00); // Cyan or green
    movingCircle.drawCircle(0, 0, 50);
    movingCircle.endFill();
  });

  app.stage.addChild(movingCircle);

  // Animación
  app.ticker.add(() => {
    movingCircle.x += 2; // Mover a la derecha
    if (movingCircle.x > app.screen.width) movingCircle.x = 0; // Reiniciar
  });
})();
