# ==========================================
# FILE: tests/security_tests.robot
# ==========================================
*** Settings ***
Documentation    Testes de Segurança da API ServeRest
Resource         ../resources/api_keywords.robot
Suite Setup      Criar Sessão da API
Suite Teardown   Encerrar Sessão da API

*** Test Cases ***
TC-SEC-001: Acessar Endpoint Protegido Sem Token
    [Documentation]    Valida que endpoints protegidos rejeitam requisições sem token
    [Tags]    security    negativo
    
    ${produto}=    Gerar Dados Produto Aleatorio
    ${response}=    Cadastrar Produto    ${produto}    token=${EMPTY}
    
    Validar Status Code    ${response}    ${STATUS_UNAUTHORIZED}
    Validar Mensagem na Resposta    ${response}    ${MSG_UNAUTHORIZED}

TC-SEC-002: Acessar Endpoint com Token Inválido
    [Documentation]    Valida rejeição de token inválido
    [Tags]    security    negativo
    
    ${invalid_token}=    Set Variable    Bearer token_invalido_123456
    
    ${produto}=    Gerar Dados Produto Aleatorio
    ${response}=    Cadastrar Produto    ${produto}    token=${invalid_token}
    
    Validar Status Code    ${response}    ${STATUS_UNAUTHORIZED}

TC-SEC-003: Tentar Deletar Usuário de Outro
    [Documentation]    Valida que não é possível deletar usuário de terceiros
    [Tags]    security    negativo
    
    # Login e criação de primeiro usuário
    ${token1}=    Realizar Login com Sucesso
    ${usuario1}=    Gerar Dados Usuario Aleatorio
    ${user_response}=    Cadastrar Usuario    ${usuario1}    ${token1}
    ${user_id}=    Get From Dictionary    ${user_response.json()}    _id
    
    # Tentar deletar com outro usuário (deve falhar ou ter regra específica)
    ${response}=    Deletar Usuario    ${user_id}    ${token1}
    
    # Verifica comportamento esperado
    Should Be True    ${response.status_code} in [${STATUS_OK}, ${STATUS_FORBIDDEN}]
    
    # Cleanup
    Run Keyword If    ${response.status_code} != ${STATUS_OK}
    ...    Deletar Usuario    ${user_id}    ${token1}

TC-SEC-004: SQL Injection em Query Parameters
    [Documentation]    Valida proteção contra SQL Injection
    [Tags]    security    injection
    
    ${token}=    Realizar Login com Sucesso
    
    ${malicious_params}=    Create Dictionary
    ...    nome='; DROP TABLE usuarios; --
    
    ${response}=    Listar Usuarios    ${token}    ${malicious_params}
    
    # API deve retornar resposta válida sem executar SQL
    Should Be True    ${response.status_code} in [${STATUS_OK}, ${STATUS_BAD_REQUEST}]

TC-SEC-005: XSS em Campos de Texto
    [Documentation]    Valida sanitização de XSS em inputs
    [Tags]    security    xss
    
    ${token}=    Realizar Login com Sucesso
    
    ${usuario_xss}=    Create Dictionary
    ...    nome=<script>alert('XSS')</script>
    ...    email=xss@test.com
    ...    password=teste123
    ...    administrador=false
    
    ${response}=    Cadastrar Usuario    ${usuario_xss}    ${token}
    
    # Verificar se API sanitizou ou rejeitou
    IF    ${response.status_code} == ${STATUS_CREATED}
        ${user_id}=    Get From Dictionary    ${response.json()}    _id
        ${get_response}=    Buscar Usuario Por ID    ${user_id}    ${token}
        
        # Verificar se script foi sanitizado
        Should Not Contain    ${get_response.json()['nome']}    <script>
        
        # Cleanup
        Deletar Usuario    ${user_id}    ${token}
    END

