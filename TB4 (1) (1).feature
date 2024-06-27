
--Epica: Registro de Usuario en la Plataforma--

Feature: US01 - Como [usuario] nuevo no registrado, deseo poder crear una cuenta en la plataforma, para poder acceder a las funcionalidades exclusivas de la plataforma.

  Scenario: Usuario registra una nueva cuenta con información válida
    Given el [usuario] no está registrado
    And el [usuario] ingresa a la página de Registro
    When el [usuario] coloca credenciales válidas en los campos [Full name], [Email or Phone], [Your address]
    And acepta los términos de servicio y la política de privacidad
    And hace clic en el botón [Registrar]
    Then el sistema genera un código de verificación que es enviado por SMS o email

   Examples:
      | Full name     | Email or Phone          | Your address              | tipo_mensaje |
      | Franco Ochoa  | U202316350@upc.edu.pe   | Av. Gral. Salaverry 2120  | SMS          |
      | Samir Saul    | samir@upc.edu.pe        | Av. Peru 142              | correo       |
          
      |¿Acepta los términos de servicio y la política de privacidad? | |SI| |NO|

      |Registrar|

  Scenario: Usuario verifica su cuenta a través de un código y crea una contraseña
    Given el [usuario] ha registrado una nueva cuenta
    And el sistema ha enviado un correo o SMS con un código de verificación
    When el [usuario] introduce el [código] de verificación válido en el campo correspondiente
    And hace clic en el botón [Verify]
    Then el sistema verifica el código
    And redirige al [usuario] a la página de creación de contraseña
    When el [usuario] introduce y confirma su nueva contraseña
    And hace clic en el botón [Crear Contraseña]
    Then el sistema guarda la nueva contraseña
    And muestra un mensaje de "Cuenta creada con éxito"
    And redirige al [usuario] a la página de inicio de sesión

    Examples:
      | tipo_mensaje | Código de verificación | Crear Contraseña |
      | SMS          | 123456                 | franco123        |
      | correo       | 987654                 | password456      |

      |Cuenta creada con exito|

  Scenario: Usuario selecciona un plan de suscripción

    Given que el [usuario] está autenticado y en la página de selección de planes
    And el [usuario] visualiza las diferentes opciones de planes disponibles
    When el [usuario] selecciona un plan
    And hace clic en el botón [Seleccionar Plan]
    Then el sistema muestra una página de confirmación del plan seleccionado
    And el sistema solicita la información de pago del [usuario]

   Examples:
         | Seleccionar Plan |
         | Plan Gratuito    |        |Seleccionar Plan|
         | Plan Básico      |              
         | Plan Premium     |       
         | Plan Gold        |

         | Confirmacion del plan seleccionado |
         |  Confirmar   |        |  Cancelar  |


  Scenario: Usuario confirma el plan seleccionado y realiza el pago

    Given que el [[usuario]] ha seleccionado un plan
    And el sistema muestra la página de confirmación del plan
    When el [usuario] introduce la información de pago válida
    And hace clic en el botón [Confirmar y Pagar]
    Then el sistema procesa el pago correctamente
    And muestra un mensaje de confirmación de pago

    Examples:
      | Información de pago |
      | Tarjeta de crédito  |     | Confirmar y Pagar |
      | Tarjeta de debito   |           
      | YAPE                |          
      | PLIN                |

      |El pago ha sido procesado correctamente|  

--   Epic:Gestión de Eventos    --

