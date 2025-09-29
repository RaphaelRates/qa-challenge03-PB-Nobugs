*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
${BASE_URL}    https://serverest.dev
${EMAIL}       test@example.com
${PASSWORD}    teste123

*** Test Cases ***
Teste Completo Fluxo E-commerce ServeRest
    [Documentation]    Teste completo do fluxo de e-commerce: login, usuários, produtos e carrinho
    [Tags]    completo    fluxo-ecommerce
    
    Criar Sessão API
    Realizar Login Com Sucesso
    Cadastrar Novo Usuário
    Cadastrar Novo Produto
    Gerenciar Carrinho
    Finalizar Fluxo

Teste Endpoints Usuários
    [Documentation]    Testes específicos para endpoints de usuários
    [Tags]    usuarios    crud
    
    Criar Sessão API
    Realizar Login Com Sucesso
    
    # Teste GET /usuarios
    Listar Todos Usuários
    
    # Teste POST /usuarios
    ${USER_ID}=    Cadastrar Usuario Para Teste
    
    # Teste GET /usuarios/_id
    Buscar Usuario Por ID    ${USER_ID}
    
    # Teste PUT /usuarios/_id
    Atualizar Usuario    ${USER_ID}
    
    # Teste DELETE /usuarios/_id
    Deletar Usuario    ${USER_ID}

Teste Endpoints Produtos
    [Documentation]    Testes específicos para endpoints de produtos
    [Tags]    produtos    crud
    
    Criar Sessão API
    Realizar Login Admin
    
    # Teste GET /produtos
    Listar Todos Produtos
    
    # Teste POST /produtos
    ${PRODUCT_ID}=    Cadastrar Produto Para Teste
    
    # Teste GET /produtos/_id
    Buscar Produto Por ID    ${PRODUCT_ID}
    
    # Teste PUT /produtos/_id
    Atualizar Produto    ${PRODUCT_ID}
    
    # Teste DELETE /produtos/_id
    Deletar Produto    ${PRODUCT_ID}

Teste Endpoints Carrinhos
    [Documentation]    Testes específicos para endpoints de carrinhos
    [Tags]    carrinhos    fluxo-compra
    
    Criar Sessão API
    Realizar Login Com Sucesso
    ${PRODUCT_ID}=    Cadastrar Produto Para Teste
    
    # Teste GET /carrinhos
    Listar Todos Carrinhos
    
    # Teste POST /carrinhos
    ${CART_ID}=    Cadastrar Carrinho    ${PRODUCT_ID}
    
    # Teste GET /carrinhos/_id
    Buscar Carrinho Por ID    ${CART_ID}
    
    # Teste DELETE /carrinhos/concluir-compra
    Concluir Compra    ${CART_ID}
    
    # Teste DELETE /carrinhos/cancelar-compra
    Cancelar Compra    ${PRODUCT_ID}

Teste Login Com Credenciais Invalidas
    [Documentation]    Teste de login com credenciais inválidas
    [Tags]    login    negativo
    
    Criar Sessão API
    Tentar Login Com Credenciais Invalidas

*** Keywords ***
Criar Sessão API
    Create Session    serverest    ${BASE_URL}
    Set Suite Variable    ${SESSION}    serverest

Realizar Login Com Sucesso
    ${LOGIN_DATA}=    Create Dictionary
    ...    email=${EMAIL}
    ...    password=${PASSWORD}
    
    ${RESPONSE}=    POST On Session    ${SESSION}    /login    json=${LOGIN_DATA}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Dictionary Should Contain Key    ${RESPONSE.json()}    authorization
    ${TOKEN}=    Set Variable    ${RESPONSE.json()['authorization']}
    Set Suite Variable    ${AUTH_TOKEN}    ${TOKEN}

Realizar Login Admin
    ${ADMIN_EMAIL}=    Set Variable    admin@example.com
    ${ADMIN_PASSWORD}=    Set Variable    admin123
    
    ${LOGIN_DATA}=    Create Dictionary
    ...    email=${ADMIN_EMAIL}
    ...    password=${ADMIN_PASSWORD}
    
    ${RESPONSE}=    POST On Session    ${SESSION}    /login    json=${LOGIN_DATA}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    ${TOKEN}=    Set Variable    ${RESPONSE.json()['authorization']}
    Set Suite Variable    ${AUTH_TOKEN}    ${TOKEN}

Tentar Login Com Credenciais Invalidas
    ${INVALID_DATA}=    Create Dictionary
    ...    email=invalido@teste.com
    ...    password=senhaerrada
    
    ${RESPONSE}=    POST On Session    ${SESSION}    /login    json=${INVALID_DATA}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    401
    Should Contain    ${RESPONSE.text}    Email e/ou senha inválidos

Listar Todos Usuários
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    GET On Session    ${SESSION}    /usuarios    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Be True    len(${RESPONSE.json()['usuarios']}) >= 0

Cadastrar Usuario Para Teste
    ${RANDOM_NAME}=    Generate Random String    8    [LETTERS]
    ${RANDOM_EMAIL}=    Catenate    SEPARATOR=    ${RANDOM_NAME}    @teste.com
    
    ${USER_DATA}=    Create Dictionary
    ...    nome=Usuario ${RANDOM_NAME}
    ...    email=${RANDOM_EMAIL}
    ...    password=teste123
    ...    administrador=true
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    POST On Session    ${SESSION}    /usuarios    json=${USER_DATA}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    201
    Dictionary Should Contain Key    ${RESPONSE.json()}    _id
    ${USER_ID}=    Set Variable    ${RESPONSE.json()['_id']}
    [Return]    ${USER_ID}

