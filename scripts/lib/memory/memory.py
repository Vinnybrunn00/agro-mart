from typing import Any, Generator

import psutil

class Memory:
    def __init__(self):
        self.VIRTUAL_MEMORY = psutil.virtual_memory()
    
    def _memory(self): return self.VIRTUAL_MEMORY
    
    def _format_memory_in_GB(self, bytes: int) -> int: return round(bytes / (1024 ** 3))
    
    @staticmethod
    def memory_usage() -> Generator[list, Any, None]:
        pr_list = []
        for p in psutil.process_iter():
            process = p.as_dict(['name', 'memory_percent'])
            if (process['memory_percent'] > 0):
                pr_list.append(process)
        yield sorted(pr_list, key=lambda pr: pr['memory_percent'], reverse=True)[:10]
    
    def memory_total(self) -> str:
        memory = self._memory()
        memory_total = self._format_memory_in_GB(memory.total)
        return f'{memory_total} GB'
    
    def memory_percent(self) -> str:
        memory = self._memory()
        return f'{memory.percent} %'
    
    def memory_used(self) -> str:
        memory = self._memory()
        memory_used = self._format_memory_in_GB(memory.used)
        return f'{memory_used} GB'
    
    def memory_free(self) -> str:
        memory = self._memory()
        memory_free = self._format_memory_in_GB(memory.free)
        return f'{memory_free} GB'