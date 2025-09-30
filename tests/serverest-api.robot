*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String

*** Variables ***
# ============ URL BASE ============
${BASE_URL}    https://serverest.dev

# ============ CREDENCIAIS ============
${EMAIL}                fulano@qa.com
${PASSWORD}             teste
${ADMIN_EMAIL}          beltrano@qa.com
${ADMIN_PASSWORD}       teste
${INVALID_EMAIL}        invalido@teste.com
${INVALID_PASSWORD}     senhaerrada

# ============ HEADERS ============
&{DEFAULT_HEADERS}      Content-Type=application/json

# ============ VARIÁVEIS DE TESTE ============
${USER_ID}              
${PRODUCT_ID}          
${CART_ID}              
${AUTH_TOKEN}           

*** Test Cases ***
# ============ TESTES DE FLUXO COMPLETO ============
Teste Completo Fluxo E-commerce ServeRest
    [Documentation]    Teste completo do fluxo de e-commerce: login, usuários, produtos e carrinho
    [Tags]    completo    fluxo-ecommerce
    
    Criar Sessão API
    Realizar Login Com Sucesso
    Cadastrar Novo Usuário
    Cadastrar Novo Produto
    Gerenciar Carrinho
    Finalizar Fluxo

# ============ TESTES DE USUÁRIOS ============
Teste Endpoints Usuários
    [Documentation]    Testes específicos para endpoints de usuários
    [Tags]    usuarios    crud
    
    Criar Sessão API
    Realizar Login Com Sucesso
    Listar Todos Usuários
    ${USER_ID}=    Cadastrar Usuario Para Teste
    Buscar Usuario Por ID    ${USER_ID}
    Atualizar Usuario    ${USER_ID}
    Deletar Usuario    ${USER_ID}

Teste Cadastro Usuario Com Dados Validos
    [Documentation]    Teste de cadastro de usuário com dados válidos
    [Tags]    usuarios    positivo
    
    Criar Sessão API
    ${USER_ID}=    Cadastrar Usuario Para Teste
    Deletar Usuario    ${USER_ID}

# ============ TESTES DE PRODUTOS ============
Teste Endpoints Produtos
    [Documentation]    Testes específicos para endpoints de produtos
    [Tags]    produtos    crud
    
    Criar Sessão API
    Realizar Login Com Sucesso
    Listar Todos Produtos
    ${PRODUCT_ID}=    Cadastrar Produto Para Teste
    Buscar Produto Por ID    ${PRODUCT_ID}
    Atualizar Produto    ${PRODUCT_ID}
    Deletar Produto    ${PRODUCT_ID}

Teste Cadastro Produto Com Dados Validos
    [Documentation]    Teste de cadastro de produto com dados válidos
    [Tags]    produtos    positivo
    
    Criar Sessão API
    Realizar Login Com Sucesso
    ${PRODUCT_ID}=    Cadastrar Produto Para Teste
    Deletar Produto    ${PRODUCT_ID}

# ============ TESTES DE CARRINHOS ============
Teste Endpoints Carrinhos
    [Documentation]    Testes específicos para endpoints de carrinhos
    [Tags]    carrinhos    fluxo-compra
    
    Criar Sessão API
    Realizar Login Com Sucesso
    ${PRODUCT_ID}=    Cadastrar Produto Para Teste
    Listar Todos Carrinhos
    ${CART_ID}=    Cadastrar Carrinho    ${PRODUCT_ID}
    Buscar Carrinho Por ID    ${CART_ID}
    Concluir Compra
    Deletar Produto    ${PRODUCT_ID}

Teste Fluxo Completo Compra
    [Documentation]    Teste do fluxo completo de compra
    [Tags]    carrinhos    fluxo-compra
    
    Criar Sessão API
    Realizar Login Com Sucesso
    ${PRODUCT_ID}=    Cadastrar Produto Para Teste
    ${CART_ID}=    Cadastrar Carrinho    ${PRODUCT_ID}
    Cancelar Compra
    Deletar Produto    ${PRODUCT_ID}

# ============ TESTES DE LOGIN ============
Teste Login Com Credenciais Validas
    [Documentation]    Teste de login com credenciais válidas
    [Tags]    login    positivo
    
    Criar Sessão API
    Realizar Login Com Sucesso

Teste Login Com Credenciais Invalidas
    [Documentation]    Teste de login com credenciais inválidas
    [Tags]    login    negativo
    
    Criar Sessão API
    Tentar Login Com Credenciais Invalidas

Teste Login Como Administrador
    [Documentation]    Teste de login como administrador
    [Tags]    login    admin
    
    Criar Sessão API
    Realizar Login Admin

*** Keywords ***
# ============ KEYWORDS DE CONFIGURAÇÃO ============
Criar Sessão API
    Create Session    serverest    ${BASE_URL}    headers=&{DEFAULT_HEADERS}
    Set Suite Variable    ${SESSION}    serverest

Criar Headers Com Auth
    ${HEADERS}=    Create Dictionary
    ...    Authorization=${AUTH_TOKEN}
    ...    Content-Type=application/json
    [Return]    ${HEADERS}

