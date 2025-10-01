# ==========================================
# FILE: serverest.robot
# ==========================================
*** Settings ***
Resource    variables.robot
Resource    keywords.robot
Suite Setup    Criar Sessao

*** Test Cases ***
# LOGIN
TC01 Login Valido
    [Tags]    login
    ${r}=    Login    fulano@qa.com    teste
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_200}

TC02 Login Invalido
    [Tags]    login
    ${r}=    Login    invalido@test.com    senha
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_401}

# USUARIOS - GET /usuarios
TC03 Listar Usuarios
    [Tags]    usuarios
    ${r}=    Listar Usuarios
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_200}

# USUARIOS - POST /usuarios
TC04 Cadastrar Usuario
    [Tags]    usuarios
    ${email}=    Gerar Email
    ${r}=    Cadastrar Usuario    Nome Teste    ${email}    senha123    true
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_201}
    ${id}=    Set Variable    ${r.json()['_id']}
    Deletar Usuario    ${id}

TC05 Cadastrar Usuario Email Duplicado
    [Tags]    usuarios
    ${email}=    Gerar Email
    ${r1}=    Cadastrar Usuario    Nome    ${email}    senha    false
    ${r2}=    Cadastrar Usuario    Nome    ${email}    senha    false
    Should Be Equal As Numbers    ${r2.status_code}    ${STATUS_400}
    Deletar Usuario    ${r1.json()['_id']}

# USUARIOS - GET /usuarios/{_id}
TC06 Buscar Usuario Por ID
    [Tags]    usuarios
    ${email}=    Gerar Email
    ${r1}=    Cadastrar Usuario    Nome    ${email}    senha    true
    ${id}=    Set Variable    ${r1.json()['_id']}
    ${r2}=    Buscar Usuario    ${id}
    Should Be Equal As Numbers    ${r2.status_code}    ${STATUS_200}
    Deletar Usuario    ${id}

TC07 Buscar Usuario ID Inexistente
    [Tags]    usuarios
    ${r}=    Buscar Usuario    IDinvalido123
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_400}

# USUARIOS - PUT /usuarios/{_id}
TC08 Atualizar Usuario
    [Tags]    usuarios
    ${email}=    Gerar Email
    ${r1}=    Cadastrar Usuario    Nome    ${email}    senha    true
    ${id}=    Set Variable    ${r1.json()['_id']}
    ${email2}=    Gerar Email
    ${r2}=    Atualizar Usuario    ${id}    Novo Nome    ${email2}    nova    false
    Should Be Equal As Numbers    ${r2.status_code}    ${STATUS_200}
    Deletar Usuario    ${id}

# USUARIOS - DELETE /usuarios/{_id}
TC09 Deletar Usuario
    [Tags]    usuarios
    ${email}=    Gerar Email
    ${r1}=    Cadastrar Usuario    Nome    ${email}    senha    true
    ${id}=    Set Variable    ${r1.json()['_id']}
    ${r2}=    Deletar Usuario    ${id}
    Should Be Equal As Numbers    ${r2.status_code}    ${STATUS_200}

# PRODUTOS - GET /produtos
TC10 Listar Produtos
    [Tags]    produtos
    ${r}=    Listar Produtos
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_200}

# PRODUTOS - POST /produtos
TC11 Cadastrar Produto
    [Tags]    produtos
    ${r_login}=    Login    fulano@qa.com    teste
    ${token}=    Set Variable    ${r_login.json()['authorization']}
    ${nome}=    Generate Random String    10
    ${r}=    Cadastrar Produto    Produto ${nome}    100    Desc    50    ${token}
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_201}
    ${id}=    Set Variable    ${r.json()['_id']}
    Deletar Produto    ${id}    ${token}

TC12 Cadastrar Produto Sem Token
    [Tags]    produtos
    ${nome}=    Generate Random String    10
    ${r}=    Cadastrar Produto    Produto ${nome}    100    Desc    50    ${EMPTY}
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_401}

# PRODUTOS - GET /produtos/{_id}
TC13 Buscar Produto Por ID
    [Tags]    produtos
    ${r_login}=    Login    fulano@qa.com    teste
    ${token}=    Set Variable    ${r_login.json()['authorization']}
    ${nome}=    Generate Random String    10
    ${r1}=    Cadastrar Produto    Produto ${nome}    100    Desc    50    ${token}
    ${id}=    Set Variable    ${r1.json()['_id']}
    ${r2}=    Buscar Produto    ${id}
    Should Be Equal As Numbers    ${r2.status_code}    ${STATUS_200}
    Deletar Produto    ${id}    ${token}

TC14 Buscar Produto ID Inexistente
    [Tags]    produtos
    ${r}=    Buscar Produto    IDinvalido123
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_400}

# PRODUTOS - PUT /produtos/{_id}
TC15 Atualizar Produto
    [Tags]    produtos
    ${r_login}=    Login    fulano@qa.com    teste
    ${token}=    Set Variable    ${r_login.json()['authorization']}
    ${nome}=    Generate Random String    10
    ${r1}=    Cadastrar Produto    Produto ${nome}    100    Desc    50    ${token}
    ${id}=    Set Variable    ${r1.json()['_id']}
    ${nome2}=    Generate Random String    10
    ${r2}=    Atualizar Produto    ${id}    Novo ${nome2}    200    Nova    25    ${token}
    Should Be Equal As Numbers    ${r2.status_code}    ${STATUS_200}
    Deletar Produto    ${id}    ${token}

