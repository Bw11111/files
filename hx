(function() {
  const shaderId = 'lsdCanvas';
  window.active = false;
  let renderer, scene, camera, mesh, uniforms, animationId;

  function startShader() {
    if (document.getElementById(shaderId)) return;

    const canvas = document.createElement('canvas');
    canvas.id = shaderId;
    canvas.style.position = 'fixed';
    canvas.style.top = '0';
    canvas.style.left = '0';
    canvas.style.width = '100vw';
    canvas.style.height = '100vh';
    canvas.style.zIndex = '9999';
    canvas.style.pointerEvents = 'none';
    canvas.style.mixBlendMode = 'screen';
    document.body.appendChild(canvas);

    import('https://cdn.skypack.dev/three@0.152.2').then(THREE => {
      scene = new THREE.Scene();
      camera = new THREE.Camera();
      renderer = new THREE.WebGLRenderer({ canvas, alpha: true });
      renderer.setSize(window.innerWidth, window.innerHeight);
      renderer.setClearColor(0x000000, 0);

      uniforms = {
        u_time: { value: 0.0 },
        u_resolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) }
      };

      const material = new THREE.ShaderMaterial({
        uniforms: uniforms,
        transparent: true,
        fragmentShader: `
          uniform float u_time;
uniform vec2 u_resolution;

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution.xy;
  vec2 center = vec2(0.5, 0.5);
  vec2 toCenter = st - center;
  float dist = length(toCenter);

  // Radial distortion
  dist += sin(dist * 20.0 - u_time * 2.0) * 0.05;

  // More intense waves
  float waves = sin(dist * 80.0 - u_time * 10.0);

  // Faster hue cycling
  float hue = mod(dist * 20.0 + u_time * 0.5, 1.0);

  // Brighter and more saturated
  vec3 color = hsv2rgb(vec3(hue, 1.0, waves * 0.7 + 0.7));

  gl_FragColor = vec4(color, 0.5); // Slightly more opaque
}


        `
      });

      const geometry = new THREE.PlaneGeometry(2, 2);
      mesh = new THREE.Mesh(geometry, material);
      scene.add(mesh);

      function animate(time) {
        uniforms.u_time.value = time * 0.001;
        renderer.render(scene, camera);
        animationId = requestAnimationFrame(animate);
      }

      animate();

      window.addEventListener('resize', () => {
        uniforms.u_resolution.value.set(window.innerWidth, window.innerHeight);
        renderer.setSize(window.innerWidth, window.innerHeight);
      });
    });
  }

  function stopShader() {
    cancelAnimationFrame(animationId);
    const canvas = document.getElementById(shaderId);
    if (canvas) canvas.remove();
  }

  window.toggleLSD = function() {
    window.active = !window.active;
    if (window.active) {
      startShader();
    } else {
      stopShader();
    }
  };
})();


// --- Create tab container ---
const tabContainer = document.createElement('div');
tabContainer.classList.add('tab-container');
tabContainer.style.position = 'fixed';
tabContainer.style.top = '20px';
tabContainer.style.left = '20px';
tabContainer.style.display = 'flex';
tabContainer.style.flexDirection = 'row';
tabContainer.style.gap = '10px';
tabContainer.style.zIndex = '99999';
document.body.appendChild(tabContainer);

