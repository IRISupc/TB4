
--Epica: Registro de Usuario en la Plataforma--

Feature: US01 - Como usuario nuevo no registrado, deseo poder crear una cuenta en la plataforma, para poder acceder a las funcionalidades exclusivas de la plataforma.

  Scenario: Usuario registra una nueva cuenta con información válida
    Given el usuario no está registrado
    And el usuario ingresa a la página de Registro
    When el usuario coloca credenciales válidas en los campos "Full name", "Email or Phone", "Your address"
    And acepta los términos de servicio y la política de privacidad
    And hace clic en el botón "Registrar"
    Then el sistema genera un código de verificación que es enviado por SMS o email

   Examples:
      | Full name     | Email or Phone          | Your address              | tipo_mensaje |
      | Franco Ochoa  | U202316350@upc.edu.pe   | Av. Gral. Salaverry 2120  | SMS          |
      | Samir Saul    | samir@upc.edu.pe        | Av. Peru 142              | correo       |
          
      |¿Acepta los términos de servicio y la política de privacidad? | |SI| |NO|

      |Registrar|

  Scenario: Usuario verifica su cuenta a través de un código y crea una contraseña
    Given el usuario ha registrado una nueva cuenta
    And el sistema ha enviado un correo o SMS con un código de verificación
    When el usuario introduce el código de verificación válido en el campo correspondiente
    And hace clic en el botón "Verify"
    Then el sistema verifica el código
    And redirige al usuario a la página de creación de contraseña
    When el usuario introduce y confirma su nueva contraseña
    And hace clic en el botón "Crear Contraseña"
    Then el sistema guarda la nueva contraseña
    And muestra un mensaje de "Cuenta creada con éxito"
    And redirige al usuario a la página de inicio de sesión

    Examples:
      | tipo_mensaje | Código de verificación | Crear Contraseña |
      | SMS          | 123456                 | franco123        |
      | correo       | 987654                 | password456      |

      |Cuenta creada con exito|

  Scenario: Usuario selecciona un plan de suscripción

    Given que el usuario está autenticado y en la página de selección de planes
    And el usuario visualiza las diferentes opciones de planes disponibles
    When el usuario selecciona un plan
    And hace clic en el botón "Seleccionar Plan"
    Then el sistema muestra una página de confirmación del plan seleccionado
    And el sistema solicita la información de pago del usuario

   Examples:
         | Seleccionar Plan |
         | Plan Gratuito    |        |Seleccionar Plan|
         | Plan Básico      |              
         | Plan Premium     |       
         | Plan Gold        |

         | Confirmacion del plan seleccionado |
         |  Confirmar   |        |  Cancelar  |


  Scenario: Usuario confirma el plan seleccionado y realiza el pago

    Given que el usuario ha seleccionado un plan
    And el sistema muestra la página de confirmación del plan
    When el usuario introduce la información de pago válida
    And hace clic en el botón "Confirmar y Pagar"
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
    Given que el usuario es un organizador autenticado
    And el usuario selecciona la opción "Crear evento" en el menú "Mis eventos"
    When el usuario selecciona la opción de ver reportes
    Then el sistema muestra el formulario "Registrar mi evento" conteniendo los campos "Nombre del evento", "Ubicación", "Fecha", "Precio individual"
    When el usuario ingresa todos los campos obligatorios y hace click en el botón "Registrar evento"
    Then el sistema valida que los datos ingresados en los campos "Nombre del evento", "Ubicación", "Fecha", "Descripción", "Categoría", "Precio individual" son válidos
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
    Given que el usuario ha iniciado sesión como organizador de eventos
    And se encuentra en la sección "Mis Eventos"
    And hay al menos un evento registrado por el usuario
    When el usuario selecciona un evento de la lista
    And hace clic en la opción "Editar"
    Then el sistema muestra un formulario con los detalles actuales del evento
    And permite la modificación de los campos editables (nombre del evento, fecha, lugar, descripción, categoría y precio)

    Examples:
    |Mis eventos|
        |Editar|
           | Nombre del evento     | Fecha       | Lugar            | Descripción           | Categoría  | Precio |
           | Expo de Arte 2024     | 2024-08-20  | Parque Kennedy   | Arte                  | Cultural   | 30.00  |
           | Concierto de Rock     | 2024-09-15  | Estadio Nacional | Concierto de bandas   | Música     | 50.00  |

  Scenario: Guardar cambios en el evento
    Given que el usuario ha realizado modificaciones en el formulario de edición del evento
    And ha completado todos los campos obligatorios
    When el usuario hace clic en el botón "Guardar"
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
    Given el usuario es un organizador autenticado
    And el usuario se encuentra en la sección “Mis eventos”
    When el usuario selecciona uno de sus eventos
    And el usuario selecciona la opción “Generar Reporte preliminar”
    Then el sistema genera un reporte hasta la fecha del evento seleccionado

   Examples:
    |Mis eventos|
        |Expo de Arte 2024|
            |Generar Reporte preliminar|
              |Generando....|
  

  Scenario: Visualización de reporte preliminar
    Given el usuario ha generado un reporte preliminar de un evento
    When el usuario hace clic en el botón "Ver Reporte preliminar"
    Then el sistema genera y muestra un reporte preliminar que incluye datos como el número de entradas vendidas, ingresos generados hasta la fecha, demografía de los asistentes, y cualquier feedback recibido hasta el momento

   Examples:
    |Mis eventos|
        |Expo de Arte 2024|
            |Reporte preliminar generado|
              | Nombre del evento     | Fecha       | Lugar            | Descripción           | Categoría  | Precio |
              | Expo de Arte 2024     | 2024-08-20  | Parque Kennedy   | Arte                  | Cultural   | 30.00  |