Feature: US07: Como organizador de eventos, quiero poder modificar mis eventos ya registrados, para actualizar detalles y mantener la información correcta.

  Scenario: Registro de un nuevo evento
    Given que el [usuario] es un organizador autenticado
    And el [usuario] selecciona la opción [Crear evento] en el menú [Mis eventos]
    When el [usuario] selecciona la opción de ver reportes
    Then el sistema muestra el formulario [Registrar mi evento] conteniendo los campos [Nombre del evento], [Ubicación], [Fecha], [Precio individual]
    When el [usuario] ingresa todos los campos obligatorios y hace click en el botón [Registrar evento]
    Then el sistema valida que los datos ingresados en los campos [Nombre del evento], [Ubicación], [Fecha], [Descripción], [Categoría], [Precio individual] son válidos
    And el sistema muestra el mensaje "Su evento fue registrado con éxito"
    And el sistema envía el mensaje de confirmación al email del organizador

    Examples:
    |Mis eventos|
        |Crear Evento|
          | Nombre del evento     | Ubicación        | Fecha       | Descripción             | Categoría  | Precio individual |
          | Expo de Arte 2024     | Parque Central   | 2024-08-15  | Arte                    | Cultural   | 25.00             |
          | Concierto de Rock     | Estadio Nacional | 2024-09-10  | Concierto de bandas     | Música     | 40.00             |
             
             |Su evento fue registrado con exito|

  Scenario: Acceso a la edición de eventos
    Given que el [usuario] ha iniciado sesión como organizador de eventos
    And se encuentra en la sección [Mis Eventos]
    And hay al menos un evento registrado por el [usuario]
    When el [usuario] selecciona un evento de la lista
    And hace clic en la opción [Editar]
    Then el sistema muestra un formulario con los detalles actuales del evento
    And permite la modificación de los campos editables (nombre del evento, fecha, lugar, descripción, categoría y precio)

    Examples:
    |Mis eventos|
        |Editar|
           | Nombre del evento     | Fecha       | Lugar            | Descripción           | Categoría  | Precio |
           | Expo de Arte 2024     | 2024-08-20  | Parque Kennedy   | Arte                  | Cultural   | 30.00  |
           | Concierto de Rock     | 2024-09-15  | Estadio Nacional | Concierto de bandas   | Música     | 50.00  |

  Scenario: Guardar cambios en el evento
    Given que el [usuario] ha realizado modificaciones en el formulario de edición del evento
    And ha completado todos los campos obligatorios
    When el [usuario] hace clic en el botón [Guardar]
    Then el sistema verifica que los datos ingresados son válidos
    And guarda los cambios en la base de datos
    And muestra un mensaje de confirmación indicando que los cambios se han guardado exitosamente

   Examples:
    |Mis eventos|
        |Editar|
           | Nombre del evento     | Fecha       | Lugar            | Descripción           | Categoría  | Precio |
           | Expo de Arte 2024     | 2024-08-20  | Parque Kennedy   | Arte                  | Cultural   | 30.00  |
           | Concierto de Rock     | 2024-09-15  | Estadio Nacional | Concierto de bandas   | Música     | 50.00  |
                |Guardar|
                    |Los cambios se han guardado exitosamente|
 
  Scenario: Generación de reporte preliminar
    Given el [usuario] es un organizador autenticado
    And el [usuario] se encuentra en la sección [Mis eventos]
    When el [usuario] selecciona uno de sus eventos
    And el [usuario] selecciona la opción [Generar Reporte preliminar]
    Then el sistema genera un reporte hasta la fecha del evento seleccionado

   Examples:
    |Mis eventos|
        |Expo de Arte 2024|
            |Generar Reporte preliminar|
              |Generando....|
  

  Scenario: Visualización de reporte preliminar
    Given el [usuario] ha generado un [reporte preliminar] de un evento
    When el [usuario] hace clic en el botón [Ver Reporte preliminar]
    Then el sistema genera y muestra un reporte preliminar que incluye datos como [número de entradas vendidas], [ingresos generados hasta la fecha], [demografía de los asistentes], y [cualquier feedback recibido hasta el momento]

   Examples:
    |Mis eventos|
        |Expo de Arte 2024|
            |Reporte preliminar generado|
              | Nombre del evento     | Fecha       | Lugar            | Descripción           | Categoría  | Precio |
              | Expo de Arte 2024     | 2024-08-20  | Parque Kennedy   | Arte                  | Cultural   | 30.00  |
  
