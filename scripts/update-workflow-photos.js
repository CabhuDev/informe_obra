// Script para actualizar el workflow de N8N con soporte de fotos
// Lee el template actualizado y reemplaza el contenido en el workflow

const fs = require('fs');
const path = require('path');

// Leer el template actualizado
const templatePath = path.join(__dirname, '..', 'public', 'templates', 'reportTemplate_gotenberg.html');
const templateContent = fs.readFileSync(templatePath, 'utf8');

// Leer el workflow actual
const workflowPath = path.join(__dirname, '..', 'n8n', 'workflows', 'informe_obra_n8n_workflow.json');
const workflow = JSON.parse(fs.readFileSync(workflowPath, 'utf8'));

// Función para escapar el HTML para JSON
function escapeForJson(html) {
  return html
    .replace(/\\/g, '\\\\')
    .replace(/"/g, '\\"')
    .replace(/\n/g, '\\n')
    .replace(/\r/g, '\\r')
    .replace(/\t/g, '\\t');
}

// HTML escapado para el JSON
const escapedHtml = escapeForJson(templateContent);

// Encontrar y actualizar los nodos HTML
workflow.nodes.forEach(node => {
  if (node.name === 'HTML1' || node.name === 'HTML2') {
    console.log(`Actualizando nodo: ${node.name}`);
    node.parameters.html = escapedHtml;
  }
});

// Guardar el workflow actualizado
fs.writeFileSync(workflowPath, JSON.stringify(workflow, null, 2));
console.log('✅ Workflow actualizado con soporte de fotos');
console.log('Los nodos HTML1 y HTML2 ahora incluyen la sección de fotos');