// --- CSS ---
const style = document.createElement('style');
style.textContent = `
.tab-window {
    color: #ffffff;
    width: 260px;
    background: #2c1335;
    border: 2px solid #5c2f72;
    border-radius: 6px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.6);
    user-select: none;
    position: fixed;
    z-index: 100000;
}
.tab-input {
    background: #5c2f72;
    border-radius: 4px 4px 0 0;
    border: none;
}
.center-text {
  text-align: center !important;
}
.tab-header {
    background: #5c2f72;
    padding: 6px 10px;
    cursor: move;
    font-weight: bold;
    border-radius: 4px 4px 0 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}
.collapse-btn {
    background: #793a96;
    border: none;
    color: white;
    font-size: 14px;
    font-weight: bold;
    cursor: pointer;
    border-radius: 4px;
    padding: 0 6px;
}
.collapse-btn:hover { background: #9d4fc4; }
.tab-content { padding: 8px 12px; display: block; }
.tab-item {
    padding: 6px 8px;
    cursor: pointer;
    border-radius: 4px;
    transition: background 0.2s, color 0.2s;
    display: flex;
    justify-content: space-between;
    align-items: center;
    position: relative;
}
.tab-item:hover { background: #793a96; }
.tab-item.enabled { background: #4caf50 !important; color: white; }
.tab-item.enabled::after {
    content: "";
    position: absolute;
    right: 0;
    top: 2px;
    bottom: 2px;
    width: 4px;
    background: #fff;
    border-radius: 2px;
}
`;
document.head.appendChild(style);

// --- Helper to create windows ---
let tabOffset = 0; // global offset for stacking

function createTabWindow(title, items) {
    const win = document.createElement('div');
    win.classList.add('tab-window');

    // offset each new tab by 20px down and right
   // win.style.top = (20 + tabOffset*30) + 'px';
    win.style.left = (300 + tabOffset*300) + 'px';
    tabOffset++;

    const header = document.createElement('div');
    header.classList.add('tab-header');
    header.innerHTML = `<span>${title}</span>`;
    const collapseBtn = document.createElement('button');
    collapseBtn.classList.add('collapse-btn');
    collapseBtn.textContent = '-';
    header.appendChild(collapseBtn);
    win.appendChild(header);

    const content = document.createElement('div');
    content.classList.add('tab-content');
    items.forEach(item => content.appendChild(item));
    win.appendChild(content);
    tabContainer.appendChild(win);

    // --- Dragging (same as before) ---
    let offsetX = 0, offsetY = 0, dragging = false;
    header.addEventListener('mousedown', e => {
        if (e.target === collapseBtn) return;
        dragging = true;
        const rect = win.getBoundingClientRect();
        offsetX = e.clientX - rect.left;
        offsetY = e.clientY - rect.top;
        document.querySelectorAll('.tab-window').forEach(w => w.style.zIndex = '100000');
        win.style.zIndex = '100001';
    });
    document.addEventListener('mousemove', e => {
        if (!dragging) return;
        win.style.left = (e.clientX - offsetX) + 'px';
        win.style.top = (e.clientY - offsetY) + 'px';
        win.style.position = 'fixed';
    });
    document.addEventListener('mouseup', () => dragging = false);

    // --- Collapse ---
    collapseBtn.addEventListener('click', () => {
        if (content.style.display === 'none') {
            content.style.display = 'block';
            collapseBtn.textContent = '-';
        } else {
            content.style.display = 'none';
            collapseBtn.textContent = '+';
        }
    });

    return win;
}
function splitOnOrOutsideComments(code) {
    const commentRegex = /\/\/.*|\/\*[\s\S]*?\*\//g;
    const comments = [];
    let match;

    // Store comment ranges
    while ((match = commentRegex.exec(code)) !== null) {
        comments.push({ start: match.index, end: match.index + match[0].length });
    }

    // Find first "or" not in a comment
    const orRegex = /\bor\b/g;
    while ((match = orRegex.exec(code)) !== null) {
        const index = match.index;
        const inComment = comments.some(c => index >= c.start && index < c.end);
        if (!inComment) {
            return code.slice(0, index); // Split before "or"
        }
    }

    return code; // No "or" found outside comments
}


// --- Create tab items ---
function createTabItem(text, onClick, centerText) {
    const item = document.createElement('div');
    item.classList.add('tab-item');
    item.textContent = text;
    if(onClick) item.addEventListener('click', onClick);
    if(centerText) item.classList.add("center-text");
    return item;
}

function createInput(placeholder, id) {
    const item = document.createElement('input');
    item.classList.add('tab-item');
    item.classList.add('tab-input');
    item.id = id;
    
    
    return item;
}


