*** Variables ***
# API Configuration
${BASE_URL}                 https://serverest.dev
${API_TIMEOUT}              10

# Test Data
${VALID_EMAIL}              qa.teste@serverest.com
${VALID_PASSWORD}           teste@123
${INVALID_EMAIL}            invalido@test.com
${INVALID_PASSWORD}         senhaerrada

# Expected Status Codes
${STATUS_OK}                200
${STATUS_CREATED}           201
${STATUS_BAD_REQUEST}       400
${STATUS_UNAUTHORIZED}      401
${STATUS_FORBIDDEN}         403
${STATUS_NOT_FOUND}         404

# Expected Messages
${MSG_LOGIN_SUCCESS}        Login realizado com sucesso
${MSG_LOGIN_FAILED}         Email e/ou senha inválidos
${MSG_USER_CREATED}         Cadastro realizado com sucesso
${MSG_USER_EXISTS}          Este email já está sendo usado
${MSG_RECORD_UPDATED}       Registro alterado com sucesso
${MSG_RECORD_DELETED}       Registro excluído com sucesso
${MSG_PRODUCT_CREATED}      Cadastro realizado com sucesso
${MSG_CART_CREATED}         Cadastro realizado com sucesso
${MSG_CART_EXISTS}          Já existe carrinho cadastrado
${MSG_PURCHASE_COMPLETED}   Registro excluído com sucesso
${MSG_UNAUTHORIZED}         Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

