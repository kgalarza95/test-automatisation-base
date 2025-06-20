Feature: Test de API prueba técnica

  Background:
    * configure ssl = true
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/kjgalarz/api/characters'
    * def headers = { 'Content-Type': 'application/json' }
    * def idGlobal = 20

  Scenario: Crear personaje (exitoso)
    * def personaje = read('classpath:data/crear_personaje.json')
    Given request personaje
    And headers headers
    When method POST
    Then status 201
    And print response
    And match response.name contains 'Iron Man'
    And match response.alterego contains 'Tony Stark'


  Scenario: Crear personaje (nombre duplicado)
    * def personaje = read('classpath:data/crear_personaje_nombre_duplicado.json')
    Given request personaje
    And headers headers
    When method POST
    Then status 400
    And print response
    And match response.error == 'Character name already exists'

  Scenario: Crear personaje (faltan campos requeridos)
    * def personaje = read('classpath:data/crear_personaje_campos_requeridos.json')
    Given request personaje
    And headers headers
    When method POST
    Then status 400
    And print response
    And match response ==
      """
      {
        "name": "Name is required",
        "description": "Description is required",
        "powers": "Powers are required",
        "alterego": "Alterego is required"
      }
      """

  Scenario: Obtener todos los personajes
    When method GET
    Then status 200
    And print response

  Scenario: Obtener personaje por ID (exitoso)
    Given path idGlobal
    When method GET
    Then status 200
    And print response
    And match response contains { id: '#(idGlobal)', }

  Scenario: Obtener personaje por ID (no existe)
    Given path '999'
    When method GET
    Then status 404
    And print response
    And match response.error == 'Character not found'

  Scenario: Actualizar personaje (exitoso)
    * def personaje = read('classpath:data/actualizar_personaje.json')
    Given request personaje
    And path idGlobal
    And headers headers
    When method PUT
    Then status 200
    And print response
    And match response ==
      """
      {
        "id": '#(idGlobal)',
        "name": "Iron Man",
        "alterego": "Tony Stark",
        "description": "Updated description",
        "powers": [
          "Armor",
          "Flight"
        ]
      }
      """

  Scenario: Actualizar personaje (no existe)
    * def personaje = read('classpath:data/actualizar_personaje.json')
    Given request personaje
    And path '999'
    And headers headers
    When method PUT
    Then status 404
    And print response
    And match response.error == 'Character not found'


  Scenario: Eliminar personaje (exitoso)
    Given path idGlobal
    And headers headers
    When method DELETE
    Then status 204

  Scenario: Eliminar personaje (no existe)
    Given path '999'
    And headers headers
    When method DELETE
    Then status 404
    And print response
    And match response.error == 'Character not found'


  #####################################################################################

  Scenario: Crear, obtener y eliminar personaje de forma dinámicamente
    * def personaje = read('classpath:data/crear_personaje_test_dinamico.json')
    Given request personaje
    And headers headers
    When method POST
    Then status 201
    And print 'Personaje creado:', response
    * def idPersonaje = response.id

    # Obtener el personaje por su ID
    Given path idPersonaje
    When method GET
    Then status 200
    And print 'Personaje obtenido por ID:', response
    And match response.id == idPersonaje
    And match response.name == 'Spiderman'

    # Eliminar personaje
    Given path idPersonaje
    When method DELETE
    Then status 204
    And print 'Personaje eliminado con éxito'

    # Verificar que ya no existe
    Given path idPersonaje
    When method GET
    Then status 404
    And print response
    And match response.error == 'Character not found'
