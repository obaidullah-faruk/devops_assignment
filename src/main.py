import logging
import os
from contextlib import asynccontextmanager

from fastapi import FastAPI
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.logging import LoggingInstrumentor
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from pythonjsonlogger import jsonlogger

from src.core.init_db import create_db_and_tables
from src.modules.hero.api import router as hero_router

# Configure JSON logging
log_handler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter(
    "%(asctime)s %(levelname)s [%(name)s] [%(filename)s:%(lineno)d] [trace_id=%(otelTraceID)s span_id=%(otelSpanID)s resource.service.name=%(otelServiceName)s] - %(message)s",
    rename_fields={"levelname": "level", "asctime": "timestamp"}
)
log_handler.setFormatter(formatter)
logging.basicConfig(level=logging.INFO, handlers=[log_handler])
logger = logging.getLogger(__name__)

# Initialize tracing for ADOT / OTLP
resource = Resource.create({"service.name": "devops-assessment-fastapi"})
tracer_provider = TracerProvider(resource=resource)
otlp_endpoint = os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://localhost:4317")
otlp_exporter = OTLPSpanExporter(endpoint=otlp_endpoint, insecure=True)
span_processor = BatchSpanProcessor(otlp_exporter)
tracer_provider.add_span_processor(span_processor)
trace.set_tracer_provider(tracer_provider)

# Instrument logging to inject trace_id and span_id
LoggingInstrumentor().instrument(set_logging_format=True)


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Application starting up, initializing database tables...")
    await create_db_and_tables()
    yield


app = FastAPI(lifespan=lifespan)


@app.get("/health", tags=["Health"], summary="ALB / container health check")
async def health_check():
    """
    container health check
    """
    return {"status": "healthy", "service": "devops-assessment-fastapi"}


app.include_router(hero_router)

# Instrument the FastAPI app
FastAPIInstrumentor.instrument_app(app)

