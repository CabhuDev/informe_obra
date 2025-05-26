/* Cambia SOLAMENTE esta línea por la URL de tu webhook */
const WEBHOOK_URL = "http://localhost:5678/webhook-test/form-obra";

let form = document.getElementById("obraForm");
let status = document.getElementById("status");
let audioCapture = document.getElementById("audioCapture");
let audioPlayback = document.getElementById("audioPlayback");

// Mostrar vista previa del audio cuando se seleccione un archivo
audioCapture.addEventListener("change", function() {
  if (this.files && this.files[0]) {
    audioPlayback.src = URL.createObjectURL(this.files[0]);
    audioPlayback.style.display = "block";
  }
});

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
      body: formData // No se establece Content-Type para que el navegador lo haga automáticamente
    });

    if (res.ok) {
      status.textContent = "✅ Informe enviado correctamente";
      form.reset();
      audioPlayback.style.display = "none";
      audioPlayback.src = "";
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