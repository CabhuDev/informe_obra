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

    console.log("📝 Starting premium form submission");

    // Premium loading state
    setLoadingState(true);

    // Validar campos requeridos con feedback premium
    const requiredFields = Array.from(form.querySelectorAll('[required]'));
    const isValid = requiredFields.every(field => validateFieldPremium(field));

    if (!isValid) {
      console.log("❌ Form validation failed");
      showMessage('Por favor, completa todos los campos requeridos correctamente', 'error');
      setLoadingState(false);
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
      
      console.log("📡 Response status:", res.status);      if (res.ok) {
        console.log("✅ Waitlist registration successful");
        if (status) status.textContent = "✅ ¡Registrado correctamente!";
        updateButton('success');
        showMessage('¡Registro exitoso! Te contactaremos pronto con novedades sobre Obratec.', 'success');
        
        // Premium success animation
        setTimeout(() => {
          showSuccessAnimation();
        }, 1500);
        
      } else {
        const errorText = await res.text().catch(() => 'Unknown error');
        console.error("❌ Server error:", res.status, errorText);
        throw new Error(`Server error ${res.status}`);
      }
    } catch (err) {
      console.error("❌ Error en registro waitlist:", err);
      
      let errorMessage = "❌ Error al registrar";
      if (err.name === 'AbortError') {
        errorMessage = "❌ Tiempo de espera agotado";
      } else if (!navigator.onLine) {
        errorMessage = "❌ Sin conexión a internet";
      }
      
      if (status) status.textContent = errorMessage;
      updateButton('error');
      showMessage('Hubo un error al procesar tu registro. Por favor, inténtalo de nuevo.', 'error');
      
      setTimeout(() => {
        updateButton('default');
        if (status) status.textContent = "";
      }, 3000);
    } finally {
      setLoadingState(false);
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

// Premium form validation with visual feedback
function validateFieldPremium(field) {
    const isValid = field.checkValidity() && field.value.trim() !== '';
    
    // Remove existing classes
    field.classList.remove('valid', 'invalid');
    
    // Add appropriate class
    if (field.value.trim() !== '') {
        field.classList.add(isValid ? 'valid' : 'invalid');
    }
    
    return isValid;
}

// Premium message display with animations
function showMessage(message, type = 'info', duration = 5000) {
    // Remove existing messages
    const existingMessages = document.querySelectorAll('.message');
    existingMessages.forEach(msg => msg.remove());
    
    // Create new message element
    const messageEl = document.createElement('div');
    messageEl.className = `message ${type}`;
    
    const icon = type === 'success' ? '✅' : type === 'error' ? '❌' : 'ℹ️';
    messageEl.innerHTML = `<span>${icon}</span><span>${message}</span>`;
    
    // Insert message
    const formContainer = document.querySelector('.form-container');
    if (formContainer) {
        formContainer.insertBefore(messageEl, formContainer.firstChild);
        
        // Auto remove after duration
        setTimeout(() => {
            if (messageEl.parentNode) {
                messageEl.style.animation = 'slideOutUp 0.3s ease forwards';
                setTimeout(() => messageEl.remove(), 300);
            }
        }, duration);
    }
}

// Premium loading states
function setLoadingState(isLoading) {
    if (isLoading) {
        submitBtn.classList.add('loading');
        submitBtn.disabled = true;
        submitBtn.textContent = '';
    } else {
        submitBtn.classList.remove('loading');
        submitBtn.disabled = false;
        submitBtn.innerHTML = '🚀 Unirme a la Lista de Espera';
    }
}

// Premium form progress indicator
function updateFormProgress() {
    const formData = new FormData(form);
    const requiredFields = form.querySelectorAll('[required]');
    let completedFields = 0;
    
    requiredFields.forEach(field => {
        if (field.value.trim() !== '') {
            completedFields++;
        }
    });
    
    const progress = (completedFields / requiredFields.length) * 100;
    
    let progressBar = document.querySelector('.form-progress');
    if (!progressBar) {
        progressBar = document.createElement('div');
        progressBar.className = 'form-progress';
        document.body.appendChild(progressBar);
    }
    
    progressBar.style.width = `${progress}%`;
    
    if (progress === 100) {
        setTimeout(() => {
            if (progressBar.parentNode) {
                progressBar.remove();
            }
        }, 2000);
    }
}

// Premium success animation
function showSuccessAnimation() {
    const formContainer = document.querySelector('.form-container');
    if (formContainer) {
        formContainer.innerHTML = `
            <div class="form-success" style="text-align: center; padding: 3rem;">
                <div class="success-checkmark">✓</div>
                <h2 style="color: var(--secondary); margin-bottom: 1rem;">¡Registro Exitoso! 🎉</h2>
                <p style="color: var(--gray-600); font-size: 1.1rem; line-height: 1.6; margin-bottom: 2rem;">
                    Te has registrado correctamente en la lista de espera de Obratec. 
                    Te contactaremos pronto con novedades sobre el lanzamiento.
                </p>
                <div style="background: var(--primary-light); padding: 1.5rem; border-radius: 12px; border-left: 4px solid var(--primary);">
                    <p style="color: var(--secondary); margin: 0; font-weight: 500;">
                        📧 Revisa tu email para confirmar tu registro<br>
                        🚀 Te notificaremos cuando esté disponible la beta
                    </p>
                </div>
                <a href="../pages/landing.html" style="display: inline-block; margin-top: 2rem; padding: 0.75rem 1.5rem; background: var(--primary); color: white; text-decoration: none; border-radius: 8px; font-weight: 600; transition: all 0.3s ease;">
                    ← Volver al inicio
                </a>
            </div>
        `;
    }
}

// Premium real-time validation
function initPremiumValidation() {
    const formControls = form.querySelectorAll('.form-control');
    
    formControls.forEach(field => {
        // Real-time validation on input
        field.addEventListener('input', () => {
            if (field.value.trim() !== '') {
                validateFieldPremium(field);
            } else {
                field.classList.remove('valid', 'invalid');
            }
            updateFormProgress();
        });
        
        // Validation on blur
        field.addEventListener('blur', () => {
            if (field.hasAttribute('required') && field.value.trim() !== '') {
                validateFieldPremium(field);
            }
        });
        
        // Remove validation states on focus
        field.addEventListener('focus', () => {
            field.classList.remove('invalid');
        });
    });
}

// Premium checkbox interactions
function initPremiumCheckboxes() {
    const checkboxContainers = document.querySelectorAll('.checkbox-container');
    
    checkboxContainers.forEach(container => {
        const links = container.querySelectorAll('a');
        // Solo necesitamos evitar que los enlaces marquen el checkbox y abrirlos en nueva pestaña
        links.forEach(link => {
            link.addEventListener('click', (e) => {
                e.stopPropagation();
                e.preventDefault();
                window.open(link.href, '_blank');
            });
        });
        // No es necesario ningún handler extra en el container si usamos <label>
    });
}

// Premium scroll effects
function initPremiumScrollEffects() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Observe elements for scroll animations
    const animatedElements = document.querySelectorAll('.benefit-card, .whatsapp-highlight, .social-proof');
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
}

// Premium tooltips
function initPremiumTooltips() {
    const tooltipElements = document.querySelectorAll('[data-tooltip]');
    tooltipElements.forEach(el => {
        el.classList.add('tooltip');
    });
}

// Initialize all premium features
document.addEventListener('DOMContentLoaded', () => {
    if (form) {
        initPremiumValidation();
        initPremiumCheckboxes();
        initPremiumScrollEffects();
        initPremiumTooltips();
        
        console.log('✨ Premium UI/UX enhancements initialized');
    }
});

// ================================================================
// END PREMIUM ENHANCEMENTS
// ================================================================

console.log("✅ Waitlist Form initialized with script.js pattern");