function removeComments(code) {
    return code
        // Remove multi-line comments
        .replace(/\/\*[\s\S]*?\*\//g, '')
        // Remove single-line comments
        .replace(/\/\/.*$/gm, '');
}


function showAlert(text, title = "Alert", button = "OK") {
    const win = document.createElement('div');
    win.classList.add('tab-window');
    const id = Math.random().toString();
    win.setAttribute("id", id);

    win.style.left = (300 + tabOffset * 300) + 'px';
    tabOffset++;

    const header = document.createElement('div');
    header.classList.add('tab-header');
    header.innerHTML = `<span>${title}</span>`;
    win.appendChild(header);

    const content = document.createElement('div');
    content.classList.add('tab-content');
    content.style.display = 'flex';
    content.style.flexDirection = 'column';
    content.style.alignItems = 'center';
    content.style.justifyContent = 'center';
    content.style.gap = '12px';

    const message = document.createElement('div');
    message.classList.add('tab-item');
    message.textContent = text;
    message.style.textAlign = 'center';
    message.style.fontSize = '16px';
    message.style.padding = '10px';
    message.style.background = '#3e1b4a';
    message.style.borderRadius = '6px';
    message.style.width = '100%';

    const buttonEl = document.createElement('button');
    buttonEl.textContent = button;
    buttonEl.classList.add('collapse-btn');
    buttonEl.style.padding = '6px 12px';
    buttonEl.style.fontSize = '15px';
    buttonEl.style.marginTop = '8px';
    buttonEl.style.borderRadius = '6px';
    buttonEl.style.background = '#9d4fc4';
    buttonEl.style.border = 'none';
    buttonEl.style.cursor = 'pointer';
    buttonEl.addEventListener('click', () => {
        document.getElementById(id).style.display = "none";
    });

    content.appendChild(message);
    content.appendChild(buttonEl);
    win.appendChild(content);
    tabContainer.appendChild(win);

    // --- Dragging ---
    let offsetX = 0, offsetY = 0, dragging = false;
    header.addEventListener('mousedown', e => {
        dragging = true;
        const rect = win.getBoundingClientRect();
        offsetX = e.clientX - rect.left;
        offsetY = e.clientY - rect.top;
        document.querySelectorAll('.tab-window').forEach(w => w.style.zIndex = '100000');
        win.style.zIndex = '100001';
    });
    document.addEventListener('mousemove', e => {
        if (!dragging) return;
        win.style.left = (e.clientX - offsetX) + 'px';
        win.style.top = (e.clientY - offsetY) + 'px';
        win.style.position = 'fixed';
    });
    document.addEventListener('mouseup', () => dragging = false);

    return win;
}
function showToast(message, duration = 3000) {
    const toast = document.createElement('div');
    toast.classList.add('tab-window');
    toast.style.position = 'fixed';
    toast.style.bottom = '30px';
    toast.style.left = '50%';
    toast.style.transform = 'translateX(-50%)';
    toast.style.background = '#3e1b4a';
    toast.style.color = '#fff';
    toast.style.padding = '12px 20px';
    toast.style.borderRadius = '8px';
    toast.style.boxShadow = '0 4px 12px rgba(0,0,0,0.5)';
    toast.style.fontSize = '16px';
    toast.style.zIndex = '100001';
    toast.style.opacity = '0';
    toast.style.transition = 'opacity 0.5s ease, bottom 0.5s ease';

    toast.textContent = message;
    document.body.appendChild(toast);

    // Animate in
    setTimeout(() => {
        toast.style.opacity = '1';
        toast.style.bottom = '50px';
    }, 100);

    // Animate out and remove
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.bottom = '30px';
        setTimeout(() => {
            toast.remove();
        }, 500);
    }, duration);
}

window.showAlert = showAlert;

