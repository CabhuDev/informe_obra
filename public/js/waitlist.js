// Waitlist Form - Simple Version
// Obratec Sistema de Informes de Obra

/* URL del webhook - detecta automáticamente el entorno */
const WEBHOOK_URL = (() => {
  const hostname = window.location.hostname;
  const protocol = window.location.protocol;
  
  if (hostname === 'localhost' || hostname === '127.0.0.1') {
    // Desarrollo local - waitlist webhook
    return "http://localhost:5678/webhook-test/wait-list";
  } else {
    // Producción - n8n waitlist
    return "https://n8n.obratec.app/webhook-test/wait-list";
  }
})();

class WaitlistForm {
    constructor() {
        this.form = null;
        this.submitBtn = null;
        this.isSubmitting = false;
        this.init();
    }

    init() {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.setup());
        } else {
            this.setup();
        }
    }    setup() {
        console.log('🔧 Inicializando formulario waitlist...');
        this.form = document.getElementById('waitlistForm');
        this.submitBtn = document.getElementById('submitBtn');
        
        console.log('📋 Formulario encontrado:', !!this.form);
        console.log('🔘 Botón encontrado:', !!this.submitBtn);
        
        if (!this.form || !this.submitBtn) {
            console.error('❌ Error: No se encontró el formulario o botón');
            return;
        }
        
        this.bindEvents();
        console.log('✅ Eventos vinculados correctamente');
    }    bindEvents() {
        console.log('🔗 Vinculando eventos...');
        this.form.addEventListener('submit', (e) => {
            console.log('📤 Submit detectado!');
            this.handleSubmit(e);
        });
        
        // Formateo de teléfono
        const phoneField = this.form.querySelector('input[name="telefono"]');
        if (phoneField) {
            phoneField.addEventListener('input', (e) => this.formatPhone(e.target));
        }
        
        // Validación en tiempo real
        this.form.querySelectorAll('input[required]').forEach(field => {
            field.addEventListener('blur', () => this.validateField(field));
            field.addEventListener('input', () => this.clearError(field));
        });
    }    validateField(field) {
        const isValid = field.checkValidity() && field.value.trim() !== '';
        field.style.borderColor = isValid ? 'var(--success-color)' : 'var(--del-color)';
        return isValid;
    }

    formatPhone(phoneField) {
        let value = phoneField.value.replace(/\D/g, '');
        if (value.length <= 3) {
            phoneField.value = value;
        } else if (value.length <= 6) {
            phoneField.value = value.slice(0, 3) + '-' + value.slice(3);
        } else {
            phoneField.value = value.slice(0, 3) + '-' + value.slice(3, 6) + '-' + value.slice(6, 10);
        }
    }

    clearError(field) {
        field.style.borderColor = 'var(--muted-border-color)';
        const errorMsg = field.parentNode.querySelector('.error-message');
        if (errorMsg) errorMsg.remove();
    }

    showMessage(message, type) {
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
        
        this.form.appendChild(messageDiv);
        setTimeout(() => messageDiv.remove(), 5000);
    }    async handleSubmit(e) {
        console.log('🚀 handleSubmit iniciado');
        e.preventDefault();
        
        if (this.isSubmitting) return;
          // Validar formulario
        const requiredFields = Array.from(this.form.querySelectorAll('[required]'));
        const isValid = requiredFields.every(field => this.validateField(field));
        if (!isValid) {
            this.showMessage('Completa todos los campos requeridos', 'error');
            return;
        }
        
        this.isSubmitting = true;
        this.updateButton('loading');
          try {
            // Preparar datos del formulario (igual que en script.js)
            const formData = new FormData(this.form);
            
            console.log("📤 Enviando datos a:", WEBHOOK_URL);
            
            // Enviar al webhook de n8n (mismo patrón que script.js)
            const response = await fetch(WEBHOOK_URL, {
                method: 'POST',
                body: formData
            });
            
            if (response.ok) {
                this.updateButton('success');
                this.showMessage('¡Registrado! Te contactaremos pronto.', 'success');
                setTimeout(() => {
                    this.form.reset();
                    this.updateButton('default');
                    this.clearAllErrors();
                }, 3000);
            } else {
                throw new Error(`Error ${response.status}: ${response.statusText}`);
            }
        } catch (error) {
            console.error('Error al enviar formulario:', error);
            this.updateButton('error');
            this.showMessage('Error al enviar. Intenta nuevamente.', 'error');
            setTimeout(() => this.updateButton('default'), 3000);
        } finally {
            this.isSubmitting = false;
        }
    }    updateButton(state) {
        const texts = {
            loading: '<img src="../assets/enviando-informe.svg" width="20" height="20" style="margin-right: 8px; vertical-align: middle;"> Enviando...',
            success: '✅ ¡Registrado!',
            error: '❌ Error - Reintentar',
            default: '🚀 Unirme a la Lista de Espera'
        };
        
        this.submitBtn.innerHTML = texts[state];
        this.submitBtn.disabled = state === 'loading' || state === 'success';
    }

    clearAllErrors() {
        this.form.querySelectorAll('input').forEach(field => this.clearError(field));
    }
}

// Inicializar
console.log('🎯 Archivo waitlist.js cargado');
new WaitlistForm();
