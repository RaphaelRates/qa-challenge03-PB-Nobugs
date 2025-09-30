# ==========================================
# FILE: resources/api_keywords.robot
# ==========================================
*** Settings ***
Library         RequestsLibrary
Library         Collections
Library         String
Library         FakerLibrary    locale=pt_BR
Resource        ../variables/config.robot

*** Keywords ***
# ====================
# SESSION MANAGEMENT
# ====================
Criar Sessão da API
    [Documentation]    Cria sessão HTTP com a API ServeRest
    Create Session    serverest    ${BASE_URL}    verify=True    timeout=${API_TIMEOUT}
    Set Suite Variable    ${SESSION}    serverest

Encerrar Sessão da API
    [Documentation]    Encerra a sessão HTTP
    Delete All Sessions

# ====================
# AUTHENTICATION
# ====================
Realizar Login
    [Arguments]    ${email}    ${password}
    [Documentation]    Realiza login e retorna o token de autenticação
    
    ${login_payload}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}
    
    ${response}=    POST On Session    ${SESSION}    /login
    ...    json=${login_payload}
    ...    expected_status=any
    
    [Return]    ${response}

Realizar Login com Sucesso
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    [Documentation]    Realiza login com credenciais válidas e armazena token
    
    ${response}=    Realizar Login    ${email}    ${password}
    
    Should Be Equal As Strings    ${response.status_code}    ${STATUS_OK}
    Dictionary Should Contain Key    ${response.json()}    authorization
    
    ${token}=    Get From Dictionary    ${response.json()}    authorization
    Set Suite Variable    ${AUTH_TOKEN}    ${token}
    
    [Return]    ${token}

Validar Login com Sucesso
    [Arguments]    ${response}
    [Documentation]    Valida resposta de login bem-sucedido
    
    Should Be Equal As Strings    ${response.status_code}    ${STATUS_OK}
    Dictionary Should Contain Key    ${response.json()}    authorization
    Dictionary Should Contain Key    ${response.json()}    message
    Should Contain    ${response.json()['message']}    ${MSG_LOGIN_SUCCESS}

Validar Login com Falha
    [Arguments]    ${response}
    [Documentation]    Valida resposta de login com falha
    
    Should Be Equal As Strings    ${response.status_code}    ${STATUS_UNAUTHORIZED}
    Should Contain    ${response.json()['message']}    ${MSG_LOGIN_FAILED}

# ====================
# USUARIOS ENDPOINTS
# ====================
Gerar Dados Usuario Aleatorio
    [Documentation]    Gera dados aleatórios para criação de usuário
    
    ${nome}=          FakerLibrary.Name
    ${email}=         FakerLibrary.Email
    ${password}=      FakerLibrary.Password    length=10
    ${admin}=         Evaluate    random.choice([True, False])    random
    
    ${usuario}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=${password}
    ...    administrador=${admin}
    
    [Return]    ${usuario}

Listar Usuarios
    [Arguments]    ${token}=${AUTH_TOKEN}    ${query_params}=${EMPTY}
    [Documentation]    Lista todos os usuários (GET /usuarios)
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    GET On Session    ${SESSION}    /usuarios
    ...    headers=${headers}
    ...    params=${query_params}
    ...    expected_status=any
    
    [Return]    ${response}

