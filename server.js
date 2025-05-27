const express = require('express');
const path = require('path');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();

// Configuración de seguridad y optimización
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'", "https://fonts.googleapis.com"],
      fontSrc: ["'self'", "https://fonts.gstatic.com"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", "https://api.openai.com"]
    }
  }
}));

app.use(compression()); // Compresión gzip
app.use(cors()); // CORS habilitado
app.use(express.json({ limit: '50mb' })); // Para archivos de audio grandes
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Servir archivos estáticos del frontend
app.use(express.static(path.join(__dirname, 'public'), {
  maxAge: '1d', // Cache de 1 día para archivos estáticos
  etag: true
}));

// Logging básico
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next();
});

// Proxy reverso para N8N - ACCESO A N8N A TRAVÉS DEL FRONTEND
app.use('/n8n', createProxyMiddleware({
  target: 'http://localhost:5678',
  changeOrigin: true,
  pathRewrite: {
    '^/n8n': '', // Elimina /n8n del path antes de enviar a N8N
  },
  onError: (err, req, res) => {
    console.error('Error del proxy N8N:', err.message);
    res.status(502).json({
      error: 'N8N no está disponible',
      message: 'El servicio N8N está iniciándose o no está funcionando'
    });
  },
  onProxyReq: (proxyReq, req, res) => {
    console.log(`Proxy N8N: ${req.method} ${req.path} -> http://localhost:5678${req.path.replace('/n8n', '')}`);
  }
}));

// Proxy para webhooks de N8N - ENDPOINTS DE WEBHOOK
app.use('/webhook', createProxyMiddleware({
  target: 'http://localhost:5678',
  changeOrigin: true,
  pathRewrite: {
    '^/webhook': '/webhook', // Mantiene /webhook en el path
  },
  onError: (err, req, res) => {
    console.error('Error del webhook N8N:', err.message);
    res.status(502).json({
      error: 'Webhook N8N no disponible',
      message: 'El servicio de webhooks N8N no está funcionando'
    });
  }
}));

// Ruta principal - formulario de informes
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Ruta para la página de confirmación
app.get('/success', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'templates', 'reportSent.html'));
});

// Health check para Render
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    service: 'informe-obra-app',
    version: '1.0.0'
  });
});

// Endpoint para verificar estado del webhook N8N
app.get('/webhook/status', (req, res) => {
  res.status(200).json({
    status: 'Webhook endpoint ready',
    n8n_endpoint: '/webhook/form-obra',
    timestamp: new Date().toISOString()
  });
});

// Manejo de errores 404
app.use((req, res) => {
  res.status(404).json({
    error: 'Ruta no encontrada',
    path: req.path,
    method: req.method
  });
});

// Manejo de errores globales
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    error: 'Error interno del servidor',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Error interno'
  });
});

// Puerto dinámico para Render
const PORT = process.env.PORT || 10000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`
🚀 Sistema de Informes de Obra iniciado correctamente
📡 Puerto: ${PORT}
🌐 Acceso: http://localhost:${PORT}
📊 Health check: http://localhost:${PORT}/health
🔗 Webhook status: http://localhost:${PORT}/webhook/status
⏰ Timestamp: ${new Date().toISOString()}
  `);
});

// Manejo de cierre graceful
process.on('SIGTERM', () => {
  console.log('🔄 Recibida señal SIGTERM, cerrando servidor...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('🔄 Recibida señal SIGINT, cerrando servidor...');
  process.exit(0);
});