Feature: E02: Como encargado de una institución cultural, quiero gestionar las exposiciones, incluyendo la información de las obras y artistas participantes, para mantener un registro organizado y accesible.


  Scenario: Agregar nueva exposición
    Given que el [encargado] de una galería es un moderador
    When accedo a la sección de [exposiciones]
    And agrego una nueva exposición con detalles como [título], [descripción], [artistas] y [duración]
    Then la exposición se guarda y se muestra en la página de exposiciones


    Examples:
      | Título                   | Descripción                | Artistas                | Duración    |
      | Exposición de Verano     | Obras de artistas locales  | Juan Pérez, Ana Gómez  | 3 meses     |
      | Arte Contemporáneo       | Muestras de arte moderno   | Carlos Ruiz, Marta Lara| 6 semanas   |
      | Fotografía Urbana        | Fotografías de la ciudad   | Luis Martínez, Rosa Soto| 2 meses     |
  
Feature: A02: Como asistente a eventos, quiero registrarme para un evento y recibir un boleto electrónico, para asegurar mi lugar en el evento y facilitar mi entrada.


  Scenario: Registro a un evento
    Given que el [usuario] identificó un evento de su agrado
    And el [usuario] entra a la opción [Registrarse a evento]
    Then el sistema muestra el formulario [Registro al evento] conteniendo los campos [Email], [Nombre], [Apellido], [DNI]


    When el [usuario] completa el formulario con los datos requeridos:
      | Email                 | Nombre    | Apellido  | DNI       |
    And hace clic en el botón [Registrar]
    Then el sistema completa el registro
    And muestra el mensaje "Registro completo"


    Examples:
      | Email                  | Nombre    | Apellido  | DNI       |
      | usuario1@example.com   | Juan      | Pérez     | 12345678  |
      | usuario2@example.com   | María     | García    | 98765432  |
      | usuario3@example.com   | Pedro     | López     | 45678901  |

Feature: A08: Como asistente a eventos, quiero poder realizar publicaciones en el foro sobre eventos asistidos, para compartir mi experiencia y calificar el evento.


  Scenario: Realizar publicación en el foro del evento
    Given que el [usuario] se encuentra en la sección del foro
    And el [usuario] selecciona la opción [Realizar publicación]
    When el sistema muestra un cuadro de texto editable junto a opciones de edición para adjuntar [fotos], [videos] y [links] en su publicación
    Then el [usuario] podrá agregar y realizar su publicación junto a un puntaje de su experiencia en cierto evento


    Examples:
      | Comentario                               | Foto              | Videos            | Link                     |
      | Excelente evento, aprendí mucho!         | foto1.jpg         | video1.mp4        | https://example1.com     |
      | Gran organización, ¡recomendado!         | foto2.jpg         | video2.mp4        | https://example2.com     |
      | Interesante conferencia sobre tecnología | foto3.jpg         | video3.mp4        | https://example3.com     |


Feature: A09: Como asistente a eventos, quiero establecer el tipo de contenido relacionado a eventos que recibo, para asegurarme que mis sugerencias sean relevantes.


  Scenario: Configuración de preferencias del usuario
    Given que el [usuario] se encuentra en el menú principal
    And el [usuario] da clic en [Mi perfil]
    And el [usuario] da clic en [Ajustes]
    And el [usuario] da clic en [Configuración de preferencias]
    When el sistema muestra un listado de opciones del [género], [horario], [duración] o [rango de precios]
    Then el [usuario] selecciona sus preferencias de sugerencias en base a su gusto
    And el sistema guarda los cambios


    Examples:
      | Género         | Horario     | Duración      | Rango de precios      |
      | Tecnología     | Mañana      | 1-2 horas     | 100-200 USD           |
      | Cultura        | Tarde       | 2-3 horas     | 50-100 USD            |
      | Negocios       | Noche       | 3-4 horas     | 200-300 USD           |


Feature: US01: Como usuario nuevo no registrado, deseo poder crear una cuenta en la plataforma, para poder acceder a las funcionalidades exclusivas de la plataforma.


  Scenario: Usuario verifica código y crea contraseña exitosamente
    Given que el [usuario] ha registrado una nueva cuenta
    And el sistema ha enviado un correo o SMS con un [código de verificación]
    When el [usuario] introduce el [código de verificación] válido en el campo correspondiente
    And hace clic en el botón [Verify]
    Then el sistema verifica el [código de verificación]
    And redirige al [usuario] a la página de creación de contraseña
    When el [usuario] introduce y confirma su [Nueva contraseña]
    And hace clic en el botón [Crear Contraseña]
    Then el sistema guarda la nueva contraseña
    And muestra un mensaje de "Cuenta creada con éxito"
    And redirige al [usuario] a la página de inicio de sesión


    Examples:
      | Código de verificación | Nueva contraseña   |
      | 123456                 | password123        |
      | 987654                 | securePassword456  |
      | 555666                 | mySecretPass!      |


