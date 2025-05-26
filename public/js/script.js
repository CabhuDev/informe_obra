/* Cambia SOLAMENTE esta línea por la URL de tu webhook */
const WEBHOOK_URL = "http://localhost:5678/webhook-test/form-obra";

let form = document.getElementById("obraForm");
let status = document.getElementById("status");

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  // Detener grabación si está en curso
  if (window.AudioDecoder && window.AudioDecoder.isRecording()) {
    window.AudioDecoder.stopRecording();
    // Dar tiempo para procesar el audio
    await new Promise(resolve => setTimeout(resolve, 500));
  }

  // Mostrar estado de carga
  status.textContent = "⏳ Enviando informe...";
  const submitButton = form.querySelector('button[type="submit"]');
  submitButton.disabled = true;

  // 1. Convertir el formulario en objeto plano
  let data = Object.fromEntries(new FormData(form).entries());

  // 2. Enviar JSON al webhook
  try {
    let res = await fetch(WEBHOOK_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });

    if (res.ok) {
      status.textContent = "✅ Informe enviado correctamente";
      form.reset();
      // Limpiar la grabación
      if (window.AudioDecoder) {
        window.AudioDecoder.clearRecording();
      }
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