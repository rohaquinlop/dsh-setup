---
name: uv
description: Python command reference for uv. Load before any Python work — running a script or tests, adding a dependency, creating a virtual environment, or installing a CLI tool. The house rule is uv for every Python action; python, python3, pip, pip3, and venv are fallbacks only.
whenToUse: The task touches Python, a pyproject.toml, a uv.lock, a script, or a dependency install.
---

# uv

Use `uv` for Python work. Do not call `python`, `python3`, `pip`, `pip3`,
`python -m venv`, or `pipx` when `uv` can do the job.

## The one rule

| Instead of | Run |
|---|---|
| `python script.py` | `uv run script.py` |
| `python -m pytest` | `uv run pytest` |
| `pip install requests` | `uv add requests` |
| `pip install -r requirements.txt` | `uv pip install -r requirements.txt` (legacy) |
| `python -m venv .venv` | `uv venv` |
| `pip install ruff && ruff .` | `uvx ruff check .` |

Fallbacks, all acceptable:

- `uv` is not installed.
- The project uses poetry, conda, or a non-uv virtualenv with its own lock file.
  Follow that project's convention.
- A shebang or a Docker image without uv needs a bare interpreter.

## Projects

```bash
uv init my-project        # new project
uv init                   # in the current directory
uv sync                   # build the env from pyproject.toml and uv.lock
uv add requests           # add a dependency
uv add 'requests==2.31.0'
uv remove requests
uv lock --upgrade-package requests
uv tree
uv build
```

Project files:

- `pyproject.toml` — metadata, dependencies, `[tool.uv]`.
- `.python-version` — interpreter for the environment.
- `uv.lock` — commit it. Never edit it by hand.
- `.venv/` — created by uv, never committed.

## Scripts

```bash
uv run script.py
uv run script.py arg1 arg2
uv run --with rich script.py            # one-off dependency
uv run --with 'rich>12,<13' script.py
uv run --python 3.12 script.py
uv run --no-project script.py           # ignore the current project
printf 'print("hi")' | uv run -
```

Inline metadata for a standalone script:

```python
#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = ["httpx"]
# ///
import httpx
print(httpx.get("https://example.com"))
```

```bash
uv init --script script.py --python 3.12
uv add --script script.py requests rich
uv lock --script script.py
```

## Tools

```bash
uvx ruff check .                  # one-off, cached
uvx --from httpie http --help     # command name differs from package
uvx ruff@latest check .
uvx --with mkdocs-material mkdocs --help

uv tool install ruff              # persistent
uv tool upgrade ruff
uv tool upgrade --all
uv tool update-shell              # put the bin dir on PATH
```

Use `uv run` instead of `uvx` for a tool that must see project dependencies or
import the project: pytest, mypy, a project-local CLI.

## Python versions

```bash
uv python install 3.12
uv python list
uv python pin 3.12
uv run --python 3.12 main.py
```

## pip-compatible fallback

Only for an existing pip-style workflow or a migration:

```bash
uv venv
uv pip install -r requirements.txt
uv pip install requests
uv pip freeze
uv pip compile requirements.in -o requirements.txt
```

Prefer `uv add`, `uv sync`, `uv lock`, and `uv run` for new work.

Reference: https://docs.astral.sh/uv/guides/