// --- Noclip ---
window.noclipOn = false;
window._originalCanMove = null;
const noclipItem = createTabItem('Noclip', () => {
    if(window.noclipOn) disableNoclip();
    else enableNoclip();
});
function enableNoclip() {
    const w = Ed.runner.curWorld;
    if(!w) return;
    if(!window._originalCanMove) window._originalCanMove = w.canMove.bind(w);
    w.canMove = () => true;
    window.noclipOn = true;
    noclipItem.classList.add('enabled');
}
function disableNoclip() {
    const w = Ed.runner.curWorld;
    if(!w || !window._originalCanMove) return;
    w.canMove = window._originalCanMove;
    window.noclipOn = false;
    noclipItem.classList.remove('enabled');
}
// --- GetSolutionWorld --- 
const getSolWorld = createTabItem('Get solution', () => {
    var sol = splitOnOrOutsideComments(Ed.solutionCode['default.js']);
    Ed.aceEditor.setValue(sol);

});
// --- Keyboard Move ---
const movementcode = `function moveNORTH() {
    if(facingNorth()) {
        move();
    }else{
        if(facingSouth()) {
            turnLeft();
            turnLeft();
            move();
        }else{
            if(facingEast()) {
                turnLeft();
                move();
            }else{
                if(facingWest()) {
                    turnLeft();
                    turnLeft();
                    turnLeft();
                    move();
                    
                }
            }
        }
    }
}
function moveSOUTH() {
    if(facingNorth()) {
        turnLeft();
        turnLeft();
        move();
    }else{
        if(facingSouth()) {
            move();
        }else{
            if(facingEast()) {
                turnLeft();
                turnLeft();
                turnLeft();
                move();
            }else{
                if(facingWest()) {
                    turnLeft();
                    move();
                    
                }
            }
        }
    }
}
function moveEAST() {
    if(facingNorth()) {
        turnLeft();
        turnLeft();
        turnLeft();
        move();
    }else{
        if(facingSouth()) {
            turnLeft();
            move();
        }else{
            if(facingEast()) {
                move();
            }else{
                if(facingWest()) {
                    turnLeft();
                    turnLeft();
                    move();
                    
                }
            }
        }
    }
}
function moveWEST() {
    if(facingNorth()) {
        turnLeft();
        move();
    }else{
        if(facingSouth()) {
            turnLeft();
            turnLeft();
            turnLeft();
            move();
        }else{
            if(facingEast()) {
                turnLeft();
                turnLeft();
                move();
            }else{
                if(facingWest()) {
                    move();
                    
                }
            }
        }
    }
}
`;
window.keyboardMoveOn = false;
const keyboardItem = createTabItem('Keyboard Move', () => {
    window.keyboardMoveOn = !window.keyboardMoveOn;
    keyboardItem.classList.toggle('enabled', window.keyboardMoveOn);
});
const lsdItem = createTabItem('LSD', () => {
    window.toggleLSD();
    lsdItem.classList.toggle('enabled', window.active);
});
function moveKarelKeyboard(dx, dy){
    //Ed.runner.curWorld.karelCol
    
    const w = Ed.runner.curWorld;
    if(!w) return;
    // const kc = w.karelCol;
    // const kr = w.karelRow;
    const k = w.karel;
    // w.karelStartRow = kc+dx
    // w.karelStartCol = kr+dy
    // w.karelRow = kc+dx
    // w.karelCol = kr+dy
    k.setPosition(k.x + dx*40, k.y + dy*40);
}

document.addEventListener('keydown', e => {
    if(e.code==='ShiftRight'){
        tabContainer.style.display = tabContainer.style.display==='none'?'flex':'none';
    }
    if(window.keyboardMoveOn){
        if(e.key==='w') moveKarelKeyboard(0,-1);
        if(e.key==='s') moveKarelKeyboard(0,1);
        if(e.key==='a') moveKarelKeyboard(-1,0);
        if(e.key==='d') moveKarelKeyboard(1,0);
    }
});

// --- Build tabs ---
createTabWindow('Bypass', [
    createTabItem('Coming Soon!'),
    
]);
createTabWindow('Level', [
    noclipItem,
    keyboardItem,
    getSolWorld
    
]);
createTabWindow('Other', [
    lsdItem
]);
