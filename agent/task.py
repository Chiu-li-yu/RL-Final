"""
Task configuration — single source of truth for task-specific paths and prompts.

Adding a new task only requires adding a new Task instance here.
"""

from dataclasses import dataclass
from pathlib import Path

from agent.prompts import CODE_COMPLETE_PROMPT, SPEC_TO_RTL_PROMPT

_BASE_DIR             = Path(__file__).parent.parent
_DATASET_SPEC_TO_RTL  = _BASE_DIR / "verilog-eval" / "dataset_spec-to-rtl"
_DATASET_CODE_COMPLETE = _BASE_DIR / "verilog-eval" / "dataset_code-complete-iccad2023"


@dataclass(frozen=True)
class Task:
    """
    Immutable configuration for one VerilogEval task variant.

    dataset_dir   — directory containing ref.sv, test.sv, and ifc.txt
    prompt_dir    — directory containing _prompt.txt (natural language descriptions)
    system_prompt — passed directly to the Gemini chat session
    name          — used as output path component and task identifier
    """
    name:          str
    dataset_dir:   Path
    prompt_dir:    Path
    system_prompt: str


SPEC_TO_RTL = Task(
    name="spec-to-rtl",
    dataset_dir=_DATASET_SPEC_TO_RTL,
    prompt_dir=_DATASET_SPEC_TO_RTL,
    system_prompt=SPEC_TO_RTL_PROMPT,
)

CODE_COMPLETE_ICCAD2023 = Task(
    name="code-complete-iccad2023",
    dataset_dir=_DATASET_CODE_COMPLETE,
    prompt_dir=_DATASET_SPEC_TO_RTL,   # _prompt.txt files are shared with spec-to-rtl
    system_prompt=CODE_COMPLETE_PROMPT,
)

ALL_TASKS: dict[str, Task] = {
    SPEC_TO_RTL.name:             SPEC_TO_RTL,
    CODE_COMPLETE_ICCAD2023.name: CODE_COMPLETE_ICCAD2023,
}


def get_task(name: str) -> Task:
    """
    Resolve a task name string (e.g. from CLI --task) to a Task object.

    Raises:
        ValueError: unknown task name
    """
    if name not in ALL_TASKS:
        raise ValueError(f"Unknown task: {name!r}. Must be one of {list(ALL_TASKS)}")
    return ALL_TASKS[name]
