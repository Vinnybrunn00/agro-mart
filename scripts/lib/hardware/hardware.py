import platform, psutil, os, sys, threading
from time import sleep
from psutil._common import scpufreq, shwtemp

class Hardware:
    
    def __init__(self):
        self.stop = threading.Event()
    
    @staticmethod
    def device_name() -> str: return platform.node()
    
    @staticmethod
    def system_name() -> str: return platform.platform()
    
    @staticmethod
    def system_version() -> str: return platform.release()
    
    @staticmethod
    def system_architecture() -> str: return platform.architecture()[0]
    
    @staticmethod
    def system_type() -> str: return platform.machine()

    @staticmethod
    def cpu_count() -> str | None:
        cpu_count = os.cpu_count()
        
        if (cpu_count is None):
            return None
        
        return f'- {cpu_count} CPUs lógicas no sistema'
    
    @staticmethod
    def _cpu_frequence() -> (scpufreq | None):
        if not (sys.platform == 'linux'):
            return None

        return psutil.cpu_freq()
    
    def current_cpu_frequence(self) -> str | None:
        cpu_frequence = self._cpu_frequence()

        if (cpu_frequence is None):
            return None

        return f'Atual: {cpu_frequence.current:.2f} MHz'

    def max_cpu_frequence(self) -> (str | int):
        cpu_frequence = self._cpu_frequence()
        
        if (cpu_frequence is None):
            return None
    
        return f'Max: {cpu_frequence.max:.2f} MHz'
    
    def min_cpu_frequence(self) -> (str | int):
        cpu_frequence = self._cpu_frequence()
        
        if (cpu_frequence is None):
            return None
        
        return f'Min: {cpu_frequence.min:.2f} MHz'
    
    ### INFO SENSORS TEMPERATURE ###
    @staticmethod
    def _sensors_temperature() -> (list[shwtemp] | str):
        if not (sys.platform == 'linux'):
            return None
        
        acpitz = psutil.sensors_temperatures()['acpitz']
        
        if (len(acpitz) < 1): raise RuntimeError('indisponivel')
        
        return acpitz
    
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
    
    def _wait_key(self):
        input("Pressione Enter para parar...\n\n")
        self.stop.set()
    
    def cpu_temperature_current_stream(self) -> str:   
        threading.Thread(target=self._wait_key, daemon=True).start()
        
        while (not self.stop.is_set()):
            out = self.cpu_temperature_current()
            print(out)
            sleep(1)
            
        return 'Finalizado!'
            
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