
# QA Challenge 03 - PB Nobugs

Este projeto faz parte da série **QA Challenge**, com foco em testes automatizados e práticas de qualidade de software.

## Estrutura do Projeto

* **`tests/`** – Scripts de testes automatizados em Robot Framework.
* **`docs/`** – Documentação e materiais de apoio.

## Pré-requisitos

* [Python 3.x](https://www.python.org/downloads/) instalado
* [pip](https://pip.pypa.io/en/stable/installation/) atualizado
* [Robot Framework](https://robotframework.org/)

Instale o Robot Framework e bibliotecas necessárias:

```bash
pip install -r requirements.txt
```

## Como Executar os Testes

1. Clone o repositório:

   ```bash
   git clone https://github.com/yourusername/qa-challenge03-PB-Nobugs.git
   cd qa-challenge03-PB-Nobugs
   ```

2. Execute os testes (exemplo com o Serverest):

   ```bash
   robot -d tests/results tests/serverest.robot
   ```

   * `-d tests/results` → Define a pasta de saída dos relatórios.
   * `tests/serverest.robot` → Arquivo de teste a ser executado.

3. Após a execução, consulte os relatórios em:

   ```
   tests/results/report.html
   tests/results/log.html
   ```

## Tecnologias Utilizadas

* **Robot Framework**
* **Python**
* Bibliotecas auxiliares para automação de testes de API e UI

## Contribuindo

Contribuições são bem-vindas!
Abra uma issue ou envie um pull request com melhorias.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).

