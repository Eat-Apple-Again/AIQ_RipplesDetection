# register.py
import requests
import json
from aiq.tool import FunctionBaseConfig, register_function, FunctionInfo
from aiq.builder import Builder

class CurrentStatusConfig(FunctionBaseConfig, name="current_status"):
    pass

@register_function(config_type=CurrentStatusConfig)
async def current_status(config: CurrentStatusConfig, builder: Builder):
    def _fn(frames_dir: str) -> str:
        try:
            url = "http://host.docker.internal:8002/detect/current_status"
            params = {"frames_dir": frames_dir}
            resp = requests.get(url, params=params)
            resp.raise_for_status()
            return json.dumps(resp.json(), ensure_ascii=False)
        except requests.RequestException as e:
            return json.dumps({"error": str(e)}, ensure_ascii=False)

    yield FunctionInfo.from_fn(
        _fn,
        description="Get latest splash pixel count and paths from FastAPI."
    )

class PastStatusConfig(FunctionBaseConfig, name="past_status"):
    pass

@register_function(config_type=PastStatusConfig)
async def past_status(config: PastStatusConfig, builder: Builder):
    def _fn(frames_dir: str) -> str:
        try:
            url = "http://host.docker.internal:8002/detect/past_status"
            params = {"frames_dir": frames_dir}
            resp = requests.get(url, params=params)
            resp.raise_for_status()
            return json.dumps(resp.json(), ensure_ascii=False)
        except requests.RequestException as e:
            return json.dumps({"error": str(e)}, ensure_ascii=False)

    yield FunctionInfo.from_fn(
        _fn,
        description="Get pixel counts, trend, and heatmap paths from FastAPI."
    )