#!/usr/bin/env python3
"""
 * scripts/lib/disk/disk.py
 *
 * Informações de uso do disco principal (total, usado e livre).
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 02/11/2026
"""

import psutil, sys

# Informações de uso do disco principal
class Disk:
    # Retorna o uso do disco raiz ('/' no Linux, 'C:/' no Windows)
    @staticmethod
    def _disk():
        if (sys.platform == 'linux'):
            return psutil.disk_usage(path='/')
        else:
            return psutil.disk_usage(path='C:/')
    
    # Converte bytes para GB
    @staticmethod
    def byteGB(bytes: int): return bytes / (1024 **3)
    
    # Espaço total do disco
    def disk_total_GB(self) -> str: 
        disk = self._disk()
        disk_total = self.byteGB(disk.total)
        return f'Total: {disk_total:.0f} GB'
    
    # Espaço usado
    def disk_used_GB(self) -> str: 
        disk = self._disk()
        disk_used = self.byteGB(disk.used)
        return f'Usado: {disk_used:.0f} GB'
    
    # Espaço livre
    def disk_free_GB(self) -> str: 
        disk = self._disk()
        disk_free = self.byteGB(disk.free)
        return f'Livre: {disk_free:.0f} GB'
