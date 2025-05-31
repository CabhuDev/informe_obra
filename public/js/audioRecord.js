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
let audioVisualizerContainer = document.getElementById("audioVisualizerContainer");

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
    recordingStatus.textContent = "Grabando...";
    startRecordingButton.disabled = true;
    stopRecordingButton.disabled = false;
    audioPlayback.style.display = "none";
    
    // Mostrar visualizador de audio
    if (audioVisualizerContainer) {
        audioVisualizerContainer.style.display = "block";
        audioVisualizerContainer.classList.add("recording");
    }
    
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
    mediaRecorder.addEventListener("stop", async () => {
        // Crear un blob con todos los fragmentos de audio
        // Usar el tipo MIME detectado o un fallback
        const blobType = mimeType || 'audio/wav';
        const originalBlob = new Blob(audioChunks, { 
            type: blobType
        });
      
        // Crear URL para reproducir el audio
        const audioUrl = URL.createObjectURL(originalBlob);
        audioPlayback.src = audioUrl;
        audioPlayback.style.display = "block";
        
        // Convertir a WAV para compatibilidad con OpenAI Whisper
        try {
            const wavBlob = await convertToWav(originalBlob);
            
            // Convertir el blob WAV a Base64 para enviarlo con el formulario
            const reader = new FileReader();
            reader.readAsDataURL(wavBlob);
            reader.onloadend = () => {
                // Extraer la parte Base64 (sin el prefijo de datos)
                const base64Audio = reader.result.split(',')[1];
                audioData.value = base64Audio;
                console.log(`Audio convertido a WAV y codificado en Base64`);
            };
        } catch (error) {
            console.error('Error al convertir audio:', error);
            // Fallback: usar el audio original
            const reader = new FileReader();
            reader.readAsDataURL(originalBlob);
            reader.onloadend = () => {
                const base64Audio = reader.result.split(',')[1];
                audioData.value = base64Audio;
                console.log(`Audio original convertido a Base64 (${blobType})`);
            };
        }
      
        // Detener acceso al micrófono
        stream.getTracks().forEach(track => track.stop());
    });
        
    // Iniciar la grabación
    mediaRecorder.start();
    console.log(`Grabación iniciada con formato: ${mimeType || 'default'}`);
    
  } catch (err) {        console.error("Error al iniciar la grabación:", err);
        recordingStatus.textContent = "❌ Error: " + (err.message || "No se pudo acceder al micrófono");
        startRecordingButton.disabled = false;
        
        // Ocultar visualizador en caso de error
        if (audioVisualizerContainer) {
            audioVisualizerContainer.style.display = "none";
            audioVisualizerContainer.classList.remove("recording");
        }
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
        
        // Ocultar visualizador de audio
        if (audioVisualizerContainer) {
            audioVisualizerContainer.style.display = "none";
            audioVisualizerContainer.classList.remove("recording");
        }
        
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
    
    // Ocultar visualizador de audio
    if (audioVisualizerContainer) {
        audioVisualizerContainer.style.display = "none";
        audioVisualizerContainer.classList.remove("recording");
    }
}

// Exportar funciones para uso desde otros scripts
window.AudioDecoder = {
    startRecording,
    stopRecording,
    clearRecording,
    isRecording: () => isRecording
};

/**
 * Convierte un blob de audio a formato WAV
 * @param {Blob} audioBlob - El blob de audio a convertir
 * @returns {Promise<Blob>} - Blob de audio en formato WAV
 */
async function convertToWav(audioBlob) {
    return new Promise((resolve, reject) => {
        try {
            // Crear un contexto de audio
            const audioContext = new (window.AudioContext || window.webkitAudioContext)();
            
            // Crear un FileReader para leer el blob
            const reader = new FileReader();
            
            reader.onload = async function(e) {
                try {
                    // Decodificar el audio
                    const arrayBuffer = e.target.result;
                    const audioBuffer = await audioContext.decodeAudioData(arrayBuffer);
                    
                    // Crear buffer WAV
                    const wavBuffer = audioBufferToWav(audioBuffer);
                    const wavBlob = new Blob([wavBuffer], { type: 'audio/wav' });
                    
                    console.log('Audio convertido exitosamente a WAV');
                    resolve(wavBlob);
                } catch (decodeError) {
                    console.error('Error al decodificar audio:', decodeError);
                    reject(decodeError);
                }
            };
            
            reader.onerror = function(error) {
                console.error('Error al leer el blob de audio:', error);
                reject(error);
            };
            
            reader.readAsArrayBuffer(audioBlob);
        } catch (error) {
            console.error('Error en convertToWav:', error);
            reject(error);
        }
    });
}

/**
 * Convierte un AudioBuffer a formato WAV
 * @param {AudioBuffer} buffer - Buffer de audio a convertir
 * @returns {ArrayBuffer} - Buffer en formato WAV
 */
function audioBufferToWav(buffer) {
    const numberOfChannels = buffer.numberOfChannels;
    const length = buffer.length * numberOfChannels * 2 + 44;
    const arrayBuffer = new ArrayBuffer(length);
    const view = new DataView(arrayBuffer);
    const channels = [];
    let sample;
    let offset = 0;
    let pos = 0;

    // Escribir header WAV
    function setUint16(data) {
        view.setUint16(pos, data, true);
        pos += 2;
    }

    function setUint32(data) {
        view.setUint32(pos, data, true);
        pos += 4;
    }

    // Header RIFF
    setUint32(0x46464952); // "RIFF"
    setUint32(length - 8); // file length - 8
    setUint32(0x45564157); // "WAVE"

    // Subchunk 1
    setUint32(0x20746d66); // "fmt " chunk
    setUint32(16); // length = 16
    setUint16(1); // PCM (uncompressed)
    setUint16(numberOfChannels);
    setUint32(buffer.sampleRate);
    setUint32(buffer.sampleRate * 2 * numberOfChannels); // avg. bytes/sec
    setUint16(numberOfChannels * 2); // block-align
    setUint16(16); // 16-bit (hardcoded in this demo)

    // Subchunk 2
    setUint32(0x61746164); // "data" - chunk
    setUint32(length - pos - 4); // chunk length

    // Escribir datos de audio intercalados
    for (let i = 0; i < numberOfChannels; i++) {
        channels.push(buffer.getChannelData(i));
    }

    while (pos < length) {
        for (let i = 0; i < numberOfChannels; i++) {
            sample = Math.max(-1, Math.min(1, channels[i][offset])); // clamp
            sample = (0.5 + sample < 0 ? sample * 32768 : sample * 32767) | 0; // scale to 16-bit signed int
            view.setInt16(pos, sample, true); // write 16-bit sample
            pos += 2;
        }
        offset++; // next sample
    }

    return arrayBuffer;
}

// Log para verificar que el script se cargó correctamente
console.log("Módulo de grabación de audio inicializado");

console.log("Botones encontrados:", {
    startButton: !!startRecordingButton,
    stopButton: !!stopRecordingButton,
    audioPlayback: !!audioPlayback,
    audioData: !!audioData,
    audioVisualizer: !!audioVisualizerContainer
});