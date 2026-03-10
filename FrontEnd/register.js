const form = document.getElementById("formRegistro");

form.onsubmit = (e) => {

  e.preventDefault();

  const paciente = {
    nombre: document.getElementById("nombre").value,
    apellido: document.getElementById("apellido").value,
    telefono: document.getElementById("telefono").value,
    correo: document.getElementById("correo").value,
    password: document.getElementById("password").value
  };

  fetch("http://localhost:8080/api/pacientes", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(paciente)
  })
  .then(res => res.json())
  .then(data => {

    console.log("Usuario guardado:", data);

    alert("Cuenta creada correctamente");

    form.reset();

    // redirige a la pagina principal
    window.location.href = "../welcome.html";

  })
  .catch(error => {
    console.error("Error:", error);
    alert("Error al registrar usuario");
  });

};
