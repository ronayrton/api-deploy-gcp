# 📘 API de Gestão Escolar com FastAPI + CI/CD no Google Cloud Run

Este projeto implementa uma API REST para gerenciar alunos, cursos e matrículas em uma instituição de ensino. Utiliza **FastAPI** como framework principal, com deploy automatizado via **GitHub Actions** para o **Google Cloud Run**, e armazenamento de imagens no **Artifact Registry**.

---

## 🚀 Tecnologias Utilizadas

* **FastAPI** — Framework moderno para APIs com Python
* **Uvicorn** — Servidor ASGI de alto desempenho
* **Google Cloud Run** — Plataforma gerenciada para containers
* **Artifact Registry** — Armazenamento de imagens Docker
* **GitHub Actions** — Pipeline de CI/CD automatizado
* **Cloud Build** — Para build de imagens Docker

---

## 🏗️ Estrutura do Projeto

```
.
├── app.py                   # Arquivo principal FastAPI
├── routers/
│   ├── alunos.py
│   ├── cursos.py
│   └── matriculas.py
├── database.py              # Configuração do banco de dados
├── requirements.txt
├── Dockerfile
└── .github/
    └── workflows/
        └── deploy.yml       # Pipeline CI/CD
```

---

## 🧪 Endpoints

Após o deploy, acesse:

* `GET /` → Mensagem de status da API
* `GET /docs` → Documentação interativa Swagger
* `GET /redoc` → Documentação Redoc

Rotas adicionais:

* `/alunos` — CRUD de alunos
* `/cursos` — CRUD de cursos
* `/matriculas` — CRUD de matrículas

---

## 🔁 Deploy Automatizado (CI/CD)

O deploy ocorre automaticamente ao realizar um push na branch `main`.

### Fluxo de CI/CD via GitHub Actions:

1. Autentica no Google Cloud usando uma chave secreta (JSON)
2. Constrói a imagem Docker e envia ao Artifact Registry
3. Faz o deploy no Cloud Run com `--allow-unauthenticated`
4. Garante acesso público com `add-iam-policy-binding`

> 🔐 A chave JSON está armazenada no GitHub Secrets como `GCLOUD_SERVICE_KEY`.

---

## 📋 Checklist de Provisionamento Manual (Pré-CI/CD)

Antes de realizar o commit que dispara o pipeline, é necessário:

### ✅ Etapas realizadas via interface do Google Cloud:

* [x] **Criar projeto** via Console
* [x] **Atribuir papéis ao usuário**, como:

  * Administrador da organização
  * Editor ou Administrador de Projeto
  * Administrador do Cloud Run (`roles/run.admin`)
* [x] **Criar chave JSON** de uma conta de serviço
* [x] **Adicionar a chave no GitHub Secrets** como `GCLOUD_SERVICE_KEY`

### ✅ Ativar APIs no projeto:

```bash
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

### ✅ Commit final

Após essas configurações, basta fazer um `git commit` com alteração no projeto para disparar o pipeline e concluir o deploy.

---

## 🐳 Docker

### Dockerfile

```dockerfile
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8080
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]
```

---

## ☕ Comandos GCP Essenciais

### Criar repositório no Artifact Registry:

```bash
gcloud artifacts repositories create api-docker \
  --repository-format=docker \
  --location=us-central1 \
  --description="Repositório Docker para API"
```

### Atribuir permissão pública ao serviço:

```bash
gcloud run services add-iam-policy-binding api-devops \
  --member="allUsers" \
  --role="roles/run.invoker" \
  --region=us-central1 \
  --platform=managed
```

---

## 🧱 Erros Enfrentados e Soluções

### ❌ Erro 1: `PERMISSION_DENIED` ao executar `add-iam-policy-binding`

* **Causa**: A conta de serviço usada no CI/CD não tinha o papel `roles/run.admin`
* **Solução**: Atribuir `Cloud Run Admin` à conta de serviço no IAM

### ❌ Erro 2: `403 Forbidden` ao acessar a URL do Cloud Run

* **Causa**: A política IAM do serviço exigia autenticação
* **Solução**: Garantir o uso de `--allow-unauthenticated` e adicionar binding IAM com `roles/run.invoker`

### ❌ Erro 3: Build travava no `gcloud builds submit`

* **Causa**: APIs gcloud services enable cloudbuild.googleapis.com não habilitadas
* **Solução**: ativar APIs e monitorar logs pelo console do Cloud Build

---

## 💬 Commits Sugeridos

* `feat: adiciona rota '/' para exibir status da API`
* `chore(ci): permite acesso público via IAM no Cloud Run`
* `fix: corrige permissão da conta de serviço no deploy`
* `ci: adiciona etapa de deploy no Cloud Run via GitHub Actions`

---

## ✅ Resultado Final

✅ API publicada com sucesso no **Google Cloud Run**
✅ Deploy automatizado com **CI/CD**
✅ Requisições públicas liberadas com sucesso
✅ Pronto para produção, integração com banco e escalabilidade

---

## 👨‍💻 Autor

Projeto desenvolvido por **Ronayrton** durante experimentos com CI/CD na GCP usando GitHub Actions, FastAPI e Cloud Run.
