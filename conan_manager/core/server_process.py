"""Dedicated server process detection."""
from __future__ import annotations

import csv
import os
import subprocess
from dataclasses import dataclass
from io import StringIO
from typing import Callable, Iterable

from ..models.server import ProcessInfo, ServerProcessStatus

SERVER_PROCESS_NAMES = {
    "conansandboxserver.exe",
    "conansandboxserver-win64-shipping.exe",
}


class ServerProcessService:
    def __init__(self, process_provider: Callable[[], Iterable[ProcessInfo]] | None = None):
        if process_provider is None:
            if os.name == "nt":
                self.process_provider = tasklist_process_provider
            else:
                self.process_provider = ps_process_provider
        else:
            self.process_provider = process_provider

    def status(self) -> ServerProcessStatus:
        matches = [
            process for process in self.process_provider()
            if process.name.casefold() in SERVER_PROCESS_NAMES
        ]
        return ServerProcessStatus(running=bool(matches), processes=matches)


def tasklist_process_provider() -> list[ProcessInfo]:
    try:
        result = subprocess.run(
            ["tasklist", "/FO", "CSV", "/NH"],
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
    except OSError:
        return []
    if result.returncode != 0:
        return []
    processes: list[ProcessInfo] = []
    for row in csv.reader(StringIO(result.stdout)):
        if len(row) < 2:
            continue
        try:
            pid = int(row[1])
        except ValueError:
            continue
        processes.append(ProcessInfo(pid=pid, name=row[0]))
    return processes


def ps_process_provider() -> list[ProcessInfo]:
    try:
        # Use args to avoid the 15-char limit of comm
        result = subprocess.run(
            ["ps", "-e", "-o", "pid,args"],
            check=False,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
    except OSError:
        return []
    if result.returncode != 0:
        return []
    processes: list[ProcessInfo] = []
    lines = result.stdout.splitlines()[1:]  # Skip header
    for line in lines:
        parts = line.strip().split(maxsplit=1)
        if len(parts) < 2:
            continue
        try:
            pid = int(parts[0])
        except ValueError:
            continue
        
        # Extract the executable name from the args (which might include wine/proton prefixes)
        # Typically looks like: \path\to\ConanSandboxServer.exe -log ...
        # Or: Z:\path\to\ConanSandboxServer.exe
        args = parts[1]
        
        # Get the first token as the executable path
        exe_path = args.split()[0]
        # Get just the filename
        exe_name = exe_path.replace("\\", "/").split("/")[-1]
        
        processes.append(ProcessInfo(pid=pid, name=exe_name))
    return processes

