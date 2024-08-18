document.getElementById("denunciaForm").addEventListener("submit", function(event) {
    event.preventDefault();

    const nombre = document.getElementById("nombre").value;
    const telefono = document.getElementById("telefono").value;
    const motivo = document.getElementById("motivo").value;

    fetch(`https://${GetParentResourceName()}/submit`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            nombre: nombre,
            telefono: telefono,
            motivo: motivo
        })
    }).then(resp => resp.json()).then(resp => {
        if (resp === "ok") {
            closeUI();
        }
    });
});

document.getElementById("cerrar").addEventListener("click", function() {
    closeUI();
});

function closeUI() {
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST'
    }).then(resp => resp.json()).then(resp => {
        if (resp === "ok") {
            document.getElementById("formContainer").style.display = "none";
            document.getElementById("denunciaForm").reset();
        }
    });
}

// Cerrar con ESC
window.addEventListener('keydown', function(event) {
    if (event.key === "Escape") {
        closeUI();
    }
});

// Validación para permitir solo números en el campo de teléfono
document.getElementById("telefono").addEventListener("input", function(event) {
    this.value = this.value.replace(/[^0-9]/g, '');
});

window.addEventListener("message", function(event) {
    if (event.data.action === "open") {
        document.getElementById("formContainer").style.display = "block";
    } else if (event.data.action === "close") {
        document.getElementById("formContainer").style.display = "none";
    } else if (event.data.action === "toggleAlwaysVisible") {
        document.getElementById("formContainer").style.display = event.data.visible ? "block" : "none";
    }
});
