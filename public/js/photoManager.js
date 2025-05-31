
/**
 * GESTOR DE FOTOS PARA FORMULARIO DE INFORMES DE OBRA
 * ===================================================
 * 
 * Esta clase maneja todas las funcionalidades relacionadas con fotos en el formulario:
 * - Captura de fotos desde la cámara (móvil/desktop)
 * - Carga de fotos desde archivos
 * - Comentarios de texto por foto
 * - Grabación de comentarios de voz por foto
 * - Eliminación y gestión de fotos
 * - Preparación de datos para envío al servidor
 * 
 * @author Sistema de Informes de Obra
 * @version 2.0 - Sin dependencia de PicoCSS
 */
class PhotoManager {
  /**
   * Constructor - Inicializa el gestor de fotos
   * Configura las propiedades básicas y inicia los event listeners
   */
  constructor() {
    this.photos = [];           // Array que almacena todas las fotos y sus datos
    this.maxPhotos = 5;         // Límite máximo de fotos permitidas
    this.currentPhotoId = 0;    // Contador para generar IDs únicos de fotos
    this.mediaRecorders = {};   // Objeto que almacena los MediaRecorder activos por foto
    this.init();                // Inicializar event listeners
  }
  /**
   * Inicializa la clase y configura los event listeners
   */
  init() {
    this.bindEvents();
  }

  /**
   * Configura todos los event listeners para los botones de foto
   * - Botón "Tomar foto": activa la cámara del dispositivo
   * - Botón "Subir foto": abre el selector de archivos
   * - Input de archivo: maneja la selección de archivos
   */
  bindEvents() {
    const takePhotoBtn = document.getElementById('takePhoto');
    const uploadPhotoBtn = document.getElementById('uploadPhoto');
    const photoInput = document.getElementById('photoInput');

    // Event listener para tomar foto con cámara
    takePhotoBtn.addEventListener('click', () => this.capturePhoto());
    
    // Event listener para subir foto desde archivos
    uploadPhotoBtn.addEventListener('click', () => photoInput.click());
    
    // Event listener para cuando se seleccionan archivos
    photoInput.addEventListener('change', (e) => this.handleFileSelect(e));
  }

  /**
   * Activa la cámara del dispositivo para tomar una foto
   * En móviles, usa la cámara trasera por defecto (environment)
   */
  capturePhoto() {
    // Para móvil: usar capture="environment" directamente
    const photoInput = document.getElementById('photoInput');
    photoInput.setAttribute('capture', 'environment');
    photoInput.click();
  }
  /**
   * Maneja la selección de archivos desde el input file
   * Procesa múltiples archivos y valida que sean imágenes
   * @param {Event} event - Evento del input file
   */
  handleFileSelect(event) {
    const files = event.target.files;
    
    // Procesar cada archivo seleccionado
    for (let file of files) {
      // Verificar límite máximo de fotos
      if (this.photos.length >= this.maxPhotos) {
        alert(`Máximo ${this.maxPhotos} fotos permitidas`);
        break;
      }
      
      // Verificar que sea un archivo de imagen
      if (file && file.type.startsWith('image/')) {
        this.addPhoto(file);
      }
    }
    
    // Limpiar el input para permitir seleccionar la misma foto de nuevo
    event.target.value = '';
  }

  /**
   * Añade una nueva foto al array y la renderiza en el DOM
   * @param {File} file - Archivo de imagen seleccionado
   */
  addPhoto(file) {
    const photoId = ++this.currentPhotoId;  // Generar ID único
    const reader = new FileReader();        // Para convertir archivo a base64
    
    // Cuando el archivo se ha leído completamente
    reader.onload = (e) => {
      // Crear objeto foto con toda la información
      const photo = {
        id: photoId,                    // ID único de la foto
        file: file,                     // Archivo original
        dataUrl: e.target.result,       // Imagen en formato base64
        textComment: '',                // Comentario de texto (inicialmente vacío)
        voiceComment: null,             // Comentario de voz (inicialmente null)
        voiceRecording: false           // Estado de grabación
      };
      
      // Añadir al array de fotos
      this.photos.push(photo);
      // Renderizar la foto en el DOM
      this.renderPhoto(photo);
      // Actualizar los campos ocultos del formulario
      this.updateFormData();
    };
    
    // Iniciar la lectura del archivo como data URL (base64)
    reader.readAsDataURL(file);
  }
  /**
   * Renderiza una foto en el DOM con todos sus controles
   * Crea la estructura HTML completa para mostrar la foto y sus funcionalidades
   * @param {Object} photo - Objeto foto con toda la información
   */
  renderPhoto(photo) {
    const container = document.getElementById('photosContainer');
    
    // Crear elemento contenedor para la foto
    const photoElement = document.createElement('div');
    photoElement.className = 'photo-item';
    photoElement.dataset.photoId = photo.id;
    
    // Estructura HTML completa de la foto con controles
    photoElement.innerHTML = `
      <div class="photo-controls">
        <span class="photo-number">Foto ${this.photos.length}</span>
        <button type="button" class="delete-photo" onclick="photoManager.deletePhoto(${photo.id})">
          🗑️ Eliminar
        </button>
      </div>
      
      <img src="${photo.dataUrl}" alt="Foto ${photo.id}" class="photo-preview" />
      
      <div class="photo-comment">
        <label>Comentario de texto:</label>
        <textarea 
          placeholder="Describe lo que se ve en la foto..."
          onchange="photoManager.updateTextComment(${photo.id}, this.value)"
          rows="2"
        ></textarea>
      </div>
      
      <div class="voice-comment">
        <label>Comentario de voz:</label>
        <div class="voice-controls">
          <button type="button" class="outline" onclick="photoManager.startVoiceRecording(${photo.id})">
            🎙️ Grabar
          </button>
          <button type="button" class="outline" onclick="photoManager.stopVoiceRecording(${photo.id})" disabled>
            ⏹️ Parar
          </button>
          <span class="recording-status"></span>
        </div>
        <audio class="voice-playback" controls style="display: none;"></audio>
      </div>
    `;
    
    // Añadir al contenedor de fotos
    container.appendChild(photoElement);
  }
  /**
   * Elimina una foto del sistema (array y DOM)
   * @param {number} photoId - ID de la foto a eliminar
   */
  deletePhoto(photoId) {
    // Eliminar del array de fotos
    this.photos = this.photos.filter(photo => photo.id !== photoId);
    
    // Eliminar el elemento del DOM
    const photoElement = document.querySelector(`[data-photo-id="${photoId}"]`);
    if (photoElement) {
      photoElement.remove();
    }
    
    // Actualizar numeración de fotos restantes
    this.updatePhotoNumbers();
    // Actualizar campos ocultos del formulario
    this.updateFormData();
  }

