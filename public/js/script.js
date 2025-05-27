/* URL del webhook - detecta automáticamente el entorno */
const WEBHOOK_URL = (() => {
  const hostname = window.location.hostname;
  const protocol = window.location.protocol;
  
  if (hostname === 'localhost' || hostname === '127.0.0.1') {
    // Desarrollo local
    return "http://localhost:10000/webhook/form-obra";
  } else {
    // Producción en Render
    return `${protocol}//${hostname}/webhook/form-obra`;
  }
})();

let form = document.getElementById("obraForm");
let status = document.getElementById("status");
let audioRecord = document.getElementById("audioPlayback");

console.log("🔗 Webhook URL configurada:", WEBHOOK_URL);

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  // Mostrar estado de carga
  status.textContent = "⏳ Enviando informe...";
  const submitButton = form.querySelector('button[type="submit"]');
  submitButton.disabled = true;

  try {
    // Usar FormData para manejar archivos
    const formData = new FormData(form);
    
    console.log("📤 Enviando datos a:", WEBHOOK_URL);
    
    let res = await fetch(WEBHOOK_URL, {
      method: "POST",
      body: formData
    });

    if (res.ok) {
      status.textContent = "✅ Informe enviado correctamente";
      form.reset();
      
      // Resetear completamente la interfaz de audio
      audioRecord.style.display = "none";
      audioRecord.src = "";
      document.getElementById("audioData").value = "";
      document.getElementById("recordingStatus").textContent = "";
      document.getElementById("startRecording").disabled = false;
      document.getElementById("stopRecording").disabled = true;
      
    } else {
      status.textContent = "❌ Error al enviar";
    }
  } catch (err) {
    console.error("Error de red:", err);
    status.textContent = "❌ Error de red";
  } finally {
    submitButton.disabled = false;
  }
});