# PRODUTOS - DELETE /produtos/{_id}
TC16 Deletar Produto
    [Tags]    produtos
    ${r_login}=    Login    fulano@qa.com    teste
    ${token}=    Set Variable    ${r_login.json()['authorization']}
    ${nome}=    Generate Random String    10
    ${r1}=    Cadastrar Produto    Produto ${nome}    100    Desc    50    ${token}
    ${id}=    Set Variable    ${r1.json()['_id']}
    ${r2}=    Deletar Produto    ${id}    ${token}
    Should Be Equal As Numbers    ${r2.status_code}    ${STATUS_200}

# CARRINHOS - GET /carrinhos
TC17 Listar Carrinhos
    [Tags]    carrinhos
    ${r}=    Listar Carrinhos
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_200}

# CARRINHOS - POST /carrinhos
TC18 Cadastrar Carrinho
    [Tags]    carrinhos
    ${r_login}=    Login    fulano@qa.com    teste
    ${token}=    Set Variable    ${r_login.json()['authorization']}
    ${nome}=    Generate Random String    10
    ${r_prod}=    Cadastrar Produto    Produto ${nome}    100    Desc    50    ${token}
    ${prod_id}=    Set Variable    ${r_prod.json()['_id']}
    ${email}=    Gerar Email
    ${r_user}=    Cadastrar Usuario    Usuario    ${email}    senha123    false
    ${r_login2}=    Login    ${email}    senha123
    ${token2}=    Set Variable    ${r_login2.json()['authorization']}
    ${r}=    Cadastrar Carrinho    ${prod_id}    2    ${token2}
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_201}
    Cancelar Compra    ${token2}
    Deletar Produto    ${prod_id}    ${token}
    Deletar Usuario    ${r_user.json()['_id']}

# CARRINHOS - GET /carrinhos/{_id}
TC19 Buscar Carrinho Por ID
    [Tags]    carrinhos
    ${r_login}=    Login    fulano@qa.com    teste
    ${token}=    Set Variable    ${r_login.json()['authorization']}
    ${nome}=    Generate Random String    10
    ${r_prod}=    Cadastrar Produto    Produto ${nome}    100    Desc    50    ${token}
    ${prod_id}=    Set Variable    ${r_prod.json()['_id']}
    ${email}=    Gerar Email
    ${r_user}=    Cadastrar Usuario    Usuario    ${email}    senha123    false
    ${r_login2}=    Login    ${email}    senha123
    ${token2}=    Set Variable    ${r_login2.json()['authorization']}
    ${r_cart}=    Cadastrar Carrinho    ${prod_id}    2    ${token2}
    ${cart_id}=    Set Variable    ${r_cart.json()['_id']}
    ${r}=    Buscar Carrinho    ${cart_id}
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_200}
    Cancelar Compra    ${token2}
    Deletar Produto    ${prod_id}    ${token}
    Deletar Usuario    ${r_user.json()['_id']}

# CARRINHOS - DELETE /carrinhos/concluir-compra
TC20 Concluir Compra
    [Tags]    carrinhos
    ${r_login}=    Login    fulano@qa.com    teste
    ${token}=    Set Variable    ${r_login.json()['authorization']}
    ${nome}=    Generate Random String    10
    ${r_prod}=    Cadastrar Produto    Produto ${nome}    100    Desc    50    ${token}
    ${prod_id}=    Set Variable    ${r_prod.json()['_id']}
    ${email}=    Gerar Email
    ${r_user}=    Cadastrar Usuario    Usuario    ${email}    senha123    false
    ${r_login2}=    Login    ${email}    senha123
    ${token2}=    Set Variable    ${r_login2.json()['authorization']}
    Cadastrar Carrinho    ${prod_id}    2    ${token2}
    ${r}=    Concluir Compra    ${token2}
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_200}
    Deletar Produto    ${prod_id}    ${token}
    Deletar Usuario    ${r_user.json()['_id']}

# CARRINHOS - DELETE /carrinhos/cancelar-compra
TC21 Cancelar Compra
    [Tags]    carrinhos
    ${r_login}=    Login    fulano@qa.com    teste
    ${token}=    Set Variable    ${r_login.json()['authorization']}
    ${nome}=    Generate Random String    10
    ${r_prod}=    Cadastrar Produto    Produto ${nome}    100    Desc    50    ${token}
    ${prod_id}=    Set Variable    ${r_prod.json()['_id']}
    ${email}=    Gerar Email
    ${r_user}=    Cadastrar Usuario    Usuario    ${email}    senha123    false
    ${r_login2}=    Login    ${email}    senha123
    ${token2}=    Set Variable    ${r_login2.json()['authorization']}
    Cadastrar Carrinho    ${prod_id}    2    ${token2}
    ${r}=    Cancelar Compra    ${token2}
    Should Be Equal As Numbers    ${r.status_code}    ${STATUS_200}
    Deletar Produto    ${prod_id}    ${token}
    Deletar Usuario    ${r_user.json()['_id']}

*** Comments ***
# ENDPOINTS COBERTOS (21 testes):
# POST   /login (2)
# GET    /usuarios (1)
# POST   /usuarios (2)
# GET    /usuarios/{_id} (2)
# PUT    /usuarios/{_id} (1)
# DELETE /usuarios/{_id} (1)
# GET    /produtos (1)
# POST   /produtos (2)
# GET    /produtos/{_id} (2)
# PUT    /produtos/{_id} (1)
# DELETE /produtos/{_id} (1)
# GET    /carrinhos (1)
# POST   /carrinhos (1)
# GET    /carrinhos/{_id} (1)
# DELETE /carrinhos/concluir-compra (1)
# DELETE /carrinhos/cancelar-compra (1)

# EXECUTAR: robot -d tests/results tests/serverest.robot