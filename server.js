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

// MIDDLEWARE DE SEGURIDAD - BLOQUEAR ACCESO A UI DE N8N
const blockN8NUI = (req, res, next) => {
  const blockedPaths = [
    '/n8n/',
    '/n8n',
    '/editor',
    '/editor/',
    '/workflows',
    '/workflows/',
    '/credentials',
    '/credentials/',
    '/executions',
    '/executions/',
    '/settings',
    '/settings/'
  ];
  
  // Verificar si la ruta está bloqueada
  const isBlocked = blockedPaths.some(path => req.originalUrl.startsWith(path));
  
  if (isBlocked) {
    console.warn(`🚫 BLOCKED ACCESS to N8N UI: ${req.originalUrl} from IP: ${req.ip}`);
    return res.status(403).json({
      error: 'Access Forbidden',
      message: 'El acceso a la interfaz de administración está bloqueado',
      timestamp: new Date().toISOString()
    });
  }
  
  next();
};

// Aplicar middleware de bloqueo
app.use(blockN8NUI);

// Proxy específico SOLO para webhooks (rutas permitidas)
const webhookProxy = createProxyMiddleware({
  target: 'http://obratec-n8n:5678',
  changeOrigin: true,
  pathRewrite: {
    '^/webhook': '/webhook', // Mantener webhook tal como está
  },
  headers: {
    'X-Forwarded-Proto': 'https',
    'X-Forwarded-Host': 'obratec.app',
    'X-Forwarded-For': 'obratec.app'
  },
  onError: (err, req, res) => {
    console.error('Webhook Proxy Error:', err.message);
    res.status(502).json({ 
      error: 'Webhook service unavailable',
      message: 'El servicio de webhook no está disponible' 
    });
  },
  onProxyReq: (proxyReq, req, res) => {
    console.log('✅ Webhook allowed:', req.method, req.url);
  }
});

// Proxy RESTRINGIDO para OAuth (solo para credenciales Google)
const restrictedOAuthProxy = createProxyMiddleware({
  target: 'http://obratec-n8n:5678',
  changeOrigin: true,
  pathRewrite: {
    '^/rest': '/rest',
  },
  headers: {
    'X-Forwarded-Proto': 'https',
    'X-Forwarded-Host': 'n8n.obratec.app'
  },
  onError: (err, req, res) => {
    console.error('OAuth Proxy Error:', err.message);
    res.status(502).json({ 
      error: 'OAuth service unavailable',
      message: 'El servicio de autenticación no está disponible' 
    });
  },
  onProxyReq: (proxyReq, req, res) => {
    console.log('🔐 OAuth request:', req.method, req.url);
  }
});

// Aplicar proxies SOLO para rutas específicas y necesarias
app.use('/webhook', webhookProxy);
app.use('/rest/oauth2-credential/callback', restrictedOAuthProxy);

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
