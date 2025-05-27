const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const path = require('path');

const app = express();
const PORT = process.env.APP_PORT || process.env.PORT || 10000;
const N8N_PORT = process.env.N8N_PORT || 5678;

console.log(`🔧 Configurando servidor en puerto ${PORT}`);
console.log(`🔗 N8N ejecutándose en puerto ${N8N_PORT}`);

// Configurar Express para servir archivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// Ruta principal - servir index.html
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Proxy para N8N - webhooks y API
app.use('/webhook', createProxyMiddleware({
    target: `http://127.0.0.1:${N8N_PORT}`,
    changeOrigin: true,
    ws: true,
    logLevel: 'info'
}));

app.use('/n8n', createProxyMiddleware({
    target: `http://127.0.0.1:${N8N_PORT}`,
    changeOrigin: true,
    ws: true,
    pathRewrite: {
        '^/n8n': ''
    },
    logLevel: 'info'
}));

app.listen(PORT, '0.0.0.0', () => {
    console.log(`🌐 Servidor principal corriendo en puerto ${PORT}`);
    console.log(`📍 Archivos estáticos: ${path.join(__dirname, 'public')}`);
    console.log(`🔗 Proxy N8N: http://127.0.0.1:${N8N_PORT}`);
});

module.exports = app;
