import { defineConfig } from "vite";

export default defineConfig({
  base: "./", // Usa rutas relativas desde la carpeta del bundle
  server: {
    port: 8080,
    open: true,
  },
  build: {
    lib: {
      entry: "src/main.js", // Cambia esto al archivo de entrada de tu proyecto (por ejemplo, src/app.js)
      name: "mosformasgeometricas", // Nombre global de tu app (se expondrá en window.MyPixiApp si es necesario)
      fileName: "app-mosformasgeometricas", // Nombre del archivo de salida (sin extensión)
      formats: ["iife"], // Formato IIFE para vanilla JS
    },
    outDir: "dist", // Carpeta de salida para el bundle
    minify: "esbuild", // Minifica el código para reducir el tamaño
    sourcemap: false, // Desactiva los sourcemaps (opcional, puedes habilitarlo con true si los necesitas)
  },
});
