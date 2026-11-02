#!/usr/bin/env python3
"""
 * scripts/lib/hardware/hardware.py
 *  
 * Informações do sistema, CPU (quantidade e frequência) e
 * temperatura dos sensores.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 02/11/2026
"""

import platform, psutil, os, sys, threading
from time import sleep
from psutil._common import scpufreq, shwtemp

# Informações de hardware, sistema e CPU
class Hardware:
    
    def __init__(self):
        # Sinal para parar o stream de temperatura
        self.stop = threading.Event()
    
    # Nome do dispositivo na rede
    @staticmethod
    def device_name() -> str: return platform.node()
    
    # Nome completo do sistema operacional
    @staticmethod
    def system_name() -> str: return platform.platform()
    
    # Versão (release) do sistema
    @staticmethod
    def system_version() -> str: return platform.release()
    
    # Arquitetura (ex: 64bit)
    @staticmethod
    def system_architecture() -> str: return platform.architecture()[0]
    
    # Tipo da máquina (ex: x86_64)
    @staticmethod
    def system_type() -> str: return platform.machine()

    # Quantidade de CPUs lógicas
    @staticmethod
    def cpu_count() -> str | None:
        cpu_count = os.cpu_count()
        
        if (cpu_count is None):
            return None
        
        return f'- {cpu_count} CPUs lógicas no sistema'
    
    # Frequência da CPU (somente Linux)
    @staticmethod
    def _cpu_frequence() -> (scpufreq | None):
        if not (sys.platform == 'linux'):
            return None

        return psutil.cpu_freq()
    
    # Frequência atual
    def current_cpu_frequence(self) -> str | None:
        cpu_frequence = self._cpu_frequence()

        if (cpu_frequence is None):
            return None

        return f'Atual: {cpu_frequence.current:.2f} MHz'

    # Frequência máxima
    def max_cpu_frequence(self) -> (str | int):
        cpu_frequence = self._cpu_frequence()
        
        if (cpu_frequence is None):
            return None
    
        return f'Max: {cpu_frequence.max:.2f} MHz'
    
    # Frequência mínima
    def min_cpu_frequence(self) -> (str | int):
        cpu_frequence = self._cpu_frequence()
        
        if (cpu_frequence is None):
            return None
        
        return f'Min: {cpu_frequence.min:.2f} MHz'
    
    ### INFO SENSORS TEMPERATURE ###
    # Leituras do sensor 'acpitz' (somente Linux)
    @staticmethod
    def _sensors_temperature() -> (list[shwtemp] | str):
        if not (sys.platform == 'linux'):
            return None
        
        acpitz = psutil.sensors_temperatures()['acpitz']
        
        if (len(acpitz) < 1): raise RuntimeError('indisponivel')
        
        return acpitz
    
    # Temperatura atual (usa a última leitura do sensor)
    def cpu_temperature_current(self) -> (str | RuntimeError):
        try:
            temperature = self._sensors_temperature()
            current = 0
            
            for item in temperature:
                current =  item.current
            
            if (current is None): return 'Temperatura "current" Indisponível.'
            return f'Atual: {current}ºC'
        except RuntimeError as err:
            return err
    
    # Aguarda Enter para encerrar o stream
    def _wait_key(self):
        input("Pressione Enter para parar...\n\n")
        self.stop.set()
    
    # Mostra a temperatura a cada 1s até o usuário apertar Enter
    def cpu_temperature_current_stream(self) -> str:   
        threading.Thread(target=self._wait_key, daemon=True).start()
        
        while (not self.stop.is_set()):
            out = self.cpu_temperature_current()
            print(out)
            sleep(1)
            
        return 'Finalizado!'
            
    # Temperatura considerada alta pelo sensor
    def cpu_temperature_high(self) -> (str | RuntimeError):
        try:
            temperature = self._sensors_temperature()
            high = 0
            
            for item in temperature:
                high =  item.high
                    
            if (high is None): return 'Temperatura "high" Indisponível'
                    
            return f'Máxima: {high}ºC'
        except RuntimeError as err:
            return err
    
    # Temperatura crítica do sensor
    def cpu_temperature_critical(self) -> str:
        try:
            temperature = self._sensors_temperature()
            critical = 0
            
            for item in temperature:
                critical = item.critical
        
            if (critical is None): return 'Temperatura "critical" indisponível'
        
            return f'Máxima: {critical}ºC'
        except RuntimeError as err:
            return err