  /**
   * Actualiza la numeración de las fotos después de eliminar una
   * Recorre todos los elementos de foto y actualiza el número mostrado
   */
  updatePhotoNumbers() {
    const photoItems = document.querySelectorAll('.photo-item');
    photoItems.forEach((item, index) => {
      const numberSpan = item.querySelector('.photo-number');
      if (numberSpan) {
        numberSpan.textContent = `Foto ${index + 1}`;
      }
    });
  }

  /**
   * Actualiza el comentario de texto de una foto específica
   * @param {number} photoId - ID de la foto
   * @param {string} comment - Nuevo comentario de texto
   */
  updateTextComment(photoId, comment) {
    const photo = this.photos.find(p => p.id === photoId);
    if (photo) {
      photo.textComment = comment;
      this.updateFormData();
    }
  }
  /**
   * Inicia la grabación de comentario de voz para una foto específica
   * Solicita permisos de micrófono y configura el MediaRecorder
   * @param {number} photoId - ID de la foto para la cual grabar audio
   */
  async startVoiceRecording(photoId) {
    try {
      // Solicitar acceso al micrófono del usuario
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      
      // Crear un MediaRecorder para grabar el audio
      const mediaRecorder = new MediaRecorder(stream);
      const chunks = [];  // Array para almacenar los chunks de audio
      
      // Cuando hay datos disponibles, añadirlos al array
      mediaRecorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
          chunks.push(event.data);
        }
      };
      
      // Cuando la grabación termina, procesar el audio
      mediaRecorder.onstop = () => {
        // Crear blob con los chunks grabados
        const blob = new Blob(chunks, { type: 'audio/wav' });
        // Guardar el comentario de voz
        this.saveVoiceComment(photoId, blob);
        // Detener todas las pistas del stream (liberar micrófono)
        stream.getTracks().forEach(track => track.stop());
      };
      
      // Almacenar el MediaRecorder para poder detenerlo después
      this.mediaRecorders[photoId] = mediaRecorder;
      // Iniciar la grabación
      mediaRecorder.start();
      
