# core/command_result.py
from dataclasses import dataclass


@dataclass
class CommandResult:
    success: bool
    message: str = ""
    should_stop: bool = False