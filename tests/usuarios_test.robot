# ==========================================
# FILE: tests/usuarios_tests.robot
# ==========================================
*** Settings ***
Documentation    Testes de Usuários da API ServeRest
Resource         ../resources/api_keywords.robot
Suite Setup      Run Keywords
...              Criar Sessão da API    AND
...              Realizar Login com Sucesso
Suite Teardown   Encerrar Sessão da API

*** Test Cases ***
TC-USR-001: Listar Todos os Usuários
    [Documentation]    Valida listagem de todos os usuários
    [Tags]    usuarios    get    smoke
    
    ${response}=    Listar Usuarios
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Validar Campo Presente na Resposta    ${response}    usuarios

TC-USR-002: Cadastrar Novo Usuário com Dados Válidos
    [Documentation]    Valida criação de usuário com dados corretos
    [Tags]    usuarios    post    positivo
    
    ${usuario}=    Gerar Dados Usuario Aleatorio
    ${response}=    Cadastrar Usuario    ${usuario}
    
    Validar Status Code    ${response}    ${STATUS_CREATED}
    Validar Mensagem na Resposta    ${response}    ${MSG_USER_CREATED}
    Validar Campo Presente na Resposta    ${response}    _id
    
    # Cleanup
    ${user_id}=    Get From Dictionary    ${response.json()}    _id
    Deletar Usuario    ${user_id}

TC-USR-003: Cadastrar Usuário com Email Duplicado
    [Documentation]    Valida que não permite email duplicado
    [Tags]    usuarios    post    negativo
    
    ${usuario}=    Gerar Dados Usuario Aleatorio
    
    # Cria primeiro usuário
    ${response1}=    Cadastrar Usuario    ${usuario}
    ${user_id}=    Get From Dictionary    ${response1.json()}    _id
    
    # Tenta criar com mesmo email
    ${response2}=    Cadastrar Usuario    ${usuario}
    
    Validar Status Code    ${response2}    ${STATUS_BAD_REQUEST}
    Validar Mensagem na Resposta    ${response2}    ${MSG_USER_EXISTS}
    
    # Cleanup
    Deletar Usuario    ${user_id}

TC-USR-004: Buscar Usuário Por ID Válido
    [Documentation]    Valida busca de usuário existente
    [Tags]    usuarios    get    positivo
    
    # Cria usuário
    ${usuario}=    Gerar Dados Usuario Aleatorio
    ${create_response}=    Cadastrar Usuario    ${usuario}
    ${user_id}=    Get From Dictionary    ${create_response.json()}    _id
    
    # Busca usuário
    ${response}=    Buscar Usuario Por ID    ${user_id}
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Should Be Equal    ${response.json()['_id']}    ${user_id}
    
    # Cleanup
    Deletar Usuario    ${user_id}

TC-USR-005: Buscar Usuário Por ID Inválido
    [Documentation]    Valida busca com ID inexistente
    [Tags]    usuarios    get    negativo
    
    ${invalid_id}=    Generate Random String    24    [LETTERS][NUMBERS]
    ${response}=    Buscar Usuario Por ID    ${invalid_id}
    
    Validar Status Code    ${response}    ${STATUS_BAD_REQUEST}

TC-USR-006: Atualizar Usuário Existente
    [Documentation]    Valida atualização de dados do usuário
    [Tags]    usuarios    put    positivo
    
    # Cria usuário
    ${usuario}=    Gerar Dados Usuario Aleatorio
    ${create_response}=    Cadastrar Usuario    ${usuario}
    ${user_id}=    Get From Dictionary    ${create_response.json()}    _id
    
    # Atualiza usuário
    ${usuario_atualizado}=    Gerar Dados Usuario Aleatorio
    ${response}=    Atualizar Usuario    ${user_id}    ${usuario_atualizado}
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Validar Mensagem na Resposta    ${response}    ${MSG_RECORD_UPDATED}
    
    # Cleanup
    Deletar Usuario    ${user_id}

TC-USR-007: Deletar Usuário Existente
    [Documentation]    Valida exclusão de usuário
    [Tags]    usuarios    delete    positivo
    
    # Cria usuário
    ${usuario}=    Gerar Dados Usuario Aleatorio
    ${create_response}=    Cadastrar Usuario    ${usuario}
    ${user_id}=    Get From Dictionary    ${create_response.json()}    _id
    
    # Deleta usuário
    ${response}=    Deletar Usuario    ${user_id}
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Validar Mensagem na Resposta    ${response}    ${MSG_RECORD_DELETED}