# ============ KEYWORDS DE LOGIN ============
Realizar Login Com Sucesso
    ${LOGIN_DATA}=    Criar Dados Login    ${EMAIL}    ${PASSWORD}
    ${RESPONSE}=    POST On Session    ${SESSION}    /login    json=${LOGIN_DATA}
    Validar Login Com Sucesso    ${RESPONSE}

Realizar Login Admin
    ${LOGIN_DATA}=    Criar Dados Login    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${RESPONSE}=    POST On Session    ${SESSION}    /login    json=${LOGIN_DATA}
    Validar Login Com Sucesso    ${RESPONSE}

Tentar Login Com Credenciais Invalidas
    ${LOGIN_DATA}=    Criar Dados Login    ${INVALID_EMAIL}    ${INVALID_PASSWORD}
    ${RESPONSE}=    POST On Session    ${SESSION}    /login    json=${LOGIN_DATA}
    Validar Login Com Falha    ${RESPONSE}

Criar Dados Login
    [Arguments]    ${email}    ${password}
    ${LOGIN_DATA}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}
    [Return]    ${LOGIN_DATA}

Validar Login Com Sucesso
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    authorization
    ${TOKEN}=    Set Variable    ${response.json()['authorization']}
    Set Suite Variable    ${AUTH_TOKEN}    ${TOKEN}
    Log    Token obtido: ${TOKEN}

Validar Login Com Falha
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    401
    Should Contain    ${response.text}    Email e/ou senha inválidos

# ============ KEYWORDS DE USUÁRIOS ============
Listar Todos Usuários
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    GET On Session    ${SESSION}    /usuarios    headers=${HEADERS}
    Validar Resposta Sucesso    ${RESPONSE}
    Should Be True    ${RESPONSE.json()['quantidade']} >= 0

Cadastrar Usuario Para Teste
    ${USER_DATA}=    Criar Dados Usuario Valido
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    POST On Session    ${SESSION}    /usuarios    json=${USER_DATA}    headers=${HEADERS}
    Validar Cadastro Sucesso    ${RESPONSE}
    ${USER_ID}=    Set Variable    ${RESPONSE.json()['_id']}
    [Return]    ${USER_ID}

Buscar Usuario Por ID
    [Arguments]    ${user_id}
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    GET On Session    ${SESSION}    /usuarios/${user_id}    headers=${HEADERS}
    Validar Resposta Sucesso    ${RESPONSE}
    Should Be Equal As Strings    ${RESPONSE.json()['_id']}    ${user_id}

Atualizar Usuario
    [Arguments]    ${user_id}
    ${UPDATE_DATA}=    Criar Dados Usuario Atualizado
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    PUT On Session    ${SESSION}    /usuarios/${user_id}    json=${UPDATE_DATA}    headers=${HEADERS}
    Validar Atualizacao Sucesso    ${RESPONSE}

Deletar Usuario
    [Arguments]    ${user_id}
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    DELETE On Session    ${SESSION}    /usuarios/${user_id}    headers=${HEADERS}
    Validar Exclusao Sucesso    ${RESPONSE}

Criar Dados Usuario Valido
    ${RANDOM_NAME}=    Generate Random String    8    [LETTERS]
    ${RANDOM_EMAIL}=    Catenate    SEPARATOR=    ${RANDOM_NAME}    @qa.com
    ${USER_DATA}=    Create Dictionary
    ...    nome=Usuario ${RANDOM_NAME}
    ...    email=${RANDOM_EMAIL}
    ...    password=teste123
    ...    administrador=true
    [Return]    ${USER_DATA}

Criar Dados Usuario Atualizado
    ${RANDOM_NAME}=    Generate Random String    8    [LETTERS]
    ${RANDOM_EMAIL}=    Catenate    SEPARATOR=    ${RANDOM_NAME}    @qa.com
    ${UPDATE_DATA}=    Create Dictionary
    ...    nome=Usuario Atualizado ${RANDOM_NAME}
    ...    email=${RANDOM_EMAIL}
    ...    password=novaSenha123
    ...    administrador=false
    [Return]    ${UPDATE_DATA}

# ============ KEYWORDS DE PRODUTOS ============
Listar Todos Produtos
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    GET On Session    ${SESSION}    /produtos    headers=${HEADERS}
    Validar Resposta Sucesso    ${RESPONSE}
    Should Be True    ${RESPONSE.json()['quantidade']} >= 0

Cadastrar Produto Para Teste
    ${PRODUCT_DATA}=    Criar Dados Produto Valido
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    POST On Session    ${SESSION}    /produtos    json=${PRODUCT_DATA}    headers=${HEADERS}
    Validar Cadastro Sucesso    ${RESPONSE}
    ${PRODUCT_ID}=    Set Variable    ${RESPONSE.json()['_id']}
    [Return]    ${PRODUCT_ID}

Buscar Produto Por ID
    [Arguments]    ${product_id}
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    GET On Session    ${SESSION}    /produtos/${product_id}    headers=${HEADERS}
    Validar Resposta Sucesso    ${RESPONSE}
    Should Be Equal As Strings    ${RESPONSE.json()['_id']}    ${product_id}

