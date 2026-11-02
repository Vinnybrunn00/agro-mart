
import psutil, sys

class Disk:
    @staticmethod
    def _disk():
        if (sys.platform == 'linux'):
            return psutil.disk_usage(path='/')
        else:
            return psutil.disk_usage(path='C:/')
    
    @staticmethod
    def byteGB(bytes: int): return bytes / (1024 **3)
    
    def disk_total_GB(self) -> str: 
        disk = self._disk()
        disk_total = self.byteGB(disk.total)
        return f'Total: {disk_total:.0f} GB'
    
    def disk_used_GB(self) -> str: 
        disk = self._disk()
        disk_used = self.byteGB(disk.used)
        return f'Usado: {disk_used:.0f} GB'
    
    def disk_free_GB(self) -> str: 
        disk = self._disk()
        disk_free = self.byteGB(disk.free)
        return f'Livre: {disk_free:.0f} GB'
