# 🚀 Aula 03 - Imersão Cloud DevOps (Alura + Google Cloud)

Este projeto é baseado na Aula 03 da Imersão Cloud DevOps da Alura em parceria com a Google Cloud. O objetivo principal é realizar o **deploy automatizado de uma API FastAPI containerizada** na **Google Cloud Platform**, utilizando o **Cloud Run** e um pipeline de **CI/CD com GitHub Actions**.

---

## 🛠 Tecnologias Utilizadas

- Python + FastAPI
- Docker
- GitHub Actions
- Google Cloud Platform:
  - Cloud Run
  - Artifact Registry
  - Cloud Build (opcional)
- Terraform (opcional)

---

## 🎯 Objetivo

Realizar o deploy automatizado da aplicação com CI/CD utilizando GitHub Actions + GCP, simulando um ambiente real de entrega contínua.

---

## 📦 Etapas do Projeto

- [x] Containerizar aplicação com Docker
- [x] Configurar pipeline de CI/CD com GitHub Actions
- [x] Autenticar no Google Cloud
- [x] Criar repositório no Artifact Registry
- [x] Fazer build e push da imagem localmente
- [x] Deploy no Cloud Run com imagem container
- [ ] (Opcional) Provisionar recursos com Terraform

---

## 📁 Estrutura do Repositório

```bash
📁 api-deploy-gcp
├── .github/
│   └── workflows/
│       └── deploy.yml
├── app/
├── Dockerfile
├── requirements.txt   
├── docker-compose.yml
├── .dockerignore
├── .gitignore
└── README.md
```

## 🔐 Autenticação no Google Cloud (manual)
```bash
gcloud auth login
gcloud config set project imersao-devops-api
```

## ☁️ Deploy com Cloud Build (opcional - usando --source .)
```bash
gcloud run deploy --source . --port=8000 --region us-central1 --allow-unauthenticated --project imersao-devops-api
```

## ❌ Possível erro:
```bash
ERROR: (gcloud.run.deploy) PERMISSION_DENIED: Build failed because the service account is missing required IAM permissions.
```

## 🔧 Solução:
Conceda permissões à conta de serviço do Cloud Build:

```bash
gcloud projects add-iam-policy-binding imersao-devops-api --member="serviceAccount:1034286558722@cloudbuild.gserviceaccount.com" --role="roles/run.admin"

gcloud projects add-iam-policy-binding imersao-devops-api \
  --member="serviceAccount:1034286558722@cloudbuild.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"
```

### ✅ Deploy recomendado: Build local + Push para Artifact Registry + Deploy via imagem

1. Ative o Artifact Registry
bash
gcloud services enable artifactregistry.googleapis.com

2. Crie o repositório Docker
bash
gcloud artifacts repositories create containers \
  --repository-format=docker \
  --location=us-central1 \
  --description="Repositório de containers da aplicação"

3. Faça o build da imagem localmente
bash
docker build -t us-central1-docker.pkg.dev/imersao-devops-api/containers/api:v1 .

4. Autentique o Docker com o GCP
bash
gcloud auth configure-docker us-central1-docker.pkg.dev

5. Faça o push da imagem
bash
docker push us-central1-docker.pkg.dev/imersao-devops-api/containers/api:v1

6. Deploy no Cloud Run
bash
gcloud run deploy api \
  --image us-central1-docker.pkg.dev/imersao-devops-api/containers/api:v1 \
  --region us-central1 \
  --platform managed \
  --allow-unauthenticated

7. Verifique o endpoint gerado
text
Service [api] revision [api-xxxx] has been deployed and is serving 100 percent of traffic at:
https://api-xxxxx-uc.a.run.app
Acesse esse link no navegador ou teste com curl.

🔁 GitHub Actions CI/CD
O deploy automatizado está configurado via GitHub Actions em .github/workflows/deploy.yml, que:

Faz build da imagem Docker

Faz push para o Artifact Registry

Faz deploy no Cloud Run

Verifique se os segredos GCP_SA_KEY, GCP_PROJECT_ID e GCP_REGION estão configurados no GitHub (Settings > Secrets and variables > Actions).

✅ Vantagens da abordagem com imagem
Item	Benefício
Build local	Fácil de identificar e corrigir erros no Dockerfile
Push para ArtifactRegistry	Controle de versões de imagens
Deploy mais rápido	Sem depender do Cloud Build
Fluxo realista de DevOps	Usado em ambientes com GitLab/GitHub CI/CD

📌 Projeto GCP usado
ID do Projeto: imersao-devops-api
Região: us-central1

📚 Recursos adicionais
Documentação oficial Cloud Run

FastAPI Docs

Google Cloud CLI

Alura - Imersão Cloud DevOps

👨‍💻 Autor
Projeto realizado como parte da Imersão Cloud DevOps (Alura + Google Cloud).
Para fins de estudo, portfólio e prática de deploy automatizado com ferramentas modernas de DevOps.


gcloud projects add-iam-policy-binding imersao-devops-api --member="serviceAccount:github-actions-deployer@imersao-devops-api.iam.gserviceaccount.com" --role="roles/artifactregistry.writer"
### INTERFACE WEB GCP

## Configure o segredo no GitHub novamente
Crie um novo:
Nome: GCP_SA_KEY
Valor: cole todo o conteúdo do novo JSON (inclusive {})


Confirme que os outros secrets estão ok
GCP_PROJECT_ID → deve ser imersao-devops-api
GCP_REGION → ex: southamerica-east1

# Após recriar as credenciais mesmo erro de permissão

PROJECT_ID="imersao-devops-api"
SA_EMAIL="github-actions-deployer@imersao-devops-api.iam.gserviceaccount.com"

# Escrita no Artifact Registry
gcloud projects add-iam-policy-binding imersao-devops-api  --member="serviceAccount:github-actions-deployer@imersao-devops-api.iam.gserviceaccount.com"  --role="roles/artifactregistry.writer"

# Permissão para gerenciar Cloud Run
gcloud projects add-iam-policy-binding imersao-devops-api  --member="serviceAccount:github-actions-deployer@imersao-devops-api.iam.gserviceaccount.com" --role="roles/run.admin"

# Permissão para atuar como conta de serviço
gcloud projects add-iam-policy-binding imersao-devops-api --member="serviceAccount:github-actions-deployer@imersao-devops-api.iam.gserviceaccount.com"  --role="roles/iam.serviceAccountUser"