Cadastrar Usuario
    [Arguments]    ${usuario_data}    ${token}=${AUTH_TOKEN}
    [Documentation]    Cadastra novo usuário (POST /usuarios)
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    POST On Session    ${SESSION}    /usuarios
    ...    json=${usuario_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Buscar Usuario Por ID
    [Arguments]    ${user_id}    ${token}=${AUTH_TOKEN}
    [Documentation]    Busca usuário específico (GET /usuarios/{_id})
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    GET On Session    ${SESSION}    /usuarios/${user_id}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Atualizar Usuario
    [Arguments]    ${user_id}    ${usuario_data}    ${token}=${AUTH_TOKEN}
    [Documentation]    Atualiza usuário existente (PUT /usuarios/{_id})
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    PUT On Session    ${SESSION}    /usuarios/${user_id}
    ...    json=${usuario_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Deletar Usuario
    [Arguments]    ${user_id}    ${token}=${AUTH_TOKEN}
    [Documentation]    Deleta usuário (DELETE /usuarios/{_id})
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    DELETE On Session    ${SESSION}    /usuarios/${user_id}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

# ====================
# PRODUTOS ENDPOINTS
# ====================
Gerar Dados Produto Aleatorio
    [Documentation]    Gera dados aleatórios para criação de produto
    
    ${nome}=          FakerLibrary.Company
    ${preco}=         Evaluate    random.randint(10, 1000)    random
    ${descricao}=     FakerLibrary.Text    max_nb_chars=200
    ${quantidade}=    Evaluate    random.randint(1, 100)    random
    
    ${produto}=    Create Dictionary
    ...    nome=Produto ${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    
    [Return]    ${produto}

Listar Produtos
    [Arguments]    ${token}=${AUTH_TOKEN}    ${query_params}=${EMPTY}
    [Documentation]    Lista todos os produtos (GET /produtos)
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    GET On Session    ${SESSION}    /produtos
    ...    headers=${headers}
    ...    params=${query_params}
    ...    expected_status=any
    
    [Return]    ${response}

Cadastrar Produto
    [Arguments]    ${produto_data}    ${token}=${AUTH_TOKEN}
    [Documentation]    Cadastra novo produto (POST /produtos) - Requer admin
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    POST On Session    ${SESSION}    /produtos
    ...    json=${produto_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Buscar Produto Por ID
    [Arguments]    ${product_id}    ${token}=${AUTH_TOKEN}
    [Documentation]    Busca produto específico (GET /produtos/{_id})
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    GET On Session    ${SESSION}    /produtos/${product_id}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Atualizar Produto
    [Arguments]    ${product_id}    ${produto_data}    ${token}=${AUTH_TOKEN}
    [Documentation]    Atualiza produto existente (PUT /produtos/{_id})
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    PUT On Session    ${SESSION}    /produtos/${product_id}
    ...    json=${produto_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Deletar Produto
    [Arguments]    ${product_id}    ${token}=${AUTH_TOKEN}
    [Documentation]    Deleta produto (DELETE /produtos/{_id})
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    DELETE On Session    ${SESSION}    /produtos/${product_id}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

# ====================
# CARRINHOS ENDPOINTS
# ====================
Criar Dados Carrinho
    [Arguments]    ${product_id}    ${quantidade}=2
    [Documentation]    Cria estrutura de dados para carrinho
    
    ${item}=    Create Dictionary
    ...    idProduto=${product_id}
    ...    quantidade=${quantidade}
    
    ${produtos}=    Create List    ${item}
    
    ${carrinho}=    Create Dictionary    produtos=${produtos}
    
    [Return]    ${carrinho}

Listar Carrinhos
    [Arguments]    ${token}=${AUTH_TOKEN}
    [Documentation]    Lista todos os carrinhos (GET /carrinhos)
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    GET On Session    ${SESSION}    /carrinhos
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Cadastrar Carrinho
    [Arguments]    ${carrinho_data}    ${token}=${AUTH_TOKEN}
    [Documentation]    Cadastra novo carrinho (POST /carrinhos)
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    POST On Session    ${SESSION}    /carrinhos
    ...    json=${carrinho_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Buscar Carrinho Por ID
    [Arguments]    ${cart_id}    ${token}=${AUTH_TOKEN}
    [Documentation]    Busca carrinho específico (GET /carrinhos/{_id})
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    GET On Session    ${SESSION}    /carrinhos/${cart_id}
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Concluir Compra
    [Arguments]    ${token}=${AUTH_TOKEN}
    [Documentation]    Conclui compra do carrinho (DELETE /carrinhos/concluir-compra)
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    DELETE On Session    ${SESSION}    /carrinhos/concluir-compra
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

Cancelar Compra
    [Arguments]    ${token}=${AUTH_TOKEN}
    [Documentation]    Cancela compra do carrinho (DELETE /carrinhos/cancelar-compra)
    
    ${headers}=    Create Dictionary    Authorization=${token}
    
    ${response}=    DELETE On Session    ${SESSION}    /carrinhos/cancelar-compra
    ...    headers=${headers}
    ...    expected_status=any
    
    [Return]    ${response}

# ====================
# VALIDATION KEYWORDS
# ====================
Validar Status Code
    [Arguments]    ${response}    ${expected_status}
    [Documentation]    Valida o status code da resposta
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}

Validar Mensagem na Resposta
    [Arguments]    ${response}    ${expected_message}
    [Documentation]    Valida se mensagem esperada está na resposta
    Should Contain    ${response.json()['message']}    ${expected_message}

Validar Campo Presente na Resposta
    [Arguments]    ${response}    ${field_name}
    [Documentation]    Valida se campo está presente no JSON de resposta
    Dictionary Should Contain Key    ${response.json()}    ${field_name}

Validar Lista Nao Vazia
    [Arguments]    ${response}    ${list_key}
    [Documentation]    Valida que lista retornada não está vazia
    ${lista}=    Get From Dictionary    ${response.json()}    ${list_key}
    Should Not Be Empty    ${lista}