Atualizar Produto
    [Arguments]    ${product_id}
    ${UPDATE_DATA}=    Criar Dados Produto Atualizado
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    PUT On Session    ${SESSION}    /produtos/${product_id}    json=${UPDATE_DATA}    headers=${HEADERS}
    Validar Atualizacao Sucesso    ${RESPONSE}

Deletar Produto
    [Arguments]    ${product_id}
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    DELETE On Session    ${SESSION}    /produtos/${product_id}    headers=${HEADERS}
    Validar Exclusao Sucesso    ${RESPONSE}

Criar Dados Produto Valido
    ${RANDOM_NAME}=    Generate Random String    10    [LETTERS]
    ${PRODUCT_DATA}=    Create Dictionary
    ...    nome=Produto ${RANDOM_NAME}
    ...    preco=100
    ...    descricao=Descricao do produto ${RANDOM_NAME}
    ...    quantidade=50
    Log    Dados do produto: ${PRODUCT_DATA}
    [Return]    ${PRODUCT_DATA}

Criar Dados Produto Atualizado
    ${RANDOM_NAME}=    Generate Random String    10    [LETTERS]
    ${UPDATE_DATA}=    Create Dictionary
    ...    nome=Produto Atualizado ${RANDOM_NAME}
    ...    preco=150
    ...    descricao=Descricao atualizada ${RANDOM_NAME}
    ...    quantidade=25
    [Return]    ${UPDATE_DATA}

# ============ KEYWORDS DE CARRINHOS ============
Listar Todos Carrinhos
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    GET On Session    ${SESSION}    /carrinhos    headers=${HEADERS}
    Validar Resposta Sucesso    ${RESPONSE}
    Should Be True    ${RESPONSE.json()['quantidade']} >= 0

Cadastrar Carrinho
    [Arguments]    ${product_id}
    ${CART_DATA}=    Criar Dados Carrinho    ${product_id}
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    POST On Session    ${SESSION}    /carrinhos    json=${CART_DATA}    headers=${HEADERS}
    Validar Cadastro Carrinho Sucesso    ${RESPONSE}
    ${CART_ID}=    Set Variable    ${RESPONSE.json()['_id']}
    [Return]    ${CART_ID}

Buscar Carrinho Por ID
    [Arguments]    ${cart_id}
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    GET On Session    ${SESSION}    /carrinhos/${cart_id}    headers=${HEADERS}
    Validar Resposta Sucesso    ${RESPONSE}
    Should Be Equal As Strings    ${RESPONSE.json()['_id']}    ${cart_id}

Concluir Compra
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    DELETE On Session    ${SESSION}    /carrinhos/concluir-compra    headers=${HEADERS}
    Validar Exclusao Sucesso    ${RESPONSE}

Cancelar Compra
    ${HEADERS}=    Criar Headers Com Auth
    ${RESPONSE}=    DELETE On Session    ${SESSION}    /carrinhos/cancelar-compra    headers=${HEADERS}
    Validar Exclusao Sucesso    ${RESPONSE}

Criar Dados Carrinho
    [Arguments]    ${product_id}
    ${CART_ITEMS}=    Create List
    ${ITEM}=    Create Dictionary
    ...    idProduto=${product_id}
    ...    quantidade=1
    Append To List    ${CART_ITEMS}    ${ITEM}
    ${CART_DATA}=    Create Dictionary
    ...    produtos=${CART_ITEMS}
    Log    Dados do carrinho: ${CART_DATA}
    [Return]    ${CART_DATA}

# ============ KEYWORDS DE FLUXO COMPLETO ============
Cadastrar Novo Usuário
    ${USER_ID}=    Cadastrar Usuario Para Teste
    Set Suite Variable    ${USER_ID}    ${USER_ID}

Cadastrar Novo Produto
    ${PRODUCT_ID}=    Cadastrar Produto Para Teste
    Set Suite Variable    ${PRODUCT_ID}    ${PRODUCT_ID}

Gerenciar Carrinho
    ${CART_ID}=    Cadastrar Carrinho    ${PRODUCT_ID}
    Set Suite Variable    ${CART_ID}    ${CART_ID}

Finalizar Fluxo
    Run Keyword If    '${CART_ID}' != '${EMPTY}'    Cancelar Compra
    Run Keyword If    '${PRODUCT_ID}' != '${EMPTY}'    Deletar Produto    ${PRODUCT_ID}
    Run Keyword If    '${USER_ID}' != '${EMPTY}'    Deletar Usuario    ${USER_ID}

# ============ KEYWORDS DE VALIDAÇÃO ============
Validar Resposta Sucesso
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    200
    Log    Resposta: ${response.text}

Validar Cadastro Sucesso
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    _id
    Log    Cadastro realizado: ${response.text}

Validar Cadastro Carrinho Sucesso
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    _id
    Log    Carrinho criado: ${response.text}

Validar Atualizacao Sucesso
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    Registro alterado com sucesso

Validar Exclusao Sucesso
    [Arguments]    ${response}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Contain    ${response.text}    Registro excluído com sucesso
    