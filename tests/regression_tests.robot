# ==========================================
# FILE: tests/regression_tests.robot
# ==========================================
*** Settings ***
Documentation    Testes de Regressão - Fluxo Completo E-commerce
Resource         ../resources/api_keywords.robot
Suite Setup      Criar Sessão da API
Suite Teardown   Encerrar Sessão da API

*** Test Cases ***
TC-REG-001: Fluxo Completo E-commerce End-to-End
    [Documentation]    Testa fluxo completo: login > cadastros > compra
    [Tags]    regressao    e2e    smoke
    
    # 1. Login
    ${token}=    Realizar Login com Sucesso
    
    # 2. Cadastrar usuário
    ${usuario}=    Gerar Dados Usuario Aleatorio
    ${user_response}=    Cadastrar Usuario    ${usuario}    ${token}
    ${user_id}=    Get From Dictionary    ${user_response.json()}    _id
    
    # 3. Cadastrar produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${product_response}=    Cadastrar Produto    ${produto}    ${token}
    ${product_id}=    Get From Dictionary    ${product_response.json()}    _id
    
    # 4. Criar carrinho
    ${carrinho}=    Criar Dados Carrinho    ${product_id}
    ${cart_response}=    Cadastrar Carrinho    ${carrinho}    ${token}
    
    # 5. Concluir compra
    ${purchase_response}=    Concluir Compra    ${token}
    Validar Status Code    ${purchase_response}    ${STATUS_OK}
    
    # 6. Cleanup
    Deletar Produto    ${product_id}    ${token}
    Deletar Usuario    ${user_id}    ${token}

TC-REG-002: Fluxo de Cancelamento de Compra
    [Documentation]    Testa fluxo de criação e cancelamento de carrinho
    [Tags]    regressao    carrinho
    
    # 1. Login
    ${token}=    Realizar Login com Sucesso
    
    # 2. Cadastrar produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${product_response}=    Cadastrar Produto    ${produto}    ${token}
    ${product_id}=    Get From Dictionary    ${product_response.json()}    _id
    
    # 3. Criar carrinho
    ${carrinho}=    Criar Dados Carrinho    ${product_id}
    Cadastrar Carrinho    ${carrinho}    ${token}
    
    # 4. Cancelar compra
    ${cancel_response}=    Cancelar Compra    ${token}
    Validar Status Code    ${cancel_response}    ${STATUS_OK}
    
    # 5. Cleanup
    Deletar Produto    ${product_id}    ${token}

TC-REG-003: Fluxo CRUD Completo de Usuários
    [Documentation]    Testa operações completas em usuários
    [Tags]    regressao    usuarios
    
    # 1. Login
    ${token}=    Realizar Login com Sucesso
    
    # 2. Criar usuário
    ${usuario}=    Gerar Dados Usuario Aleatorio
    ${create_response}=    Cadastrar Usuario    ${usuario}    ${token}
    ${user_id}=    Get From Dictionary    ${create_response.json()}    _id
    Validar Status Code    ${create_response}    ${STATUS_CREATED}
    
    # 3. Listar e verificar presença
    ${list_response}=    Listar Usuarios    ${token}
    Validar Status Code    ${list_response}    ${STATUS_OK}
    
    # 4. Buscar por ID
    ${get_response}=    Buscar Usuario Por ID    ${user_id}    ${token}
    Validar Status Code    ${get_response}    ${STATUS_OK}
    
    # 5. Atualizar
    ${usuario_atualizado}=    Gerar Dados Usuario Aleatorio
    ${update_response}=    Atualizar Usuario    ${user_id}    ${usuario_atualizado}    ${token}
    Validar Status Code    ${update_response}    ${STATUS_OK}
    
    # 6. Deletar
    ${delete_response}=    Deletar Usuario    ${user_id}    ${token}
    Validar Status Code    ${delete_response}    ${STATUS_OK}

TC-REG-004: Fluxo CRUD Completo de Produtos
    [Documentation]    Testa operações completas em produtos
    [Tags]    regressao    produtos
    
    # 1. Login
    ${token}=    Realizar Login com Sucesso
    
    # 2. Criar produto
    ${produto}=    Gerar Dados Produto Aleatorio
    ${create_response}=    Cadastrar Produto    ${produto}    ${token}
    ${product_id}=    Get From Dictionary    ${create_response.json()}    _id
    Validar Status Code    ${create_response}    ${STATUS_CREATED}
    
    # 3. Listar e verificar presença
    ${list_response}=    Listar Produtos    ${token}
    Validar Status Code    ${list_response}    ${STATUS_OK}
    
    # 4. Buscar por ID
    ${get_response}=    Buscar Produto Por ID    ${product_id}    ${token}
    Validar Status Code    ${get_response}    ${STATUS_OK}
    
    # 5. Atualizar
    ${produto_atualizado}=    Gerar Dados Produto Aleatorio
    ${update_response}=    Atualizar Produto    ${product_id}    ${produto_atualizado}    ${token}
    Validar Status Code    ${update_response}    ${STATUS_OK}
    
    # 6. Deletar
    ${delete_response}=    Deletar Produto    ${product_id}    ${token}
    Validar Status Code    ${delete_response}    ${STATUS_OK}
