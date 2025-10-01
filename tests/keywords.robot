# ==========================================
# FILE: keywords.robot
# ==========================================
*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String

*** Keywords ***
Criar Sessao
    Create Session    api    ${BASE_URL}

Gerar Email
    ${random}=    Generate Random String    8    [LOWER]
    ${email}=     Set Variable    ${random}@qa.com.br
    [Return]    ${email}

Login
    [Arguments]    ${email}    ${password}
    &{body}=    Create Dictionary    email=${email}    password=${password}
    ${resp}=    POST On Session    api    /login    json=${body}    expected_status=any
    [Return]    ${resp}

Listar Usuarios
    ${resp}=    GET On Session    api    /usuarios    expected_status=any
    [Return]    ${resp}

Cadastrar Usuario
    [Arguments]    ${nome}    ${email}    ${password}    ${admin}
    &{body}=    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${admin}
    ${resp}=    POST On Session    api    /usuarios    json=${body}    expected_status=any
    [Return]    ${resp}

Buscar Usuario
    [Arguments]    ${id}
    ${resp}=    GET On Session    api    /usuarios/${id}    expected_status=any
    [Return]    ${resp}

Atualizar Usuario
    [Arguments]    ${id}    ${nome}    ${email}    ${password}    ${admin}
    &{body}=    Create Dictionary    nome=${nome}    email=${email}    password=${password}    administrador=${admin}
    ${resp}=    PUT On Session    api    /usuarios/${id}    json=${body}    expected_status=any
    [Return]    ${resp}

Deletar Usuario
    [Arguments]    ${id}
    ${resp}=    DELETE On Session    api    /usuarios/${id}    expected_status=any
    [Return]    ${resp}

Listar Produtos
    ${resp}=    GET On Session    api    /produtos    expected_status=any
    [Return]    ${resp}

Cadastrar Produto
    [Arguments]    ${nome}    ${preco}    ${desc}    ${qtd}    ${token}
    &{headers}=    Create Dictionary    Authorization=${token}
    &{body}=    Create Dictionary    nome=${nome}    preco=${preco}    descricao=${desc}    quantidade=${qtd}
    ${resp}=    POST On Session    api    /produtos    json=${body}    headers=${headers}    expected_status=any
    [Return]    ${resp}

Buscar Produto
    [Arguments]    ${id}
    ${resp}=    GET On Session    api    /produtos/${id}    expected_status=any
    [Return]    ${resp}

Atualizar Produto
    [Arguments]    ${id}    ${nome}    ${preco}    ${desc}    ${qtd}    ${token}
    &{headers}=    Create Dictionary    Authorization=${token}
    &{body}=    Create Dictionary    nome=${nome}    preco=${preco}    descricao=${desc}    quantidade=${qtd}
    ${resp}=    PUT On Session    api    /produtos/${id}    json=${body}    headers=${headers}    expected_status=any
    [Return]    ${resp}

Deletar Produto
    [Arguments]    ${id}    ${token}
    &{headers}=    Create Dictionary    Authorization=${token}
    ${resp}=    DELETE On Session    api    /produtos/${id}    headers=${headers}    expected_status=any
    [Return]    ${resp}

Listar Carrinhos
    ${resp}=    GET On Session    api    /carrinhos    expected_status=any
    [Return]    ${resp}

Cadastrar Carrinho
    [Arguments]    ${produto_id}    ${qtd}    ${token}
    &{headers}=    Create Dictionary    Authorization=${token}
    &{produto}=    Create Dictionary    idProduto=${produto_id}    quantidade=${qtd}
    @{produtos}=    Create List    ${produto}
    &{body}=    Create Dictionary    produtos=${produtos}
    ${resp}=    POST On Session    api    /carrinhos    json=${body}    headers=${headers}    expected_status=any
    [Return]    ${resp}

Buscar Carrinho
    [Arguments]    ${id}
    ${resp}=    GET On Session    api    /carrinhos/${id}    expected_status=any
    [Return]    ${resp}

Concluir Compra
    [Arguments]    ${token}
    &{headers}=    Create Dictionary    Authorization=${token}
    ${resp}=    DELETE On Session    api    /carrinhos/concluir-compra    headers=${headers}    expected_status=any
    [Return]    ${resp}

Cancelar Compra
    [Arguments]    ${token}
    &{headers}=    Create Dictionary    Authorization=${token}
    ${resp}=    DELETE On Session    api    /carrinhos/cancelar-compra    headers=${headers}    expected_status=any
    [Return]    ${resp}

