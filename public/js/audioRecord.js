/**
 * Grabación de audio para el formulario de informes de obra
 * Permite grabar, reproducir y enviar audio como parte del formulario
 */

// Referencias a elementos del DOM relacionados con audio
let startRecordingButton = document.getElementById("startRecording");
let stopRecordingButton = document.getElementById("stopRecording");
let recordingStatus = document.getElementById("recordingStatus");
let audioPlayback = document.getElementById("audioPlayback");
let audioData = document.getElementById("audioData");

// Variables para almacenar el estado de la grabación
let mediaRecorder;
let audioChunks = [];
let isRecording = false;

/**
 * Detecta información del navegador para debugging
 */
function getBrowserInfo() {
    const userAgent = navigator.userAgent;
    const isIOS = /iPad|iPhone|iPod/.test(userAgent) && !window.MSStream;
    const isSafari = /^((?!chrome|android).)*safari/i.test(userAgent);
    const isChrome = /Chrome/.test(userAgent) && /Google Inc/.test(navigator.vendor);
    const isFirefox = /Firefox/.test(userAgent);
    
    return {
        isIOS,
        isSafari,
        isChrome,
        isFirefox,
        userAgent
    };
}

// Verificar que el navegador soporte la API MediaRecorder
if (!navigator.mediaDevices || !window.MediaRecorder) {
    recordingStatus.textContent = "⚠️ Tu navegador no soporta grabación de audio";
    startRecordingButton.disabled = true;
} else {
    // Log información del navegador para debugging
    const browserInfo = getBrowserInfo();
    console.log('Información del navegador:', browserInfo);
    
    // Verificar formatos soportados
    console.log('Formatos de audio soportados:');
    const testTypes = [
        'audio/webm;codecs=opus',
        'audio/webm',
        'audio/mp4;codecs=mp4a.40.2',
        'audio/mp4',
        'audio/mpeg',
        'audio/wav'
    ];
    
    testTypes.forEach(type => {
        const supported = MediaRecorder.isTypeSupported ? MediaRecorder.isTypeSupported(type) : false;
        console.log(`  ${type}: ${supported ? '✅' : '❌'}`);
    });
    
    // Configurar event listeners para los botones
    startRecordingButton.addEventListener("click", startRecording);
    stopRecordingButton.addEventListener("click", stopRecording);
}

/**
 * Detecta el mejor formato de audio soportado por el navegador
 */
function getSupportedMimeType() {
    const types = [
        'audio/webm;codecs=opus',  // Chrome, Firefox
        'audio/webm',              // Chrome, Firefox fallback
        'audio/mp4;codecs=mp4a.40.2', // Safari iOS
        'audio/mp4',               // Safari iOS fallback
        'audio/mpeg',              // General fallback
        'audio/wav'                // Last resort
    ];
    
    for (let type of types) {
        if (MediaRecorder.isTypeSupported(type)) {
            console.log(`Usando formato de audio: ${type}`);
            return type;
        }
    }
    
    // Si ningún tipo específico funciona, usar default
    console.log('Usando formato por defecto');
    return '';
}

/**
 * Inicia la grabación de audio usando el micrófono
 */
async function startRecording() {
    try {
    // Solicitar permisos para acceder al micrófono
    const stream = await navigator.mediaDevices.getUserMedia({ 
        audio: true,
        video: false
    });
    
    // Actualizar UI
    recordingStatus.textContent = "📊 Grabando...";
    startRecordingButton.disabled = true;
    stopRecordingButton.disabled = false;
    audioPlayback.style.display = "none";
    isRecording = true;
    
    // Obtener el mejor formato soportado
    const mimeType = getSupportedMimeType();
    
    // Crear y configurar el grabador de medios
    const options = mimeType ? { mimeType } : {};
    mediaRecorder = new MediaRecorder(stream, options);
    audioChunks = [];
    
    // Recoger fragmentos de audio
    mediaRecorder.addEventListener("dataavailable", event => {
        if (event.data.size > 0) {
            audioChunks.push(event.data);
        }
    });
    
    // Cuando se completa la grabación
    mediaRecorder.addEventListener("stop", () => {
      // Crear un blob con todos los fragmentos de audio
        // Usar el tipo MIME detectado o un fallback
        const blobType = mimeType || 'audio/wav';
        const audioBlob = new Blob(audioChunks, { 
            type: blobType
        });
      
        // Crear URL para reproducir el audio
        const audioUrl = URL.createObjectURL(audioBlob);
        audioPlayback.src = audioUrl;
        audioPlayback.style.display = "block";
        
        // Convertir el blob a Base64 para enviarlo con el formulario
        const reader = new FileReader();
        reader.readAsDataURL(audioBlob);
        reader.onloadend = () => {
            // Extraer la parte Base64 (sin el prefijo de datos)
            const base64Audio = reader.result.split(',')[1];
            audioData.value = base64Audio;
            console.log(`Audio grabado y convertido a Base64 (${blobType})`);
        };
      
        // Detener acceso al micrófono
        stream.getTracks().forEach(track => track.stop());
    });
        
    // Iniciar la grabación
    mediaRecorder.start();
    console.log(`Grabación iniciada con formato: ${mimeType || 'default'}`);
    
  } catch (err) {
        console.error("Error al iniciar la grabación:", err);
        recordingStatus.textContent = "❌ Error: " + (err.message || "No se pudo acceder al micrófono");
        startRecordingButton.disabled = false;
  }
}

/**
 * Detiene la grabación en curso
 */
function stopRecording() {
    if (!isRecording || !mediaRecorder) {
        return;
  }
  
    try {
        mediaRecorder.stop();
        isRecording = false;
        
        recordingStatus.textContent = "✅ Grabación completada";
        startRecordingButton.disabled = false;
        stopRecordingButton.disabled = true;
        
        console.log("Grabación detenida");
    } catch (err) {
        console.error("Error al detener la grabación:", err);
        recordingStatus.textContent = "❌ Error al finalizar grabación";
    }
}

/**
 * Limpia la grabación actual
 */
function clearRecording() {
    audioPlayback.style.display = "none";
    audioPlayback.src = "";
    audioData.value = "";
    recordingStatus.textContent = "";
}

// Exportar funciones para uso desde otros scripts
window.AudioDecoder = {
    startRecording,
    stopRecording,
    clearRecording,
    isRecording: () => isRecording
};

// Log para verificar que el script se cargó correctamente
console.log("Módulo de grabación de audio inicializado");

console.log("Botones encontrados:", {
    startButton: !!startRecordingButton,
    stopButton: !!stopRecordingButton,
    audioPlayback: !!audioPlayback,
    audioData: !!audioData
});