Buscar Usuario Por ID
    [Arguments]    ${USER_ID}
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    GET On Session    ${SESSION}    /usuarios/${USER_ID}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Be Equal As Strings    ${RESPONSE.json()['_id']}    ${USER_ID}

Atualizar Usuario
    [Arguments]    ${USER_ID}
    
    ${UPDATE_DATA}=    Create Dictionary
    ...    nome=Usuario Atualizado
    ...    email=atualizado@teste.com
    ...    password=novaSenha123
    ...    administrador=false
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    PUT On Session    ${SESSION}    /usuarios/${USER_ID}    json=${UPDATE_DATA}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Contain    ${RESPONSE.text}    Registro alterado com sucesso

Deletar Usuario
    [Arguments]    ${USER_ID}
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    DELETE On Session    ${SESSION}    /usuarios/${USER_ID}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Contain    ${RESPONSE.text}    Registro excluído com sucesso

Listar Todos Produtos
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    GET On Session    ${SESSION}    /produtos    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Be True    len(${RESPONSE.json()['produtos']}) >= 0

Cadastrar Produto Para Teste
    ${RANDOM_NAME}=    Generate Random String    10    [LETTERS]
    
    ${PRODUCT_DATA}=    Create Dictionary
    ...    nome=Produto ${RANDOM_NAME}
    ...    preco=100
    ...    descricao=Descricao do produto ${RANDOM_NAME}
    ...    quantidade=50
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    POST On Session    ${SESSION}    /produtos    json=${PRODUCT_DATA}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    201
    Dictionary Should Contain Key    ${RESPONSE.json()}    _id
    ${PRODUCT_ID}=    Set Variable    ${RESPONSE.json()['_id']}
    [Return]    ${PRODUCT_ID}

Buscar Produto Por ID
    [Arguments]    ${PRODUCT_ID}
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    GET On Session    ${SESSION}    /produtos/${PRODUCT_ID}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Be Equal As Strings    ${RESPONSE.json()['_id']}    ${PRODUCT_ID}

Atualizar Produto
    [Arguments]    ${PRODUCT_ID}
    
    ${UPDATE_DATA}=    Create Dictionary
    ...    nome=Produto Atualizado
    ...    preco=150
    ...    descricao=Descricao atualizada
    ...    quantidade=25
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    PUT On Session    ${SESSION}    /produtos/${PRODUCT_ID}    json=${UPDATE_DATA}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Contain    ${RESPONSE.text}    Registro alterado com sucesso

Deletar Produto
    [Arguments]    ${PRODUCT_ID}
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    DELETE On Session    ${SESSION}    /produtos/${PRODUCT_ID}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Contain    ${RESPONSE.text}    Registro excluído com sucesso

Listar Todos Carrinhos
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    GET On Session    ${SESSION}    /carrinhos    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Be True    len(${RESPONSE.json()['carrinhos']}) >= 0

Cadastrar Carrinho
    [Arguments]    ${PRODUCT_ID}
    
    ${CART_ITEMS}=    Create List
    ${ITEM}=    Create Dictionary
    ...    idProduto=${PRODUCT_ID}
    ...    quantidade=2
    Append To List    ${CART_ITEMS}    ${ITEM}
    
    ${CART_DATA}=    Create Dictionary
    ...    produtos=${CART_ITEMS}
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    POST On Session    ${SESSION}    /carrinhos    json=${CART_DATA}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    201
    Dictionary Should Contain Key    ${RESPONSE.json()}    _id
    ${CART_ID}=    Set Variable    ${RESPONSE.json()['_id']}
    [Return]    ${CART_ID}

Buscar Carrinho Por ID
    [Arguments]    ${CART_ID}
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    GET On Session    ${SESSION}    /carrinhos/${CART_ID}    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Be Equal As Strings    ${RESPONSE.json()['_id']}    ${CART_ID}

Concluir Compra
    [Arguments]    ${CART_ID}
    
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    DELETE On Session    ${SESSION}    /carrinhos/concluir-compra    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Contain    ${RESPONSE.text}    Registro excluído com sucesso

Cancelar Compra
    [Arguments]    ${PRODUCT_ID}
    
    # Primeiro cria um carrinho
    ${CART_ID}=    Cadastrar Carrinho    ${PRODUCT_ID}
    
    # Depois cancela
    ${HEADERS}=    Create Dictionary    Authorization=${AUTH_TOKEN}
    ${RESPONSE}=    DELETE On Session    ${SESSION}    /carrinhos/cancelar-compra    headers=${HEADERS}
    
    Should Be Equal As Strings    ${RESPONSE.status_code}    200
    Should Contain    ${RESPONSE.text}    Registro excluído com sucesso

Cadastrar Novo Usuário
    ${USER_ID}=    Cadastrar Usuario Para Teste
    Set Suite Variable    ${TEST_USER_ID}    ${USER_ID}

Cadastrar Novo Produto
    ${PRODUCT_ID}=    Cadastrar Produto Para Teste
    Set Suite Variable    ${TEST_PRODUCT_ID}    ${PRODUCT_ID}

Gerenciar Carrinho
    ${CART_ID}=    Cadastrar Carrinho    ${TEST_PRODUCT_ID}
    Set Suite Variable    ${TEST_CART_ID}    ${CART_ID}

Finalizar Fluxo
    # Limpeza dos recursos criados nos testes
    Run Keyword If    '${TEST_CART_ID}' != '${EMPTY}'    Cancelar Compra    ${TEST_PRODUCT_ID}
    Run Keyword If    '${TEST_PRODUCT_ID}' != '${EMPTY}'    Deletar Produto    ${TEST_PRODUCT_ID}
    Run Keyword If    '${TEST_USER_ID}' != '${EMPTY}'    Deletar Usuario    ${TEST_USER_ID}