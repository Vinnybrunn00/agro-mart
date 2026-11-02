#!/usr/bin/env python3

"""
 * scripts/monitor/monitor_memory_cpu_device_debug_flutter_app.py
 *
 * Monitora CPU e memória de um app Android via adb e grava num CSV.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 02/11/2026
"""

import csv
import re
import subprocess
import sys
import time
from datetime import datetime

# Pacote do app (1º argumento), intervalo de leitura e arquivo de saída
PACKAGE = sys.argv[1] if len(sys.argv) > 1 else "com.exemplo.meuapp"
INTERVAL = 1.0  # segundos
OUT = f"flutter_logs/perf_{datetime.now():%Y-%m-%d_%H-%M}.csv"

# Executa um comando no shell do dispositivo via adb
def adb(*args: str) -> str:
    return subprocess.run(
        ["adb", "shell", *args], capture_output=True, text=True
    ).stdout.strip()

# PID do app, ou None se não estiver rodando
def pid_do_app() -> str | None: return adb("pidof", PACKAGE) or None

# Uso de CPU (%) do processo pelo top
def cpu(pid: str) -> float | None:
    out = adb("top", "-b", "-n", "1", "-q", "-p", pid, "-o", "%CPU")
    try:
        return float(out.splitlines()[-1])
    except (ValueError, IndexError):
        return None

# Memória total (PSS) do processo em MB pelo dumpsys
def memoria_mb(pid: str) -> float | None:
    out = adb("dumpsys", "meminfo", pid)
    m = re.search(r"TOTAL(?: PSS:)?\s+(\d+)", out)
    return int(m.group(1)) / 1024 if m else None

# Lê CPU e memória a cada INTERVAL e grava no CSV até Ctrl+C
def main() -> None:
    import os
    os.makedirs("flutter_logs", exist_ok=True)

    pid = pid_do_app()
    if not pid:
        sys.exit(f"App {PACKAGE} não está rodando.")

    print(f"Monitorando {PACKAGE} (pid {pid}) → {OUT}  [Ctrl+C para parar]")
    with open(OUT, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["horario", "cpu_%", "memoria_mb"])
        try:
            while True:
                c, m = cpu(pid), memoria_mb(pid)
                agora = datetime.now().strftime("%H:%M:%S")
                w.writerow([agora, c, f"{m:.1f}" if m else None])
                f.flush()
                print(f"{agora}  CPU {c}%  MEM {m:.1f} MB" if m else agora)
                time.sleep(INTERVAL)
        except KeyboardInterrupt:
            print("\nFinalizado.")

if __name__ == "__main__": main()