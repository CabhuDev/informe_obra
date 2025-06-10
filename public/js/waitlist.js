// Waitlist Form - Optimized & Consistent with script.js
// Obratec Sistema de Informes de Obra

console.log("🚀 Waitlist Form Script Loaded");

const WEBHOOK_URL = (() => {
  const hostname = window.location.hostname;
  
  if (hostname === 'localhost' || hostname === '127.0.0.1') {
    // Desarrollo local - waitlist webhook
    return "https://n8n.obratec.app/webhook-test/wait-list";
  } else {
    // Producción - waitlist webhook
    return "https://obratec.app/webhook/wait-list";
  }
})();

console.log("🔗 Waitlist Webhook URL:", WEBHOOK_URL);

// Variables globales
let form = document.getElementById("waitlistForm");
let status = document.getElementById("status");
let submitBtn = document.getElementById("submitBtn");

// Verificar elementos del DOM
if (!form) {
  console.error("❌ Waitlist form not found (ID: waitlistForm)");
} else if (!submitBtn) {
  console.error("❌ Submit button not found (ID: submitBtn)");
} else {
  console.log("✅ Waitlist form elements found");

  // Event listener principal del formulario
  form.addEventListener("submit", async (e) => {
    e.preventDefault();

    console.log("📝 Starting form submission");

    // Validar campos requeridos
    const requiredFields = Array.from(form.querySelectorAll('[required]'));
    const isValid = requiredFields.every(field => {
      const valid = field.checkValidity() && field.value.trim() !== '';
      field.style.borderColor = valid ? 'var(--success-color)' : 'var(--del-color)';
      return valid;
    });

    if (!isValid) {
      console.log("❌ Form validation failed");
      showMessage('Completa todos los campos requeridos', 'error');
      return;
    }

    // Mostrar estado de carga
    if (status) status.textContent = "⏳ Registrando...";
    updateButton('loading');
    submitBtn.disabled = true;

    try {
      // Preparar datos del formulario
      const formData = new FormData(form);
      
      // Log form data for debugging
      console.log("📤 Form data prepared:");
      for (let [key, value] of formData.entries()) {
        console.log(`  ${key}: ${value}`);
      }
      
      console.log("🌐 Sending to webhook:", WEBHOOK_URL);

      // Enviar con timeout
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 10000);

      let res = await fetch(WEBHOOK_URL, {
        method: "POST",
        body: formData,
        signal: controller.signal
      });

      clearTimeout(timeoutId);
      
      console.log("📡 Response status:", res.status);

      if (res.ok) {
        console.log("✅ Form submitted successfully");
        if (status) status.textContent = "✅ ¡Registrado correctamente!";
        updateButton('success');
        showMessage('¡Registrado! Te contactaremos pronto.', 'success');
        
        setTimeout(() => {
          form.reset();
          updateButton('default');
          clearAllErrors();
          if (status) status.textContent = "";
          console.log("🔄 Form reset completed");
        }, 3000);
      } else {
        const errorText = await res.text().catch(() => 'Unknown error');
        console.error("❌ Server error:", res.status, errorText);
        throw new Error(`Server error ${res.status}`);
      }
    } catch (err) {
      console.error("❌ Form submission error:", err);
      
      let errorMessage = "❌ Error al registrar";
      if (err.name === 'AbortError') {
        errorMessage = "❌ Tiempo de espera agotado";
      } else if (!navigator.onLine) {
        errorMessage = "❌ Sin conexión a internet";
      }
      
      if (status) status.textContent = errorMessage;
      updateButton('error');
      showMessage('Error al enviar. Intenta nuevamente.', 'error');
      
      setTimeout(() => {
        updateButton('default');
        if (status) status.textContent = "";
      }, 3000);
    } finally {
      submitBtn.disabled = false;
    }
  });

  // Formateo de teléfono en tiempo real
  const phoneField = form.querySelector('input[name="telefono"]');
  if (phoneField) {
    phoneField.addEventListener('input', (e) => {
      let value = e.target.value.replace(/\D/g, '');
      if (value.length <= 3) {
        e.target.value = value;
      } else if (value.length <= 6) {
        e.target.value = value.slice(0, 3) + '-' + value.slice(3);
      } else {
        e.target.value = value.slice(0, 3) + '-' + value.slice(3, 6) + '-' + value.slice(6, 10);
      }
    });
  }

  // Validación en tiempo real
  form.querySelectorAll('input[required]').forEach(field => {
    field.addEventListener('blur', () => {
      const isValid = field.checkValidity() && field.value.trim() !== '';
      field.style.borderColor = isValid ? 'var(--success-color)' : 'var(--del-color)';
    });
    
    field.addEventListener('input', () => {
      field.style.borderColor = 'var(--muted-border-color)';
    });
  });
}

// Funciones auxiliares
function updateButton(state) {
  if (!submitBtn) return;
  
  const texts = {
    loading: '<img src="/assets/enviando-informe.svg" width="20" height="20" style="margin-right: 8px; vertical-align: middle;"> Enviando...',
    success: '✅ ¡Registrado!',
    error: '❌ Error - Reintentar',
    default: '🚀 Unirme a la Lista de Espera'
  };
  
  submitBtn.innerHTML = texts[state];
  submitBtn.disabled = state === 'loading' || state === 'success';
}

function showMessage(message, type) {
  if (!form) return;
  
  const existingMessage = document.querySelector('.form-message');
  if (existingMessage) existingMessage.remove();

  const messageDiv = document.createElement('div');
  messageDiv.className = `form-message ${type}`;
  messageDiv.textContent = message;
  messageDiv.style.cssText = `
    padding: 1rem; margin: 1rem 0; border-radius: 8px;
    text-align: center; font-weight: 500;
    background: ${type === 'success' ? 'var(--success-color)' : 'var(--del-color)'};
    color: white;
  `;
  
  form.appendChild(messageDiv);
  setTimeout(() => messageDiv.remove(), 5000);
}

function clearAllErrors() {
  if (!form) return;
  form.querySelectorAll('input').forEach(field => {
    field.style.borderColor = 'var(--muted-border-color)';
  });
}

console.log("✅ Waitlist Form initialized with script.js pattern");
