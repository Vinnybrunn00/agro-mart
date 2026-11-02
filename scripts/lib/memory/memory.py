#!/usr/bin/env python3

"""
 * scripts/lib/memory/memory.py
 *
 * Informações de memória RAM e processos que mais consomem memória.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 02/11/2026
"""

from typing import Any, Generator

import psutil

# Informações de memória RAM
class Memory:
    def __init__(self):
        # Snapshot da memória no momento da criação
        self.VIRTUAL_MEMORY = psutil.virtual_memory()
    
    def _memory(self): return self.VIRTUAL_MEMORY
    
    # Converte bytes para GB (arredondado)
    def _format_memory_in_GB(self, bytes: int) -> int: return round(bytes / (1024 ** 3))
    
    # Top 10 processos que mais consomem memória
    @staticmethod
    def memory_usage() -> Generator[list, Any, None]:
        pr_list = []
        for p in psutil.process_iter():
            process = p.as_dict(['name', 'memory_percent'])
            if (process['memory_percent'] > 0):
                pr_list.append(process)
        yield sorted(pr_list, key=lambda pr: pr['memory_percent'], reverse=True)[:10]
    
    # Memória total
    def memory_total(self) -> str:
        memory = self._memory()
        memory_total = self._format_memory_in_GB(memory.total)
        return f'{memory_total} GB'
    
    # Percentual de memória em uso
    def memory_percent(self) -> str:
        memory = self._memory()
        return f'{memory.percent} %'
    
    # Memória usada
    def memory_used(self) -> str:
        memory = self._memory()
        memory_used = self._format_memory_in_GB(memory.used)
        return f'{memory_used} GB'
    
    # Memória livre
    def memory_free(self) -> str:
        memory = self._memory()
        memory_free = self._format_memory_in_GB(memory.free)
        return f'{memory_free} GB'