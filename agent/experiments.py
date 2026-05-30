"""
Experiment registry — single source of truth for all ablation study configurations.

Adding a new experiment:  add one Experiment entry to ALL_EXPERIMENTS.
Callers (evaluate.py, run.py) never hardcode enabled_tools; they import from here.

Fields:
  id               — CLI identifier (--exp value)
  enabled_tools    — frozenset of allowed tool names; None = all tools
  max_attempts     — compile_and_test call limit per run_agent() call
  independent_runs — number of independent run_agent() calls per problem
                     (1 = single session with memory; >1 = no-memory ablation)
  description      — human-readable one-liner for CLI help and logs
"""

from __future__ import annotations
from dataclasses import dataclass


# compile_and_test and synthesize are always required; everything else is optional.
_CORE_TOOLS: frozenset[str] = frozenset({"compile_and_test", "synthesize"})


@dataclass(frozen=True)
class Experiment:
    id:               str
    enabled_tools:    frozenset[str] | None   # None = all registered tools
    max_attempts:     int
    independent_runs: int
    description:      str


ALL_EXPERIMENTS: dict[str, Experiment] = {
    "agent": Experiment(
        id="agent",
        enabled_tools=None,
        max_attempts=5,
        independent_runs=1,
        description="完整 Agent（所有工具 + 記憶 + feedback）",
    ),
    "no_debug_hints": Experiment(
        id="no_debug_hints",
        enabled_tools=_CORE_TOOLS | {"decompose_spec"},
        max_attempts=5,
        independent_runs=1,
        description="移除 get_debug_hints（Ablation）",
    ),
    "no_decompose": Experiment(
        id="no_decompose",
        enabled_tools=_CORE_TOOLS | {"get_debug_hints"},
        max_attempts=5,
        independent_runs=1,
        description="移除 decompose_spec（Ablation）",
    ),
    "no_helper_tools": Experiment(
        id="no_helper_tools",
        enabled_tools=_CORE_TOOLS,
        max_attempts=5,
        independent_runs=1,
        description="僅 compile_and_test + synthesize，移除所有輔助工具",
    ),
    "no_memory": Experiment(
        id="no_memory",
        enabled_tools=None,
        max_attempts=1,
        independent_runs=5,
        description="無記憶（5 次獨立 session，每次僅輸入題目描述）",
    ),
}


def get_experiment(id: str) -> Experiment:
    """Resolve a CLI experiment name to its Experiment config. Raises ValueError if unknown."""
    if id not in ALL_EXPERIMENTS:
        raise ValueError(
            f"Unknown experiment: {id!r}. Must be one of {list(ALL_EXPERIMENTS)}"
        )
    return ALL_EXPERIMENTS[id]