Feature: US06: Como organizador de eventos, quiero poder registrar mi nuevo evento en la plataforma, para que los asistentes puedan registrarse y participar en el evento.


  Scenario Outline: Registro exitoso de un evento por un organizador de eventos de gran magnitud
    Given que el [usuario] es un organizador autenticado
    And el [usuario] selecciona la opción [Crear evento] en el menú Mis eventos
    When el [usuario] selecciona la opción de ver reportes
    Then el sistema muestra el formulario [Registrar mi evento] conteniendo los campos [Nombre del evento], [Ubicación], [Fecha], [Descripción], [Categoría], [Precio individual]
    When el [usuario] ingresa todos los campos obligatorios: [Nombre del evento], [Ubicación], [Fecha], [Descripción], [Categoría], [Precio individual]
    And hace clic en el botón [Registrar evento]
    Then el sistema valida que los datos ingresados en los campos [Nombre del evento], [Ubicación], [Fecha], [Descripción], [Categoría], [Precio individual] son válidos
    And el sistema muestra el mensaje "Su evento fue registrado con éxito"
    And el sistema envía el mensaje de confirmación al email del organizador


    Examples:
      | Nombre del evento         | Ubicación                 | Fecha       | Descripción                | Categoría     | Precio individual |
      | Evento Gala Anual         | Centro de Convenciones    | 2024-07-15  | Gala benéfica anual        | Social        | 500 USD           |
      | Conferencia Internacional | Hotel de lujo             | 2024-08-20  | Conferencia académica      | Académico     | 1000 USD          |
      | Festival de Arte Urbano   | Parque Cultural           | 2024-09-10  | Festival de arte callejero | Cultural      | 250 USD           |


Feature: Gestión de Programación


  Scenario: Agregar nueva calendarización de actividad
    Given que se selecciona la opción "Nueva Calendarización"
    When el usuario agrega un nuevo [acto], [ensayo] o [montaje]
    Then el sistema permite ingresar detalles como [Nombre de la actividad], [Fecha], [Hora] y [Duración]
    And el sistema muestra la actividad en un calendario visual
    And envía recordatorios y notificaciones al equipo relevante


    Examples:
      | Nombre de la actividad | Fecha       | Hora   | Duración |
      | Acto de Apertura       | 2024-07-01  | 10:00  | 2 horas  |
      | Ensayo General         | 2024-07-05  | 14:00  | 3 horas  |
      | Montaje Escenográfico  | 2024-07-10  | 09:30  | 4 horas  |



Feature: US11: Como organizador de eventos, quiero poder trabajar con el equipo, para facilitar la coordinación y el flujo de información entre todos los miembros del equipo.


  Scenario: Enviar nuevo mensaje
    Given que el sistema muestra el formulario "Nuevo mensaje" conteniendo los campos "Destinatario", "Asunto" y "Mensaje"
    And el usuario coloca un destinatario válido en el campo [Destinatario]
    And el usuario coloca el Asunto en el campo [Asunto]
    And el usuario coloca el mensaje en el campo [Mensaje]
    When el usuario ordena enviar mensaje
    Then el sistema envía el nuevo mensaje
    And el sistema muestra el mensaje "Mensaje enviado con éxito"
    And el sistema regresa al usuario a la sección "Comunicación"


    Examples:
      | Destinatario     | Asunto            | Mensaje                       |
      | usuario1@example.com | Reunión semanal  | Hola equipo, ¿nos reunimos el jueves a las 10 AM? |
      | cliente2@example.com | Actualización de proyecto | Buenas tardes, les informo sobre el avance del proyecto. |
      | equipo3@example.com  | Recordatorio de evento  | Recuerden la reunión de planificación mañana a las 9 AM. |