const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');

const app = express();
const PORT = process.env.APP_PORT || process.env.PORT || 10000;
const N8N_PORT = process.env.N8N_PORT || 5678;

console.log(`🔧 Configurando servidor en puerto ${PORT}`);
console.log(`🔗 N8N ejecutándose en puerto ${N8N_PORT}`);

// Middleware para parsing JSON
app.use(express.json());

// Configurar Express para servir archivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// Ruta principal - servir index.html
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Diagnóstico de N8N
app.get('/debug/n8n', async (req, res) => {
    try {
        const response = await fetch(`http://127.0.0.1:${N8N_PORT}/healthz`);
        const isHealthy = response.ok;
        
        res.json({
            n8n_status: isHealthy ? 'running' : 'not_responding',
            n8n_port: N8N_PORT,
            express_port: PORT,
            timestamp: new Date().toISOString(),
            webhook_url: `http://127.0.0.1:${N8N_PORT}/webhook/form-obra`
        });
    } catch (error) {
        res.json({
            n8n_status: 'error',
            error: error.message,
            n8n_port: N8N_PORT,
            express_port: PORT,
            timestamp: new Date().toISOString()
        });
    }
});

// Webhook de prueba directo (bypass N8N para testing)
app.post('/test-webhook', express.json(), (req, res) => {
    console.log('🧪 Test webhook recibido:', req.body);
    res.json({ 
        message: 'Webhook de prueba recibido correctamente',
        data: req.body,
        timestamp: new Date().toISOString()
    });
});

// Proxy para N8N - webhooks y API con manejo de errores
app.use('/webhook', createProxyMiddleware({
    target: `http://127.0.0.1:${N8N_PORT}`,
    changeOrigin: true,
    ws: true,
    logLevel: 'info',
    onError: (err, req, res) => {
        console.error('❌ Webhook proxy error:', err.message);
        res.status(503).json({ error: 'N8N service unavailable' });
    },
    onProxyReq: (proxyReq, req, res) => {
        console.log(`📤 Webhook request: ${req.method} ${req.url}`);
    }
}));

app.use('/n8n', createProxyMiddleware({
    target: `http://127.0.0.1:${N8N_PORT}`,
    changeOrigin: true,
    ws: true,
    pathRewrite: {
        '^/n8n': ''
    },
    logLevel: 'info',
    onError: (err, req, res) => {
        console.error('❌ N8N proxy error:', err.message);
        res.status(503).json({ error: 'N8N admin interface unavailable' });
    }
}));

app.listen(PORT, '0.0.0.0', () => {
    console.log(`🌐 Servidor principal corriendo en puerto ${PORT}`);
    console.log(`📍 Archivos estáticos: ${path.join(__dirname, 'public')}`);
    console.log(`🔗 Proxy N8N: http://127.0.0.1:${N8N_PORT}`);
});

module.exports = app;
