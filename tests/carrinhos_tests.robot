# ==========================================
# FILE: tests/carrinhos_tests.robot
# ==========================================
*** Settings ***
Documentation    Testes de Carrinhos da API ServeRest
Resource         ../resources/api_keywords.robot
Suite Setup      Run Keywords
...              Criar Sessão da API    AND
...              Realizar Login com Sucesso
Suite Teardown   Encerrar Sessão da API

*** Test Cases ***
TC-CART-001: Listar Todos os Carrinhos
    [Documentation]    Valida listagem de todos os carrinhos
    [Tags]    carrinhos    get    smoke
    
    ${response}=    Listar Carrinhos
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Validar Campo Presente na Resposta    ${response}    carrinhos

TC-CART-002: Cadastrar Carrinho com Produto Válido
    [Documentation]    Valida criação de carrinho
    [Tags]    carrinhos    post    positivo
    
    # Cria produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${product_response}=    Cadastrar Produto    ${produto}
    ${product_id}=    Get From Dictionary    ${product_response.json()}    _id
    
    # Cria carrinho
    ${carrinho}=    Criar Dados Carrinho    ${product_id}
    ${response}=    Cadastrar Carrinho    ${carrinho}
    
    Validar Status Code    ${response}    ${STATUS_CREATED}
    Validar Mensagem na Resposta    ${response}    ${MSG_CART_CREATED}
    
    # Cleanup
    Cancelar Compra
    Deletar Produto    ${product_id}

TC-CART-003: Criar Múltiplos Carrinhos Para Mesmo Usuário
    [Documentation]    Valida que usuário não pode ter múltiplos carrinhos
    [Tags]    carrinhos    post    negativo
    
    # Cria produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${product_response}=    Cadastrar Produto    ${produto}
    ${product_id}=    Get From Dictionary    ${product_response.json()}    _id
    
    # Cria primeiro carrinho
    ${carrinho}=    Criar Dados Carrinho    ${product_id}
    ${response1}=    Cadastrar Carrinho    ${carrinho}
    
    # Tenta criar segundo carrinho
    ${response2}=    Cadastrar Carrinho    ${carrinho}
    
    Validar Status Code    ${response2}    ${STATUS_BAD_REQUEST}
    Validar Mensagem na Resposta    ${response2}    ${MSG_CART_EXISTS}
    
    # Cleanup
    Cancelar Compra
    Deletar Produto    ${product_id}

TC-CART-004: Concluir Compra com Sucesso
    [Documentation]    Valida conclusão de compra
    [Tags]    carrinhos    delete    positivo    checkout
    
    # Cria produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${product_response}=    Cadastrar Produto    ${produto}
    ${product_id}=    Get From Dictionary    ${product_response.json()}    _id
    
    # Cria carrinho
    ${carrinho}=    Criar Dados Carrinho    ${product_id}
    Cadastrar Carrinho    ${carrinho}
    
    # Conclui compra
    ${response}=    Concluir Compra
    
    Validar Status Code    ${response}    ${STATUS_OK}
    Validar Mensagem na Resposta    ${response}    ${MSG_PURCHASE_COMPLETED}
    
    # Cleanup
    Deletar Produto    ${product_id}

TC-CART-005: Cancelar Compra com Sucesso
    [Documentation]    Valida cancelamento de compra
    [Tags]    carrinhos    delete    positivo
    
    # Cria produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${product_response}=    Cadastrar Produto    ${produto}
    ${product_id}=    Get From Dictionary    ${product_response.json()}    _id
    
    # Cria carrinho
    ${carrinho}=    Criar Dados Carrinho    ${product_id}
    Cadastrar Carrinho    ${carrinho}
    
    # Cancela compra
    ${response}=    Cancelar Compra
    
    Validar Status Code    ${response}    ${STATUS_OK}
    
    # Cleanup
    Deletar Produto    ${product_id}

