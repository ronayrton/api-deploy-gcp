#!/bin/bash

# VARIÁVEIS CONFIGURÁVEIS
PROJECT_ID="escolar-devops-001"
REGION="us-central1"
REPO_NAME="container-api"
SERVICE_NAME="api-escolar"
SERVICE_ACCOUNT_NAME="github-actions"

echo "✅ [1/6] Ativando APIs necessárias..."
gcloud services enable run.googleapis.com artifactregistry.googleapis.com iam.googleapis.com

echo "✅ [2/6] Criando repositório Artifact Registry: $REPO_NAME..."
gcloud artifacts repositories create $REPO_NAME \
  --repository-format=docker \
  --location=$REGION \
  --description="Repositório para API Escolar"

echo "✅ [3/6] Criando conta de serviço: $SERVICE_ACCOUNT_NAME..."
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name="GitHub Actions Deploy"

SA_EMAIL="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

echo "✅ [4/6] Concedendo permissões à conta de serviço..."
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_EMAIL" \
  --role="roles/iam.serviceAccountUser"

echo "✅ [5/6] Gerando chave JSON da conta de serviço..."
gcloud iam service-accounts keys create ./github-actions-key.json \
  --iam-account=$SA_EMAIL

echo "✅ [6/6] Deploy inicial no Cloud Run com imagem hello..."
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/cloudrun/hello \
  --platform=managed \
  --region=$REGION \
  --allow-unauthenticated

echo ""
echo "🎉 FINALIZADO! Agora faça:"
echo "1. Abra github-actions-key.json e copie o conteúdo."
echo "2. Vá até seu repositório no GitHub > Settings > Secrets and variables > Actions."
echo "3. Adicione os seguintes secrets:"
echo "   - GCP_SA_KEY      (cole o conteúdo do JSON)"
echo "   - GCP_PROJECT_ID  = $PROJECT_ID"
echo "   - GCP_REGION      = $REGION"
echo ""
echo "✨ Pronto para usar seu pipeline!"
