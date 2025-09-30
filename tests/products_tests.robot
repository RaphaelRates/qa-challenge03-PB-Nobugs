# ==========================================
# FILE: tests/produtos_tests.robot
# ==========================================
*** Settings ***
Documentation    Testes de Produtos da API ServeRest
Resource         ../resources/api_keywords.robot
Suite Setup      Run Keywords
...              Criar Sessão da API    AND
...              Realizar Login com Sucesso
Suite Teardown   Encerrar Sessão da API

*** Test Cases ***
TC-PROD-001: Listar Todos os Produtos
    [Documentation]    Valida listagem de todos os produtos
    [Tags]    produtos    get    smoke
    
    ${response}=    Listar Produtos
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Validar Campo Presente na Resposta    ${response}    produtos

TC-PROD-002: Cadastrar Novo Produto com Dados Válidos
    [Documentation]    Valida criação de produto (requer admin)
    [Tags]    produtos    post    positivo
    
    ${produto}=    Gerar Dados Produto Aleatorio
    ${response}=    Cadastrar Produto    ${produto}
    
    Validar Status Code    ${response}    ${STATUS_CREATED}
    Validar Mensagem na Resposta    ${response}    ${MSG_PRODUCT_CREATED}
    Validar Campo Presente na Resposta    ${response}    _id
    
    # Cleanup
    ${product_id}=    Get From Dictionary    ${response.json()}    _id
    Deletar Produto    ${product_id}

TC-PROD-003: Cadastrar Produto Sem Autenticação
    [Documentation]    Valida que produto não é criado sem token
    [Tags]    produtos    post    negativo    security
    
    ${produto}=    Gerar Dados Produto Aleatorio
    ${response}=    Cadastrar Produto    ${produto}    token=${EMPTY}
    
    Validar Status Code    ${response}    ${STATUS_UNAUTHORIZED}

TC-PROD-004: Buscar Produto Por ID Válido
    [Documentation]    Valida busca de produto existente
    [Tags]    produtos    get    positivo
    
    # Cria produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${create_response}=    Cadastrar Produto    ${produto}
    ${product_id}=    Get From Dictionary    ${create_response.json()}    _id
    
    # Busca produto
    ${response}=    Buscar Produto Por ID    ${product_id}
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Should Be Equal    ${response.json()['_id']}    ${product_id}
    
    # Cleanup
    Deletar Produto    ${product_id}

TC-PROD-005: Atualizar Produto Existente
    [Documentation]    Valida atualização de dados do produto
    [Tags]    produtos    put    positivo
    
    # Cria produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${create_response}=    Cadastrar Produto    ${produto}
    ${product_id}=    Get From Dictionary    ${create_response.json()}    _id
    
    # Atualiza produto
    ${produto_atualizado}=    Gerar Dados Produto Aleatorio
    ${response}=    Atualizar Produto    ${product_id}    ${produto_atualizado}
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Validar Mensagem na Resposta    ${response}    ${MSG_RECORD_UPDATED}
    
    # Cleanup
    Deletar Produto    ${product_id}

TC-PROD-006: Deletar Produto Existente
    [Documentation]    Valida exclusão de produto
    [Tags]    produtos    delete    positivo
    
    # Cria produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${create_response}=    Cadastrar Produto    ${produto}
    ${product_id}=    Get From Dictionary    ${create_response.json()}    _id
    
    # Deleta produto
    ${response}=    Deletar Produto    ${product_id}
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Validar Mensagem na Resposta    ${response}    ${MSG_RECORD_DELETED}
