/* Cambia SOLAMENTE esta línea por la URL de tu webhook */
const WEBHOOK_URL = "http://localhost:5678/webhook-test/form-obra";

let form = document.getElementById("obraForm");
let status = document.getElementById("status");
let audioRecord = document.getElementById("audioPlayback");

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  // Mostrar estado de carga
  status.textContent = "⏳ Enviando informe...";
  const submitButton = form.querySelector('button[type="submit"]');
  submitButton.disabled = true;

  try {
    // Usar FormData para manejar archivos (en lugar de JSON)
    const formData = new FormData(form);
    
    // Enviar como multipart/form-data (NO como JSON)
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