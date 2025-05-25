/* Cambia SOLAMENTE esta línea por la URL de tu webhook */
const WEBHOOK_URL = "https://abcd1234.ngrok.io/webhook/obra-form";

const form   = document.getElementById("obraForm");
const status = document.getElementById("status");

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  // 1. Convertir el formulario en objeto plano
  const data = Object.fromEntries(new FormData(form).entries());

  // 2. Enviar JSON al webhook
  try {
    const res = await fetch(WEBHOOK_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });

    status.textContent = res.ok
      ? "✅ Informe enviado correctamente"
      : "❌ Error al enviar";

    if (res.ok) form.reset();
  } catch (err) {
    status.textContent = "❌ Error de red";
  }
});
