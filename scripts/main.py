from lib.disk.disk import Disk
from lib.hardware.hardware import Hardware
from lib.memory.memory import Memory

def _main():
    
    # disk
    disk = Disk()
    
    disk_total = disk.disk_total_GB()
    disk_free = disk.disk_free_GB()
    disk_used = disk.disk_used_GB()
    
    # hardware
    hardware = Hardware()
    
    # temperature
    cpu_temperature_current = hardware.cpu_temperature_current()
    cpu_temperature_high = hardware.cpu_temperature_high()
    cpu_temperature_critical = hardware.cpu_temperature_critical()
    #cpu_temperature_current_stream = hardware.cpu_temperature_current_stream()
    
    # cpu info
    device_name = hardware.device_name()
    system_name = hardware.system_name()
    system_version = hardware.system_version()
    system_architecture = hardware.system_architecture()
    system_type = hardware.system_type()

    # cpu frequence
    current_cpu_frequence = hardware.current_cpu_frequence()
    max_cpu_frequence = hardware.max_cpu_frequence()
    min_cpu_frequence = hardware.min_cpu_frequence()
    
    # memory
    memory = Memory()
    
    memory_usage = memory.memory_usage()
    memory_total = memory.memory_total()
    memory_percent = memory.memory_percent()
    memory_used = memory.memory_used()
    memory_free = memory.memory_free()
    

if (__name__ == "__main__"):
    _main()