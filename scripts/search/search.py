import os

class SearchExtensionFiles:
    def __init__(self, extension_search: str) -> None:
        self.file_search = extension_search
    
    def __resource_memory(self):
        for (self.path, _, filenames) in os.walk('../../lib/'):
            yield filenames
         
    def search(self) -> None:
        if (self.__resource_memory() is None): return
        
        for files in self.__resource_memory():
            for f in files:
                _files.append(self.path + os.sep + f)
        
        if len(_files) < 1: return
        
        for _fl in _files:
            if self.file_search in _fl[-5:]:
                print(_fl)
_files = []