Feature: Test de API súper simple

  Background:
    * configure ssl = true

  Scenario: Verificar que un endpoint público responde 200
    Given url 'https://httpbin.org/get'
    When method get
    Then status 200

  Scenario: Verificar microservicio responde 200
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/kjgalarz/api/characters'
    When method get
    Then status 200
