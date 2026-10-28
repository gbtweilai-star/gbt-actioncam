# actioncam

**One capability bit from GBT V8, packaged standalone.** No. 319 of 341,
`video` domain (Video).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 动作镜头控制系统（拍子表制）：10 种动作运镜语法（POV 主观/甩镜/急推/手持抖/推拉/环绕/打击帧停格）× 4 种机位角度（仰/俯/平/荷兰角）× 画质档（hd/fhd/cinema）；拍子表 manifest 为唯一真相，逐拍渲染 + 总装调色；零逗号表达式纪律 + 种子锁定；plan/seg/build/add/rm/qc

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-actioncam.git
cd gbt-actioncam
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_actioncam info                  # capability card
python -m gbt_actioncam spec --json           # machine-readable contract
python -m gbt_actioncam check --payload '{}'
python -m gbt_actioncam run   --payload '{}'
```

Real `info` output from this machine:

```text
actioncam  (video)  v1.0.0
----------------------------------------
动作镜头控制系统（拍子表制）：10 种动作运镜语法（POV 主观/甩镜/急推/手持抖/推拉/环绕/打击帧停格）× 4 种机位角度（仰/俯/平/荷兰角）× 画质档（hd/fhd/cinema）；拍子表 manifest 为唯一真相，逐拍渲染 + 总装调色；零逗号表达式纪律 + 种子锁定；plan/seg/build/add/rm/qc

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : hd, fhd, cinema
```

Wire a real implementation:

```python
from gbt_actioncam import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（3 个）**：`hd`、`fhd`、`cinema`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.11s
```

## Provenance

| field | value |
|---|---|
| capability | `actioncam` |
| domain | `video` |
| handler | `actioncam` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [video/actioncam](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/video/actioncam.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
