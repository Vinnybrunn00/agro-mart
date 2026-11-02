from pathlib import Path
import os

class SearchSintaxForDart:
    def __init__(self, sintax: str) -> None:
        self.search_code = sintax
        self.abs = Path().absolute()
        
    def __resource_memory(self):
        for (self.path, _, files) in os.walk('../../lib/'):
            yield files
            
    def __read_code(self, file: str) -> str | bool:
        try:
            with open(file, 'r') as _file:
                read_file = _file.read()
                return read_file
        except Exception: 
            return False
        
    def scan_file(self):
        for _file in self.__resource_memory():
            try:
                for file in _file:
                    _join_path = self.path + os.sep + file  
                    read_code = self.__read_code(_join_path)
                    if self.search_code in read_code:
                        print(f'{self.abs}/{_join_path}')
            except Exception as err:
                return err