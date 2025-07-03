import os
from fastapi import FastAPI
from dotenv import load_dotenv
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader, StorageContext, ServiceContext
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.vector_stores.postgres import PGVectorStore
from llama_index.core.node_parser import SimpleNodeParser

# Load env vars
load_dotenv()

app = FastAPI()

# Load settings
DOC_DIR = os.getenv("RAG_DOC_DIR", "./rag_documents")
DB_HOST = os.getenv("RAG_DB_HOST", "localhost")
DB_PORT = os.getenv("RAG_DB_PORT", "5432")
DB_NAME = os.getenv("RAG_DB_NAME")
DB_USER = os.getenv("RAG_DB_USER")
DB_PASS = os.getenv("RAG_DB_PASSWORD")

VECTOR_STORE = PGVectorStore.from_params(
    database=DB_NAME,
    host=DB_HOST,
    password=DB_PASS,
    port=int(DB_PORT),
    user=DB_USER,
    table_name="rag_documents",
)

embed_model = OllamaEmbedding(model_name="nomic-embed-text")
service_context = ServiceContext.from_defaults(embed_model=embed_model)
storage_context = StorageContext.from_defaults(vector_store=VECTOR_STORE)

@app.post("/ingest")
def ingest_documents():
    docs = SimpleDirectoryReader(DOC_DIR).load_data()
    index = VectorStoreIndex.from_documents(
        docs, service_context=service_context, storage_context=storage_context
    )
    return {"status": "Documents ingested", "count": len(docs)}

@app.get("/query")
def query(q: str):
    index = VectorStoreIndex.from_vector_store(VECTOR_STORE, service_context=service_context)
    response = index.as_query_engine().query(q)
    return {"question": q, "answer": str(response)}

