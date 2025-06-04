// Obtener los datos de fotos del webhook
let photosString = $input.first().json.body.photos;
let photosArray = [];

// Parsear el JSON string a array
try {
  photosArray = photosString ? JSON.parse(photosString) : [];
} catch (error) {
  console.log('Error parseando fotos:', error);
  photosArray = [];
}

// Generar HTML para cada foto
let photosHtml = '';

if (photosArray.length > 0) {
  photosHtml = photosArray.map((photo, index) => {
    return `
      <div class="photo-item">
        <img src="${photo.image}" alt="Foto ${index + 1}">
        <div class="photo-info">
          <h4>📷 Foto ${index + 1}</h4>
          ${photo.textComment && photo.textComment.trim() !== '' ? `
            <p><strong>📄 Comentario:</strong> ${photo.textComment}</p>
          ` : `
            <p><em>Sin comentario de texto</em></p>
          `}
          ${photo.voiceComment && photo.voiceComment.trim() !== '' ? `
            <p class="voice-indicator">🎙️ <em>Incluye comentario de voz</em></p>
          ` : ''}
        </div>
      </div>
    `;
  }).join('');
} else {
  photosHtml = `
    <div class="no-photos">
      <p>📷 No se adjuntaron fotos a este informe.</p>
    </div>
  `;
}

// Retornar todos los datos originales + los datos procesados de fotos
return {
  json: {
    // Mantener todos los datos originales del formulario
    //...item.json,
    
    // Agregar datos procesados de fotos
    photos: photosArray,
    totalPhotos: photosArray.length,
    photosHtml: photosHtml,
    
    // Estadísticas útiles
    photosWithComments: photosArray.filter(p => p.textComment && p.textComment.trim() !== '').length,
    photosWithVoice: photosArray.filter(p => p.voiceComment && p.voiceComment.trim() !== '').length
  }
};