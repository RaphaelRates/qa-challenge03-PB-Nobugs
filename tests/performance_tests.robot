# ==========================================
# FILE: tests/performance_tests.robot
# ==========================================
*** Settings ***
Documentation    Testes de Performance da API ServeRest
Resource         ../resources/api_keywords.robot
Suite Setup      Run Keywords
...              Criar Sessão da API    AND
...              Realizar Login com Sucesso
Suite Teardown   Encerrar Sessão da API

*** Test Cases ***
TC-PERF-001: Tempo de Resposta Login
    [Documentation]    Valida tempo de resposta do endpoint de login
    [Tags]    performance    login
    
    ${start_time}=    Get Time    epoch
    ${response}=    Realizar Login    ${VALID_EMAIL}    ${VALID_PASSWORD}
    ${end_time}=    Get Time    epoch
    
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Should Be True    ${duration} < 2    Tempo de resposta maior que 2 segundos: ${duration}s

TC-PERF-002: Tempo de Resposta Listagem Usuários
    [Documentation]    Valida tempo de resposta ao listar usuários
    [Tags]    performance    usuarios
    
    ${start_time}=    Get Time    epoch
    ${response}=    Listar Usuarios
    ${end_time}=    Get Time    epoch
    
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Should Be True    ${duration} < 3    Tempo de resposta maior que 3 segundos: ${duration}s

TC-PERF-003: Tempo de Resposta Listagem Produtos
    [Documentation]    Valida tempo de resposta ao listar produtos
    [Tags]    performance    produtos
    
    ${start_time}=    Get Time    epoch
    ${response}=    Listar Produtos
    ${end_time}=    Get Time    epoch
    
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Should Be True    ${duration} < 3    Tempo de resposta maior que 3 segundos: ${duration}s

TC-PERF-004: Tempo de Resposta Criação de Carrinho
    [Documentation]    Valida tempo de resposta ao criar carrinho
    [Tags]    performance    carrinhos
    
    # Setup: criar produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${product_response}=    Cadastrar Produto    ${produto}
    ${product_id}=    Get From Dictionary    ${product_response.json()}    _id
    
    # Teste de performance
    ${carrinho}=    Criar Dados Carrinho    ${product_id}
    
    ${start_time}=    Get Time    epoch
    ${response}=    Cadastrar Carrinho    ${carrinho}
    ${end_time}=    Get Time    epoch
    
    ${duration}=    Evaluate    ${end_time} - ${start_time}
    
    Validar Status Code    ${response}    ${STATUS_CREATED}
    Should Be True    ${duration} < 3    Tempo de resposta maior que 3 segundos: ${duration}s
    
    # Cleanup
    Cancelar Compra
    Deletar Produto    ${product_id}

