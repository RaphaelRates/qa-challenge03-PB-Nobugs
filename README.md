# Challenge 03 - Testes Automatizados ServeRest

## 📋 Sobre o Challenge

Este repositório contém a implementação do **Challenge 03** focado na automação de testes da API ServeRest, uma aplicação de e-commerce para fins de treinamento e validação.

### 🎯 Objetivos Principais

1. **Refinamento do Planejamento** - Aplicar melhorias baseadas nos feedbacks anteriores
2. **Integração com QALity** - Utilização da ferramenta para execução e gestão de testes no Jira
3. **Automação com Robot Framework** - Desenvolvimento de testes automatizados robustos
4. **Infraestrutura Cloud** - Deploy da aplicação em instâncias EC2 AWS (atividade extra)

## 🏗️ Estrutura do Projeto

```
challenge03-serverest/
├── docs/
│   ├── plano_de_testes.md
│   ├── estrategia_testes.md
│   └── criterios_aceitacao.md
├── tests/
│   ├── robot/
│   │   ├── serverest_api_tests.robot
│   │   ├── resources/
│   │   └── results/
│   └── manual/
│       └── casos_de_teste/
└── README.md
```

## 🚀 Tecnologias Utilizadas

- **Robot Framework** - Automação de testes
- **RequestsLibrary** - Biblioteca para testes de API
- **Python** - Linguagem base
- **AWS EC2** - Infraestrutura cloud
- **QALity** - Integração com Jira
- **Git** - Controle de versão

## 📊 Estratégia de Testes

### Escopo de Automação

| Módulo | Cobertura | Prioridade |
|--------|-----------|------------|
| 🔐 Autenticação | 100% | Alta |
| 👥 Usuários | 100% | Alta |
| 📦 Produtos | 100% | Alta |
| 🛒 Carrinhos | 100% | Média |
| 🔒 Segurança | 80% | Alta |

### Tipos de Teste Implementados

- ✅ **Testes Funcionais** - Validação de endpoints
- ✅ **Testes de Regressão** - Garantia de estabilidade
- ✅ **Testes Negativos** - Tratamento de erros
- ✅ **Testes de Carga** - Performance básica

## 🛠️ Configuração do Ambiente

### Pré-requisitos

```bash
# Instalação das dependências
pip install robotframework
pip install robotframework-requests
pip install robotframework-jsonlibrary
```

### Execução dos Testes

```bash
# Executar todos os testes
robot tests/robot/serverest_api_tests.robot

# Executar por tags específicas
robot -i usuarios tests/robot/serverest_api_tests.robot
robot -i produtos tests/robot/serverest_api_tests.robot
robot -i carrinhos tests/robot/serverest_api_tests.robot
robot -i login tests/robot/serverest_api_tests.robot

# Executar testes com relatório detalhado
robot --report report.html --log log.html tests/robot/serverest_api_tests.robot
```

## 📈 Métricas de Qualidade

| Métrica | Meta | Atual |
|---------|------|-------|
| Cobertura de Testes | 90% | ⏳ |
| Taxa de Sucesso | 95% | ⏳ |
| Bugs Reportados | ≤ 5 | ⏳ |
| Tempo de Execução | < 5min | ⏳ |

## 🔄 Fluxo de Trabalho

1. **Planejamento** - Definição de casos no QALity/Jira
2. **Execução Manual** - Validação inicial dos cenários
3. **Automação** - Desenvolvimento dos scripts Robot
4. **Integração** - Execução contínua nos ambientes
5. **Report** - Análise de resultados e métricas

## 🐛 Gestão de Defeitos

- Todos os bugs identificados são reportados via QALity/Jira
- Classificação por severidade e prioridade
- Acompanhamento do ciclo de vida dos defects

## 🌐 Infraestrutura AWS (Atividade Extra)

### Arquitetura Proposta

```
[EC2 Test Runner] ←→ [EC2 ServeRest App]
     ↓
[Relatórios Robot] → [S3 Bucket]
```

### Scripts de Deploy

```bash
# Deploy da aplicação
./scripts/deploy_ec2.sh

# Configuração do ambiente de testes
./scripts/setup_environment.sh
```

## 📝 Entregáveis

- [ ] ✅ Planejamento de testes atualizado
- [ ] ✅ Casos de teste no QALity/Jira
- [ ] ✅ Scripts de automação Robot Framework
- [ ] ✅ Relatórios de execução e cobertura
- [ ] ✅ Documentação técnica
- [ ] ⏳ Configuração AWS EC2 (extra)

## 👥 Responsabilidades

| Atividade | Responsável |
|-----------|-------------|
| Planejamento e Estratégia | Individual |
| Automação de Testes | Individual |
| Gestão no QALity | Individual |
| Deploy AWS | Individual |

## 📞 Suporte

Para dúvidas ou issues relacionados aos testes:

1. Consultar documentação no `/docs`
2. Verificar issues abertas no repositório
3. Contatar via plataforma de mentoria

## 🔄 Atualizações

- **Diário** - Commits no repositório Git
- **Semanal** - Atualização da documentação
- **Final** - Apresentação dos resultados

---

**🎯 Meta Final**: Entrega de um suite de testes automatizados robusto com cobertura completa da API ServeRest e integração com ferramentas de gestão de qualidade.
