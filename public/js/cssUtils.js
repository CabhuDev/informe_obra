/* ================================================================
   CSS UTILITIES FOR FORM-REPORT ENHANCED
   ================================================================
   Helper functions to replace inline style.display manipulation
   ================================================================ */

// Utility functions for enhanced CSS class management
const CSSUtils = {
    // Show element by removing hidden classes and adding visible classes
    show: function(element, type = 'block') {
        if (!element) return;
        
        // Remove all hidden classes
        element.classList.remove('hidden', 'hidden-input', 'camera-modal-hidden', 
                                 'audio-playback-hidden', 'audio-visualizer-hidden', 
                                 'loading-container-hidden');
        
        // Add appropriate visible class based on type
        switch(type) {
            case 'flex':
                element.classList.add('camera-modal-visible');
                break;
            case 'audio':
                element.classList.add('audio-playback-visible');
                break;
            case 'visualizer':
                element.classList.add('audio-visualizer-visible');
                break;
            case 'loading':
                element.classList.add('loading-container-visible');
                break;
            default:
                // For basic block display, just remove hidden classes
                element.style.display = type;
        }
    },
    
    // Hide element by adding appropriate hidden class
    hide: function(element, type = 'default') {
        if (!element) return;
        
        // Remove all visible classes first
        element.classList.remove('camera-modal-visible', 'audio-playback-visible', 
                                 'audio-visualizer-visible', 'loading-container-visible');
        
        // Add appropriate hidden class based on type
        switch(type) {
            case 'input':
                element.classList.add('hidden-input');
                break;
            case 'camera':
                element.classList.add('camera-modal-hidden');
                break;
            case 'audio':
                element.classList.add('audio-playback-hidden');
                break;
            case 'visualizer':
                element.classList.add('audio-visualizer-hidden');
                break;
            case 'loading':
                element.classList.add('loading-container-hidden');
                break;
            default:
                element.classList.add('hidden');
        }
    },
    
    // Toggle visibility
    toggle: function(element, showType = 'block', hideType = 'default') {
        if (!element) return;
        
        const isVisible = !element.classList.contains('hidden') && 
                         !element.classList.contains('hidden-input') &&
                         !element.classList.contains('camera-modal-hidden') &&
                         !element.classList.contains('audio-playback-hidden') &&
                         !element.classList.contains('audio-visualizer-hidden') &&
                         !element.classList.contains('loading-container-hidden');
        
        if (isVisible) {
            this.hide(element, hideType);
        } else {
            this.show(element, showType);
        }
    },
    
    // Check if element is visible
    isVisible: function(element) {
        if (!element) return false;
        
        return !element.classList.contains('hidden') && 
               !element.classList.contains('hidden-input') &&
               !element.classList.contains('camera-modal-hidden') &&
               !element.classList.contains('audio-playback-hidden') &&
               !element.classList.contains('audio-visualizer-hidden') &&
               !element.classList.contains('loading-container-hidden');
    }
};

// Make it available globally
window.CSSUtils = CSSUtils;
