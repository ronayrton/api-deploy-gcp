from fastapi import FastAPI
from database import engine, Base
from routers.alunos import alunos_router
from routers.cursos import cursos_router
from routers.matriculas import matriculas_router

# Criação das tabelas no banco de dados
Base.metadata.create_all(bind=engine)

# Instância da aplicação FastAPI
app = FastAPI(
    title="API de Gestão Escolar! API atualizada via CI/CD no Cloud Run!",
    description="""
        Esta API fornece endpoints para gerenciar alunos, cursos e turmas, em uma instituição de ensino.
        
        Permite realizar diferentes operações em cada uma dessas entidades.
    """,
    version="1.0.0 - Teste de CI/CD com FastAPI e Google Cloud Run",
)

# Rota raiz para teste e saúde do serviço
@app.get("/")
def read_root():
    return {"message": "🚀 API de Gestão Escolar online e funcionando!"}

# Rotas principais
app.include_router(alunos_router, tags=["alunos"])
app.include_router(cursos_router, tags=["cursos"])
app.include_router(matriculas_router, tags=["matriculas"])
