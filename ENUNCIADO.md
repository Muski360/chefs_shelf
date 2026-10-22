# Situação de Aprendizagem 1: O Caderno de Receitas Digital ("Chef's Shelf")

**Foco da Avaliação:** Modelagem de dados complexos no Firestore (arrays e maps) e interação CRUD (Criar, Ler, Atualizar, Deletar).

## Briefing:

* **Cliente:** Startup "GourmetGo".
* **Missão:** Estamos criando um aplicativo onde os usuários podem descobrir receitas online e salvá-las em seu caderno de receitas pessoal. O desafio é que uma receita não é apenas um título; ela tem uma lista de ingredientes e uma sequência de passos. Sua tarefa é construir o núcleo desta aplicação, garantindo que os dados das receitas sejam armazenados de forma estruturada e eficiente no Firebase.

## Escopo do Projeto:

* **API:** Integrar com uma API de receitas, como a TheMealDB (gratuita e de fácil uso).
* **Autenticação:** Sistema de login/registro para que cada usuário tenha seu próprio caderno.
* **Busca e Visualização:** Uma tela para buscar receitas da API e visualizar os detalhes (imagem, ingredientes, instruções).
* **Funcionalidade Principal ("Salvar no Caderno"):**
  * Ao salvar uma receita, os dados devem ser copiados da API e armazenados no Firestore do usuário.
  * A estrutura no Firestore deve ser bem organizada, salvando a lista de ingredientes como um array de strings e as instruções como um map ou array de strings.
* **Tela "Meu Caderno":** Exibir a lista de receitas salvas pelo usuário, lendo os dados do Firestore. Ao clicar em uma receita, o usuário deve ver os detalhes completos.
* **Deleção:** Permitir que o usuário remova uma receita de seu caderno.

## Critérios de Avaliação Especifico:

* **Modelagem de Dados no Firestore:** A estrutura do documento da receita é eficiente e usa corretamente tipos de dados complexos (arrays/maps) para ingredientes e instruções.
* **Implementação do CRUD:** As funcionalidades de salvar (Create), ler (Read) e deletar (Delete) receitas no caderno do usuário funcionam perfeitamente.
* **Integração com API:** A busca e a exibição de dados da API TheMealDB são funcionais.
* **Autenticação e Regras de Segurança:** O sistema de login funciona e as regras do Firestore garantem que um usuário só possa acessar seu próprio caderno de receitas.