import logging
from fastapi import APIRouter, Depends, Query

from src.core.dependencies import get_service
from src.modules.hero.schemas import HeroCreate, HeroRead
from src.modules.hero.service import HeroService

logger = logging.getLogger(__name__)
router = APIRouter(prefix="/heroes", tags=["Heroes"])


@router.post("/", response_model=HeroRead)
async def create_hero(
    data: HeroCreate,
    service: HeroService = Depends(get_service),
):
    logger.info("Creating a new hero", extra={"hero_name": data.name})
    return await service.create(data)


@router.get("/", response_model=list[HeroRead])
async def list_heroes(
    service: HeroService = Depends(get_service),
    offset: int = 0,
    limit: int = Query(default=100, le=100),
):
    logger.info("Fetching list of heroes", extra={"offset": offset, "limit": limit})
    return await service.list(offset, limit)


@router.get("/{hero_id}", response_model=HeroRead)
async def get_hero(hero_id: int, service: HeroService = Depends(get_service)):
    logger.info("Fetching hero details", extra={"hero_id": hero_id})
    return await service.get(hero_id)


@router.delete("/{hero_id}")
async def delete_hero(hero_id: int, service: HeroService = Depends(get_service)):
    logger.info("Deleting hero", extra={"hero_id": hero_id})
    return await service.delete(hero_id)
