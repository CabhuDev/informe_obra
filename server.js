const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware de seguridad y optimización
app.use(helmet({
  contentSecurityPolicy: false // Permitir scripts externos para CDNs
}));
app.use(compression());
app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Servir archivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    service: 'Informe de Obra Frontend',
    domain: 'obratec.app'
  });
});

// Proxy para N8N - rutas /n8n/ y /webhook/
const n8nProxy = createProxyMiddleware({
  target: 'http://localhost:5678',
  changeOrigin: true,
  pathRewrite: {
    '^/n8n': '', // /n8n/path -> /path
  },
  onError: (err, req, res) => {
    console.error('N8N Proxy Error:', err.message);
    res.status(502).json({ 
      error: 'N8N service unavailable',
      message: 'El servicio de automatización no está disponible' 
    });
  },
  onProxyReq: (proxyReq, req, res) => {
    console.log('Proxying to N8N:', req.method, req.url);
  }
});

// Aplicar proxy para rutas específicas
app.use('/n8n', n8nProxy);
app.use('/webhook', n8nProxy);

// Ruta principal - servir index.html
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Manejar rutas no encontradas
app.use('*', (req, res) => {
  if (req.originalUrl.startsWith('/api/')) {
    res.status(404).json({ error: 'API endpoint not found' });
  } else {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
  }
});

// Manejo de errores global
app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  res.status(500).json({ 
    error: 'Internal Server Error',
    message: 'Ha ocurrido un error interno del servidor'
  });
});

// Iniciar servidor
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Frontend server running on port ${PORT}`);
  console.log(`🌐 Application: http://localhost:${PORT}`);
  console.log(`⚙️ N8N Proxy: http://localhost:${PORT}/n8n/`);
  console.log(`🔗 Webhook Proxy: http://localhost:${PORT}/webhook/`);
  console.log(`💊 Health Check: http://localhost:${PORT}/health`);
});

module.exports = app;
