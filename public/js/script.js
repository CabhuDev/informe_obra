/* URL del webhook - detecta automáticamente el entorno */
const WEBHOOK_URL = (() => {
  const hostname = window.location.hostname;
  const protocol = window.location.protocol;
  
  if (hostname === 'localhost' || hostname === '127.0.0.1') {
    // Desarrollo local
    return "http://localhost:10000/webhook/form-obra";

    // Desarrollo local con n8n en puerto 5678
    // Cambia el puerto según tu configuración local
    //return "http://localhost:5678/webhook-test/form-obra";
  } else {
    // Producción en Render
    return `${protocol}//${hostname}/webhook/form-obra`;
  }
})();

let form = document.getElementById("obraForm");
let status = document.getElementById("status");
let audioRecord = document.getElementById("audioPlayback");
let loadingContainer = document.getElementById("loadingContainer");

console.log("🔗 Webhook URL configurada:", WEBHOOK_URL);

form.addEventListener("submit", (e) => {
  e.preventDefault();
  // Mostrar estado de carga
  status.textContent = "";
  const submitButton = form.querySelector('button[type="submit"]');
  submitButton.disabled = true;
  
  // Mostrar SVG de envío
  if (loadingContainer) {
    loadingContainer.style.display = "flex";
  }

  // Usar FormData para manejar archivos
  const formData = new FormData(form);
  
  console.log("📤 Enviando datos a:", WEBHOOK_URL);
  
  fetch(WEBHOOK_URL, {
    method: "POST",
    body: formData
  })  .then(response => {
    // Ocultar SVG de envío
    if (loadingContainer) {
      loadingContainer.style.display = "none";
    }
    
    if (response.ok) {
      status.textContent = "✅ Informe enviado correctamente";
      form.reset();
      
      // Resetear completamente la interfaz de audio
      audioRecord.style.display = "none";
      audioRecord.src = "";
      document.getElementById("audioData").value = "";
      document.getElementById("recordingStatus").textContent = "";
      document.getElementById("startRecording").disabled = false;
      document.getElementById("stopRecording").disabled = true;
      
      // Resetear fotos si existe el photoManager
      if (window.photoManager) {
        photoManager.photos = [];
        photoManager.currentPhotoId = 0;
        document.getElementById('photosContainer').innerHTML = '';
      }
    } else {
      status.textContent = "❌ Error al enviar";
    }
  })  .catch(err => {
    // Ocultar SVG de envío en caso de error
    if (loadingContainer) {
      loadingContainer.style.display = "none";
    }
    
    console.error("Error de red:", err);
    status.textContent = "❌ Error de red";
  })
  .finally(() => {
    submitButton.disabled = false;
  });
});