      // Actualizar la interfaz de usuario
      this.updateRecordingUI(photoId, true);
      
    } catch (error) {
      console.error('Error accessing microphone:', error);
      alert('Error al acceder al micrófono. Verifica los permisos.');
    }
  }

  /**
   * Detiene la grabación de comentario de voz para una foto específica
   * @param {number} photoId - ID de la foto para la cual detener la grabación
   */
  stopVoiceRecording(photoId) {
    const mediaRecorder = this.mediaRecorders[photoId];
    if (mediaRecorder && mediaRecorder.state === 'recording') {
      mediaRecorder.stop();                           // Detener grabación
      delete this.mediaRecorders[photoId];            // Limpiar referencia
      this.updateRecordingUI(photoId, false);         // Actualizar UI
    }
  }

  /**
   * Actualiza la interfaz de usuario durante la grabación
   * Habilita/deshabilita botones y muestra el estado de grabación
   * @param {number} photoId - ID de la foto
   * @param {boolean} isRecording - Si está grabando o no
   */
  updateRecordingUI(photoId, isRecording) {
    const photoElement = document.querySelector(`[data-photo-id="${photoId}"]`);
    if (!photoElement) return;
    
    // Obtener elementos de la interfaz
    const startBtn = photoElement.querySelector('.voice-controls button:first-child');
    const stopBtn = photoElement.querySelector('.voice-controls button:nth-child(2)');
    const status = photoElement.querySelector('.recording-status');
    
    if (isRecording) {
      // Estado: grabando
      startBtn.disabled = true;                       // Deshabilitar botón iniciar
      stopBtn.disabled = false;                       // Habilitar botón parar
      status.textContent = '🔴 Grabando...';          // Mostrar estado
      status.className = 'recording-indicator';       // Aplicar animación CSS
    } else {
      // Estado: no grabando
      startBtn.disabled = false;                      // Habilitar botón iniciar
      stopBtn.disabled = true;                        // Deshabilitar botón parar
      status.textContent = '';                        // Limpiar estado
      status.className = 'recording-status';          // Quitar animación
    }
  }
  /**
   * Guarda el comentario de voz grabado en el objeto foto
   * Convierte el blob de audio a base64 para su almacenamiento
   * @param {number} photoId - ID de la foto
   * @param {Blob} blob - Blob de audio grabado
   */
  saveVoiceComment(photoId, blob) {
    const photo = this.photos.find(p => p.id === photoId);
    if (!photo) return;
    
    // Usar FileReader para convertir blob a base64
    const reader = new FileReader();
    reader.onload = () => {
      // Guardar el audio como base64 en el objeto foto
      photo.voiceComment = reader.result;
      // Actualizar campos ocultos del formulario
      this.updateFormData();
      // Mostrar reproductor de audio en la interfaz
      this.showVoicePlayback(photoId, reader.result);
    };
    reader.readAsDataURL(blob);
  }

  /**
   * Muestra el reproductor de audio para un comentario de voz
   * @param {number} photoId - ID de la foto
   * @param {string} audioDataUrl - URL base64 del audio
   */
  showVoicePlayback(photoId, audioDataUrl) {
    const photoElement = document.querySelector(`[data-photo-id="${photoId}"]`);
    if (!photoElement) return;
    
    // Encontrar el elemento audio y configurarlo
    const audioElement = photoElement.querySelector('.voice-playback');
    audioElement.src = audioDataUrl;
    audioElement.style.display = 'block';  // Hacer visible el reproductor
  }

  /**
   * Actualiza los campos ocultos del formulario con los datos de las fotos
   * Crea inputs hidden para enviar todas las fotos y sus comentarios al servidor
   */
  updateFormData() {
    // Limpiar inputs previos para evitar duplicados
    this.clearPreviousPhotoInputs();
    
    // Crear inputs ocultos para cada foto
    this.photos.forEach((photo, index) => {
      // Crear input para la imagen (base64)
      const imageInput = document.createElement('input');
      imageInput.type = 'hidden';
      imageInput.name = `photo_${index}_image`;
      imageInput.value = photo.dataUrl;
      
      // Crear input para el comentario de texto
      const textInput = document.createElement('input');
      textInput.type = 'hidden';
      textInput.name = `photo_${index}_text`;
      textInput.value = photo.textComment;
      
      // Crear input para el comentario de voz (base64)
      const voiceInput = document.createElement('input');
      voiceInput.type = 'hidden';
      voiceInput.name = `photo_${index}_voice`;
      voiceInput.value = photo.voiceComment || '';
      
      // Añadir todos los inputs al formulario
      const form = document.getElementById('obraForm');
      form.appendChild(imageInput);
      form.appendChild(textInput);
      form.appendChild(voiceInput);
    });
    
    // Añadir contador total de fotos
    const countInput = document.createElement('input');
    countInput.type = 'hidden';
    countInput.name = 'photos_count';
    countInput.value = this.photos.length;
    document.getElementById('obraForm').appendChild(countInput);
  }

  /**
   * Elimina los inputs de fotos previos del formulario
   * Previene duplicación de datos al actualizar
   */
  clearPreviousPhotoInputs() {
    const form = document.getElementById('obraForm');
    const photoInputs = form.querySelectorAll('input[name^="photo_"], input[name="photos_count"]');
    photoInputs.forEach(input => input.remove());
  }

  /**
   * Obtiene los datos de todas las fotos en formato simplificado
   * Útil para exportar o procesar los datos de fotos
   * @returns {Array} Array de objetos con datos de fotos
   */
  getPhotosData() {
    return this.photos.map(photo => ({
      image: photo.dataUrl,           // Imagen en base64
      textComment: photo.textComment, // Comentario de texto
      voiceComment: photo.voiceComment // Comentario de voz en base64
    }));
  }
}

/**
 * INICIALIZACION DEL GESTOR DE FOTOS
 * ==================================
 * 
 * Se ejecuta cuando se carga completamente el DOM.
 * Crea una instancia global del PhotoManager para ser usada
 * en los event handlers inline del HTML.
 */

// Variable global para el gestor de fotos
let photoManager;

// Inicializar cuando se carga la página
document.addEventListener('DOMContentLoaded', () => {
  photoManager = new PhotoManager();
  console.log('PhotoManager inicializado correctamente');
});
