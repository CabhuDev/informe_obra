// 📱 Optimizador de Imágenes Ultra-Compacto para N8N
class ImageOptimizer {
  constructor() { 
    [this.maxW, this.maxH, this.quality, this.maxSize] = [1920, 1080, 0.85, 5242880]; 
  }

  needsOptimization(f) { 
    return f.size > this.maxSize || !f.type.startsWith('image/jpeg') || !f.type; 
  }

  async processFile(file) {
    if (!this.needsOptimization(file)) return { file, optimized: false };
    
    const blob = await new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        
        // Calcular dimensiones
        let [w, h] = [img.width, img.height];
        if (w > this.maxW) [w, h] = [this.maxW, h * this.maxW / w];
        if (h > this.maxH) [w, h] = [w * this.maxH / h, this.maxH];
        
        canvas.width = w;
        canvas.height = h;
        ctx.drawImage(img, 0, 0, w, h);
        
        // Comprimir hasta target
        const compress = (q) => canvas.toBlob(b => 
          b && (b.size <= this.maxSize || q <= 0.3) ? resolve(b) : compress(q - 0.1)
        , 'image/jpeg', q);
        compress(this.quality);
      };
      img.onerror = () => reject(new Error('Formato no soportado'));
      img.src = URL.createObjectURL(file);
    });

    const result = new File([blob], file.name.replace(/\.[^.]+$/, '_opt.jpg'), {type: 'image/jpeg'});
    const reduction = ((file.size - result.size) / file.size * 100).toFixed(1);
    
    // Notificación simple
    if (reduction > 0) {
      const toast = Object.assign(document.createElement('div'), {
        innerHTML: `📱 Optimizada: ${reduction}% menor`,
        style: 'position:fixed;top:20px;right:20px;background:#d4edda;color:#155724;padding:12px;border-radius:8px;z-index:9999'
      });
      document.body.appendChild(toast);
      setTimeout(() => toast.remove(), 3000);
    }

    return { file: result, optimized: true, originalSize: file.size, finalSize: result.size };
  }

  showProcessingNotification(result) { /* Incluido en processFile */ }
}

window.heicConverter = new ImageOptimizer();
